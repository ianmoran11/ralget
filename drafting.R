rm(list = ls())
.rs.restartR()
library("tidyverse")
library("tidygraph")
library("devtools")
library("DiagrammeR")
# devtools::document()
# devtools::install(".")
devtools::load_all()
# devtools::load_all("../ralplan/")

reverse_min <- function(x){-min(as.numeric(x))}

research                <- v(name = "Research",                              time =  duration("25 hours"),   priority = 2, resources = list(Author = 1))
draft_chapter           <- v(name = "Draft chapter",                         time =  duration("15 hours"),    priority = 1, resources = list(Author = 1))
draft_bottom_lines      <- v(name = "Draft bottom lines",                    time =  duration("10 hours"),    priority = 2, resources = list(Author = 1))
revise_bottom_lines     <- v(name = "Revise bottom lines",                   time =  duration("5 hours"),    priority = 2, resources = list(Author = 1))
present_bottom_lines    <- v(name = "Present bottom lines at EB",            time =  duration("15 hours"),    priority = 2, resources = list(Ab = 1))
review_draft_chapter    <- v(name = "Review draft chapter",                  time =  duration("5 hours"),    priority = 1, resources = list(Buddy = 1))
combine_ebls            <- v(name = "Combine EBLs",                          time =  duration("15 hours"),    priority = 1, resources = list(Aud = 1))
review_chapter_buddy    <- v(name = "Review chapter\n(Buddy)",               time =  duration("5 hours"),  priority = 1, resources = list(Buddy = 1))
review_chapter_audie    <- v(name = "Review chapter\n(Aud)",               time =  duration("5 hours"),  priority = 1, resources = list(Aud = 1))
review_chapter_mike     <- v(name = "Review chapter\n(M)",                time =  duration("5 hours"),  priority = 1, resources = list(M = 1))
review_chapter_abrie    <- v(name = "Review chapter\n(Ab)",               time =  duration("5 hours"),  priority = 1, resources = list(Ab = 1))
revise_chapter_1        <- v(name = "Re-draft chapter v.1\n(Author)",        time =  duration("5 hours"),  priority = 1, resources = list(Author = 1))
revise_chapter_2        <- v(name = "Re-draft chapter v.2\n(Author)",        time =  duration("5 hours"),    priority = 1, resources = list(Author = 1))
revise_chapter_3        <- v(name = "Re-draft chapter v.3\n(Author)",        time =  duration("5 hours"),    priority = 1, resources = list(Author = 1))
revise_chapter_4        <- v(name = "Re-draft chapter v.4\n(Author)",        time =  duration("5 hours"),    priority = 1, resources = list(Author = 1))
revise_chapter_5        <- v(name = "Re-draft chapter v.5\n(Author)",        time =  duration("5 hours"),   priority = 1, resources = list(Author = 1))
draft_landscape         <- v(name = "Combine chapters in ladscape document", time =  duration("20 hours"),   priority = 1, resources = list(K = 1))
get_stakeholder_feedback<- v(name = "Get stakeholder feedback",              time =  duration("15 hours"),   priority = 1, resources = list(Author = 1))
assess_graphics         <- v(name = "Assess graphics",                       time =  duration("5 hours"),   priority = 1, resources = list(Kerry = 1))


chapter_revisions <- 
(research * e("Findings") * draft_chapter) +
( draft_chapter   *     e("Chapter v.0.0") * review_chapter_buddy ) + 
(review_chapter_buddy * e("Chapter v.0.1") * revise_chapter_1) +
(revise_chapter_1 *     e("Chapter v.1.0") * review_chapter_audie )  +
(review_chapter_audie * e("Chapter v.1.1") * revise_chapter_2) +
(revise_chapter_2 *     e("Chapter v.2.0") * review_chapter_mike  )  +
(review_chapter_mike  * e("Chapter v.2.1") * revise_chapter_3 ) +
(revise_chapter_3 *     e("Chapter v.3.0") * review_chapter_abrie )  +
(review_chapter_abrie * e("Chapter v.3.1") * revise_chapter_4) +
NULL
  
ebl_revisions <- 
 (research                 * e("Findings")          * draft_bottom_lines) + 
 (draft_bottom_lines       * e("Bottom lines")      * combine_ebls) + 
 (                           e("Other bottom lines")      * combine_ebls) + 
 (combine_ebls             * e("Combined EBLs")      * get_stakeholder_feedback) + 
 (get_stakeholder_feedback * e("Stakeholder input") *  revise_chapter_2) +
 (get_stakeholder_feedback * e("Stakeholder input") * revise_bottom_lines ) +
 (revise_bottom_lines * e("Revised bottom lines") * present_bottom_lines) +
 (present_bottom_lines * e("EB feedback") * revise_chapter_3) +
  NULL

graphics_chapter_review <- 
(revise_chapter_1 * e("Graphics") * assess_graphics) +
(assess_graphics  * e("Revised graphics") * revise_chapter_3) + 
(revise_chapter_4 * e("Chapter v.5") * draft_landscape) +
(                   e("Other Chapters v.5") * draft_landscape) +
(draft_landscape  * e("Draft document")) + 
NULL

plan <- (graphics_chapter_review + chapter_revisions + ebl_revisions) 

plan %>% diagram()

vresult <- 
execute( 
  plan, 
  resource_pool = list(Author = 1, Buddy = 1, Aud = 1, Ab = 1, M  = 1, K = 1),
  timeslots = create_work_times(n = 500,60,start_time ="2022-07-06-9-00" ) %>% filter(!lubridate::wday(start_time,week_start = 1) %in% c(6,7)) %>% filter(lubridate::hour(start_time) %in% c(9:17)),
  ralget = TRUE
  )

plot_executed_plan(vresult)
