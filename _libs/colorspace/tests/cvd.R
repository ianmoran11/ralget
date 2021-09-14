library("colorspace")

## convert a hex color
simulate_cvd(c("#33ab20"), tritanomaly_cvd["6"][[1]])

## convert a built-in color
simulate_cvd("red", deutanomaly_cvd["8"][[1]])

## convert a mixed vector (hex and built-in)
simulate_cvd(c("green", "#ffc0cb"), protanomaly_cvd["8"][[1]])

## white and black almost unchanged
## (white becomes #FEFFFE or #FEFEFF due to rounding errors)
## simulate_cvd(c("white", "black"), deutanomaly_cvd["2"][[1]])
