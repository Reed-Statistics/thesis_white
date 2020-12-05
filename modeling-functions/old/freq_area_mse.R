freq_area_mse <- function(data, formula, small_area) {
  # Load packages
  library(tidyverse)
  library(sae)
  
  # Create model frame
  model_frame <- model.frame(formula, data) %>%
    dplyr::mutate(small_area = data[[small_area]])
  colnames(model_frame) <- c("y", "x", "small_area")
  model_frame
  
  # Data wrangle to area level
  diry <- direct_estimate(model_frame,
                          "y",
                          "small_area") %>%
    mutate(var = SD ^ 2)
  
  dirx <- direct_estimate(model_frame,
                          "x",
                          "small_area")
  dat <- left_join(dirx, diry, by = c("Domain" = "Domain"))
  
  # Fit the model
  mod <- sae::mseFH(formula = dat$Direct.y ~ dat$Direct.x,
                      vardir = dat$var)
  mod
  
}