library("colorspace")

## qualitative palette
rainbow_hcl(12)

## a few useful diverging HCL palettes
diverging_hcl(7)
diverging_hcl(7, h = c(246, 40), c = 96, l = c(65, 90))
diverging_hcl(7, h = c(130, 43), c = 100, l = c(70, 90))
diverging_hcl(7, h = c(180, 70), c = 70, l = c(90, 95))
diverging_hcl(7, h = c(180, 330), c = 59, l = c(75, 95))
diverging_hcl(7, h = c(128, 330), c = 98, l = c(65, 90))
diverging_hcl(7, h = c(255, 330), l = c(40, 90))
diverging_hcl(7, c = 100, l = c(50, 90), power = 1)

## sequential palettes
sequential_hcl(12)
heat_hcl(12, h = c(0, -100), l = c(75, 40), c = c(40, 80), power = 1)
terrain_hcl(12, c = c(65, 0), l = c(45, 95), power = c(1/3, 1.5))
heat_hcl(12, c = c(80, 30), l = c(30, 90), power = c(1/5, 1.5))
rainbow_hcl(12)
desaturate(rainbow_hcl(12))

## diverging red-blue colors
diverging_hsv(7)
diverging_hcl(7, c = 100, l = c(50, 90))
desaturate(diverging_hsv(7))
desaturate(diverging_hcl(7, c = 100, l = c(50, 90)))

## diverging cyan-magenta colors
diverging_hcl(7, h = c(180, 330), c = 59, l = c(75, 95))
desaturate(diverging_hcl(7, h = c(180, 330), c = 59, l = c(75, 95)))

## heat and terrain colors
heat_hcl(12)
desaturate(heat_hcl(12))
terrain_hcl(12)
desaturate(terrain_hcl(12))

## different interfaces
identical(qualitative_hcl(6, "Pastel 1"),  qualitative_hcl(6, palette = "Pastel 1"))
identical(qualitative_hcl(6, "Pastel 1"),  qualitative_hcl(6, h = 0, c = 35, l = 85))
identical(qualitative_hcl(6, "Pastel 1"),  qualitative_hcl(6, h = c(0, 300), c = 35, l = 85))
identical(qualitative_hcl(6, "Pastel 1"),  qualitative_hcl(6, h = c(0, NA), c = 35, l = 85))
identical(qualitative_hcl(6, "Pastel 1"),  qualitative_hcl(6, h1 = 0, c1 = 35, l1 = 85))
identical(qualitative_hcl(6, "Pastel 1"),  qualitative_hcl(6, h1 = 0, h2 = NA, c1 = 35, l1 = 85))
identical(qualitative_hcl(6, "Pastel 1"),  qualitative_hcl(6, h1 = 0, h2 = 300, c1 = 35, l1 = 85))
identical(sequential_hcl(7, "Grays"),      sequential_hcl(7, palette = "Grays"))
identical(sequential_hcl(7, "Grays"),      sequential_hcl(7, h = 0, c = 0, l = c(15, 98), power = 1.3))
identical(sequential_hcl(7, "Grays"),      sequential_hcl(7, h = 0, c. = 0, l = c(15, 98), power = 1.3))
identical(sequential_hcl(7, "Grays"),      sequential_hcl(7, c1 = 0, c2 = 0, l1 = 15, l2 = 98, p1 = 1.3))
identical(sequential_hcl(7, "Red-Yellow"), sequential_hcl(7, palette = "Red-Yellow"))
identical(sequential_hcl(7, "Red-Yellow"), sequential_hcl(7, h = c(10, 85), c = c(80, 10), l = c(25, 95), power = c(0.4, 1.3)))
identical(sequential_hcl(7, "Red-Yellow"), sequential_hcl(7, h = c(10, 85), c. = c(80, 10), l = c(25, 95), power = c(0.4, 1.3)))
identical(sequential_hcl(7, "Red-Yellow"), sequential_hcl(7, h1 = 10, h2 = 85, c1 = 80, c2 = 10, l1 = 25, l2 = 95, p1 = 0.4, p2 = 1.3))
identical(diverging_hcl(7, "Blue-Red 3"),  diverging_hcl(7, palette = "Blue-Red 3"))
identical(diverging_hcl(7, "Blue-Red 3"),  diverging_hcl(7, h = c(265, 12), c = 80, l = c(25, 95), power = 0.7))
identical(diverging_hcl(7, "Blue-Red 3"),  diverging_hcl(7, h1 = 265, h2 = 12, c1 = 80, l1 = 25, l2 = 95, p1 = 0.7))
