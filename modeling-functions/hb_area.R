hb_area <- function(data, formula, small_area, pop_data) {
  # Load packages
  library(tidyverse)
  library(hbsae)
  
  # Create model frame
  model_frame <- model.frame(formula, data) %>%
    dplyr::mutate(small_area = data[[small_area]])
  colnames(model_frame) <- c("y", "x", "small_area")
  
  # Direct X
  X <- pop_data %>%
    dplyr::filter(zoneid %in% model_frame$small_area) %>%
    dplyr::select(zoneid, mean) %>%
    dplyr::rename(mean_x = mean,
                  small_area = zoneid) %>%
    dplyr::arrange(small_area)
  
  # Auxilary info (should I include this?)
  # x <- model_frame %>%
  #   group_by(small_area) %>%
  #   dplyr::summarize(
  #     mean_x = mean(x)
  #   ) %>%
  #   dplyr::arrange(small_area)

  # Compute direct estimate
  dir <- direct_estimate(model_frame, "y", "small_area") %>%
    dplyr::mutate(var = SD^2)
  
  # These do not change the estimates... why?
  # Create scale and shape hyperparameters
  ## these are chosen from Ver Planck et al 
  alpha <- 2
  beta <- model_frame %>%
    group_by(small_area) %>%
    summarize(
      var = var(y)
    ) %>%
    summarize(scale = sum(var) / nrow(.)) %>%
    pull()

  df <- 2 * alpha
  scale <- beta / alpha

  # Fit the model
  mod <- fSAE.Area(
    est.init = dir$Direct,
    var.init = dir$var,
    X = X %>% dplyr::select(mean_x),
    nu0 = df,
    s20 = scale
  )

  # Calculate CoV
  # CoV <- hbsae::SE(mod) / dir$Direct
  CoV <- hbsae::relSE(mod)
  ## Add to model object
  mod$CoV <- CoV

  # Print model
  mod
}
