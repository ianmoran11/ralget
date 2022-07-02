rm(list = ls())
.rs.restartR()
library("tidyverse")
library("tidygraph")
library("devtools")
library("DiagrammeR")
# devtools::document()
# devtools::install(".")
library(tidyverse)
library("hrbrthemes")
library(tidygraph)
library(lubridate)
devtools::load_all()

reverse_min <- function(x){-min(as.numeric(x))}

A  <- Task(name = "A",time =  duration("1 hour"),  priority = 1, resources = list(R1 = 1))
B  <- Task(name = "B",time =  duration("2 hour"),  priority = 1, resources = list(R1 = 1))
C  <- Task(name = "C",time =  duration("1 hour"),  priority = 1, resources = list(R1 = 1))
D  <- Task(name = "D",time =  duration("3 hour"),  priority = 1, resources = list(R1 = 1))
E  <- Task(name = "E",time =  duration("1 hour"),  priority = 1, resources = list(R1 = 1))
FF  <- Task(name = "F",time =  duration("2 hour"),  priority = 1, resources = list(R1 = 1))
G  <- Task(name = "G",time =  duration("2 hour"),  priority = 1, resources = list(R2 = 1))
H  <- Task(name = "H",time =  duration("1 hour"),  priority = 1, resources = list(R2 = 1))
I  <- Task(name = "I",time =  duration("1.5 hour"),priority = 1, resources = list(R2 = 1))
J  <- Task(name = "J",time =  duration("1 hour"),  priority = 1, resources = list(R2 = 1))
K  <- Task(name = "K",time =  duration("3 hour"),  priority = 1, resources = list(R2 = 1))
L  <- Task(name = "L",time =  duration("1 hour"),  priority = 1, resources = list(R2 = 1))

plan <- 
  C(after(B)) + 
  B(after(A)) +
  FF(after(E)) + 
  E(after(D)) +
  L(after(K)) + 
  K(after(J)) +
  I(after(H)) + 
  H(after(G))

result <- 
  execute( 
    plan, 
    resource_pool = list(R1 = 2, R2 = 2),
    timeslots = create_work_times(n = 4*24,15)
  )

p <- plot_executed_plan(result)
p + ggtitle("Activity Plan", "Resource1 = 1, Resource2 = 1") 



A  <- v(name = "A",time =  duration("1 hour"),  priority = 1, resources = list(R1 = 1))
B  <- v(name = "B",time =  duration("2 hour"),  priority = 1, resources = list(R1 = 1))
C  <- v(name = "C",time =  duration("1 hour"),  priority = 1, resources = list(R1 = 1))
D  <- v(name = "D",time =  duration("3 hour"),  priority = 1, resources = list(R1 = 1))
E  <- v(name = "E",time =  duration("1 hour"),  priority = 1, resources = list(R1 = 1))
FF <- v(name = "F",time =  duration("2 hour"),  priority = 1, resources = list(R1 = 1))
G  <- v(name = "G",time =  duration("2 hour"),  priority = 1, resources = list(R2 = 1))
H  <- v(name = "H",time =  duration("1 hour"),  priority = 1, resources = list(R2 = 1))
I  <- v(name = "I",time =  duration("1.5 hour"),priority = 1, resources = list(R2 = 1))
J  <- v(name = "J",time =  duration("1 hour"),  priority = 1, resources = list(R2 = 1))
K  <- v(name = "K",time =  duration("3 hour"),  priority = 1, resources = list(R2 = 1))
L  <- v(name = "L",time =  duration("1 hour"),  priority = 1, resources = list(R2 = 1))
plan %>% form %>% order_plan()

vplan <- 
B*C + 
A*B +
E*FF + 
D*E +
K*L + 
J*K +
H*I + 
G*H

vresult <- 
execute( 
  vplan, 
  resource_pool = list(R1 = 2, R2 = 2),
  timeslots = create_work_times(n = 4*24,15),
  ralget = TRUE
  )
load_all()
plot_executed_plan(vresult)

