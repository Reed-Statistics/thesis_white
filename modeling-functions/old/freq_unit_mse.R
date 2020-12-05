# This is currently *not* working

freq_unit_mse <- function(data, formula, small_area) {
  # Load packages
  library(tidyverse)
  library(sae)
  
  # Create model frame
  model_frame <- model.frame(formula, data) %>%
    dplyr::mutate(small_area = data[[small_area]])
  colnames(model_frame) <- c("y", "x", "small_area")
  
  # Area population sizes
  pop_size <- model_frame %>%
    dplyr::group_by(small_area) %>%
    dplyr::summarize(
      pop_size = n()
    ) 
  
  # Create population means matrix
  meanxpop <- model_frame %>%
    group_by(small_area) %>%
    summarize(
      x = mean(x)
    ) 
  
  # Fit the model
  mod <- pbmseBHF(
    formula = model_frame$y ~ model_frame$x,
    dom = model_frame$small_area,
    meanxpop = meanxpop,
    popnsize = pop_size,
    B = 50
  )
  mod
}
test <- freq_unit_mse(m333, BIOLIVE_TPA ~ nlcd11, "subsection")
