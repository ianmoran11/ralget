test_that("multiplication works", {

joint_waiting_edges <- 
 (v("v1") * e("e1")) + 
 (v("v1") * e("e2")) 
  
one_row = joint_waiting_edges  %>% as_tibble() %>% nrow()  %>% `==`(1)

expect(one_row) 

})
