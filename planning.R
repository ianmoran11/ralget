rm(list = ls())
library("tidyverse")
library("tidygraph")
library("devtools")
library("DiagrammeR")
load_all()

# Info gather process  
info <- 
(e("site")*v("scrape")*e("info.org")) +
e("info.org")*v("send home")*e("home.org") + 
(e("info")*v("update")*e("kpis.org")) +
e("kpis.org")*v("send home")*e("home.org") + 
(e("home.org")*v("orgzly search")) +
 NULL

# Capture process   
capture <- 
((e("task")+ e("project idea")+e("reference material")+ e("appointment"))*
    v("capture")*e("inbox.org")) + 
(e("inbox.org") * v("allocate") * (e("projects.org") + e("reference.org"))) + 
    NULL

# Prioritize   
prioritise <- 
((e("projects.org"))*v("identify next action")*e("home.org")) + 
  NULL

# 
execute <- 
((e("home.org")*v("orgzly search")*e("archive.org"))) +
((v("orgzly search")*e("")*v("allocate"))) + 
  NULL
 
monitor <-
  v("orgzly search")*e("widget")

capture + prioritise + execute + info + monitor



