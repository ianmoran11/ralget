rm(list = ls())
library("tidyverse")
library("tidygraph")
library("devtools")
library("DiagrammeR")
# devtools::document()
# devtools::install(".")
devtools::load_all()
devtools::load_all("../ralplan/")

first_drafting  <- v(name = "first_drafting \n (section) \n (Ian)")
first_revising  <- v(name = "first_revising")
second_drafting  <- v(name = "second_drafting")
second_revising  <- v(name = "second_revising")
third_revising  <- v(name = "third_revising")
combine_ebls  <- v(name = "combine_ebls")
stakeholder_feedback  <- v(name = "stakeholder_feedback")
EB_feedback  <- v(name = "EB_feedback")

kerry_edits <- v(name = "kerry_edits")

  
first_draft <- e(name = "first_draft")
first_ebl <- e(name = "first_ebl")
first_ebl1 <- e(name = "first_ebl1")
first_ebl2 <- e(name = "first_ebl2")
first_draft <- e(name = "first_draft_with_comments")
ebl_draft <- e(name = "ebl_draft")
revised_ebls <- e(name = "revised_ebls")
second_draft <- e(name = "second_draft")
third_draft <- e(name = "third_draft")
eb_revisions <- e(name = "eb_revisions")
draft_figures <- e(name= "draft_figures")


section_process <- 
(first_drafting * first_draft * first_revising) +
(first_drafting * first_ebl) +
(first_revising * second_draft * second_draft ) +
((first_ebl + first_ebl1 + first_ebl2) * combine_ebls * ebl_draft) +
(ebl_draft * stakeholder_feedback *revised_ebls ) +
(revised_ebls * (second_revising + EB_feedback)) +
(EB_feedback * eb_revisions) +
(second_draft * second_revising) +
(second_revising * third_draft) + 
(second_revising * draft_figures) + 
(draft_figures * kerry_edits) + 
(third_draft * third_revising) + 
(eb_revisions * third_revising) +
NULL

section_process %>% diagram()
section_process %>% plot()
section_process %>% compact()





