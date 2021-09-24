test_that("multiplication distributes with edges", {

expect_true(v("1")*(e("a")*v("2") + e("b")*v("3")) == (v("1")*e("a")*v("2") + v("1")*e("b")*v("3")))


expect_true((v("1")*e("a") + v("2")*e("b"))*v("3") == (v("1")*e("a")*v("3") + v("2")*e("b")*v("3")))


})
