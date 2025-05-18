extract_and_normalize_waiting_edges <- function(graph, col_name) {
  nodes_df <- activate(graph, "nodes") %>% as_tibble()
  col_sym <- sym(col_name) # Use symbol for non-standard evaluation

  if (!col_name %in% names(nodes_df)) {
    return(list()) # Return empty list if column doesn't exist
  }

  edges <- graph %>%
    activate(nodes) %>%
    pull(!!col_sym) %>%
    map_if(~ !inherits(., "ralget_edge_list"), ~ {
      e(name = ".tmp_ralget_placeholder_1") + e(name = ".tmp_ralget_placeholder_2") + .x
      }) %>%
    flatten() %>%
    keep(~ !startsWith(.x[["name"]], ".tmp_ralget_placeholder_"))

  if (length(edges) == 0) list() else edges
}

remove_edges_from_waiting_list <- function(graph, col_name, edges_to_remove) {
  nodes_df <- activate(graph, "nodes") %>% as_tibble()
  col_sym <- sym(col_name)

  if (!col_name %in% names(nodes_df) || length(edges_to_remove) == 0) {
    return(graph)
  }
  graph <- graph %>%
    activate(nodes) %>%
    mutate(!!col_sym := map(!!col_sym, function(node_edge_list) {
      if (is.null(node_edge_list) || length(node_edge_list) == 0) return(NULL)
      edges_kept <- keep(node_edge_list, ~ !(.x %in% edges_to_remove)) # Direct comparison
      if (length(edges_kept) == 0) NULL else edges_kept
    }))

  return(graph)
}

post_process_waiting_column <- function(graph, col_name) {
  nodes_df <- activate(graph, "nodes") %>% as_tibble()
  col_sym <- sym(col_name)

  if (!col_name %in% names(nodes_df)) {
    return(graph)
  }

  graph <- graph %>%
    activate(nodes) %>%
    mutate(!!col_sym := map(!!col_sym, function(x) {
        if (is.null(x)) return(NULL)

        processed_x <- x
        is_simple_list <- is.list(x) && !any(map_lgl(x, ~ inherits(., "ralget_edge") || inherits(., "ralget_edge_list")))

        if (is_simple_list) {
            if (length(x) == 0) return(NULL)
            # Assuming '+' combines elements appropriately for ralget
            processed_x <- tryCatch(reduce(x, `+`), error = function(e) {
                warning("Failed to reduce waiting edge list with '+': ", conditionMessage(e))
                x # Return original list on error
                })
        }

        if (is.character(processed_x)) {
           processed_x <- e(processed_x)
        } else if (is.list(processed_x)){
           processed_x <- map_if(processed_x, is.character, e)
        }

        if(is.list(processed_x) && length(processed_x) == 0) return(NULL)

        return(processed_x)
    }))

  return(graph)
}

ralget_graph_join_simplified <- function(vl, vr) {

  nodes_vl <- activate(vl, "nodes") %>% as_tibble()
  nodes_vr <- activate(vr, "nodes") %>% as_tibble()

  # Check which waiting edge columns exist
  has_vl_r <- ".waiting_edge_right" %in% names(nodes_vl)
  has_vl_l <- ".waiting_edge_left"  %in% names(nodes_vl)
  has_vr_l <- ".waiting_edge_left"  %in% names(nodes_vr)
  has_vr_r <- ".waiting_edge_right" %in% names(nodes_vr)

  # Determine if potential waiting edge processing is needed
  can_process_vl_vr <- has_vl_r && has_vr_l
  can_process_vr_vl <- has_vl_l && has_vr_r

  # If no relevant waiting edge columns exist, perform a simple join
  if (!can_process_vl_vr && !can_process_vr_vl) {
    return(tidygraph::graph_join(vr, vl))
  }

  # --- Extract and find shared waiting edges ---

  shared_edges_vlvr <- list() # Edges specified in vl(.waiting_edge_right) and vr(.waiting_edge_left)
  if (can_process_vl_vr) {
    vl_edges_r <- extract_and_normalize_waiting_edges(vl, ".waiting_edge_right")
    vr_edges_l <- extract_and_normalize_waiting_edges(vr, ".waiting_edge_left")
    shared_edges_vlvr <- intersect(vl_edges_r, vr_edges_l) # Cleaner intersection
  }

  shared_edges_vrvl <- list() # Edges specified in vr(.waiting_edge_right) and vl(.waiting_edge_left)
  if (can_process_vr_vl) {
    vl_edges_l <- extract_and_normalize_waiting_edges(vl, ".waiting_edge_left")
    vr_edges_r <- extract_and_normalize_waiting_edges(vr, ".waiting_edge_right")
    shared_edges_vrvl <- intersect(vl_edges_l, vr_edges_r)
  }

  # If relevant columns existed but no shared edges were found, perform simple join
  if (length(shared_edges_vlvr) == 0 && length(shared_edges_vrvl) == 0) {
    return(tidygraph::graph_join(vr, vl))
  }

  new_joins_list <- list()

  # Process vl -> vr shared edges
  if (length(shared_edges_vlvr) > 0) {
    # Assuming locate_share_edges(shared_edge, vl, vr) finds nodes and creates a join graph
    edge_checks_vlvr <- map(shared_edges_vlvr, locate_share_edges, vl = vl, vr = vr)
    graphs_to_join_vlvr <- map(edge_checks_vlvr, "graph") %>% keep(~ !is.null(.)) # Filter nulls
    if (length(graphs_to_join_vlvr) > 0) {
      new_joins_vlvr <- reduce(graphs_to_join_vlvr, tidygraph::graph_join) %>%
                        select(-matches("\\.waiting")) # Remove waiting cols from these new joins
      new_joins_list <- c(new_joins_list, list(new_joins_vlvr))
    }
  }

  # Process vr -> vl shared edges
  if (length(shared_edges_vrvl) > 0) {
    # Note swap: locate_share_edges(shared_edge, vl=vr, vr=vl)
    edge_checks_vrvl <- map(shared_edges_vrvl, locate_share_edges, vl = vr, vr = vl)
    graphs_to_join_vrvl <- map(edge_checks_vrvl, "graph") %>% keep(~ !is.null(.))
    if (length(graphs_to_join_vrvl) > 0) {
      new_joins_vrvl <- reduce(graphs_to_join_vrvl, tidygraph::graph_join) %>%
                        select(-matches("\\.waiting"))
      new_joins_list <- c(new_joins_list, list(new_joins_vrvl))
    }
  }

  # Combine all newly created joins
  new_joins_combined <- NULL
  if (length(new_joins_list) > 0) {
    new_joins_combined <- reduce(new_joins_list, tidygraph::graph_join)
  }

  # --- Remove processed waiting edges from original graphs ---
  vl_processed <- vl
  vr_processed <- vr

  if (length(shared_edges_vlvr) > 0) {
    vr_processed <- remove_edges_from_waiting_list(vr_processed, ".waiting_edge_left", shared_edges_vlvr)
    vl_processed <- remove_edges_from_waiting_list(vl_processed, ".waiting_edge_right", shared_edges_vlvr)
  }
  if (length(shared_edges_vrvl) > 0) {
    vl_processed <- remove_edges_from_waiting_list(vl_processed, ".waiting_edge_left", shared_edges_vrvl)
    vr_processed <- remove_edges_from_waiting_list(vr_processed, ".waiting_edge_right", shared_edges_vrvl)
  }

  # --- Final Join ---
  # Join the modified original graphs
  return_graph <- tidygraph::graph_join(vr_processed, vl_processed)

  # Join the newly created edges (if any)
  if (!is.null(new_joins_combined)) {
    # Need to be careful about node order preservation if graph_join relies on it.
    # Assuming standard tidygraph::graph_join behavior is sufficient.
    return_graph <- tidygraph::graph_join(return_graph, new_joins_combined)
  }

  # --- Post-processing ---
  # Clean up remaining waiting edge columns (combine lists, wrap chars)
  return_graph <- post_process_waiting_column(return_graph, ".waiting_edge_left")
  return_graph <- post_process_waiting_column(return_graph, ".waiting_edge_right")

  return(return_graph)
}