library(dplyr)
library(palmerpenguins)

penguins |>
  filter(!is.na(body_mass_g)) |>
  group_by(species) |>
  summarise(
    n = n(),
    mean_mass_g = mean(body_mass_g),
    .groups = "drop"
  )
