DiagrammeR::grViz(
    "
digraph rmarkdown{

rankdir = TB
node [ shape = box , fontname = Arial]
  'v3'; 'v1'; 'v2'; 'v5'

node [ shape = point , fontname = Arial]
  'v1 0.1'; 'v5 5.6'
  
subgraph cluster_1 {
		'v3'; 'v2';
    label = 'Cluster 1';
    fontname = Arial
    }


subgraph cluster_2 {
		'v2';
    label = 'Cluster 2';
    fontname = Arial
    }

  'v2' -> 'v3' [label = '2.3']
  'v1 0.1' -> 'v1' [label = '0.1']
  'v5' -> 'v5 5.6' [label = '5.6']
}
  "
)



DiagrammeR::grViz("
                  digraph G {
    splines=true;
    sep='+25,25';
    overlap=scalexy;
    nodesep=0.6;
    subgraph cluster_2 {
        label='ADD_MORE_PROBLEMS';
        subgraph cluster_4 {
            label='replacement';
            N2 [label='problem'];
            N3 [label='problem'];
            
        subgraph cluster_5 {
            label='replacement';
            N2 [label='problem'];
            N3 [label='problem'];
        }
            
        }
        subgraph cluster_3 {
            label='pattern';
            N1 [label='problem'];
        }
    }
}
                  ")