# This function produces the hierachical Bayesian unit-level small area estimation model.
# Currently, this function has not been generalized for more than one predictor. 

hb_unit <- function(data, formula, small_area, pop_data) {
  # Load packages
  library(tidyverse)
  library(hbsae)
  
  # Create model frame
  model_frame <- model.frame(formula, data) %>%
    dplyr::mutate(small_area = data[[small_area]])
  colnames(model_frame) <- c("y", "x", "small_area")
  
  # Area population sizes
  pop_size <- pop_data %>%
    dplyr::filter(zoneid %in% model_frame$small_area) %>%
    dplyr::select(zoneid, sum) %>%
    dplyr::rename(pop_size = sum) %>%
    dplyr::select(pop_size)
  
  # Create population means matrix
  pop_means <- pop_data %>%
    dplyr::filter(zoneid %in% model_frame$small_area) %>%
    dplyr::select(zoneid, mean) %>%
    dplyr::rename(x = mean) %>%
    column_to_rownames("zoneid")
  
  # Create lambda
  anova <- aov(y ~ small_area, data = model_frame)
  l <- summary(anova)[[1]]["small_area", "F value"]
  
  # Create scale and shape hyperparameters
  ## these are chosen from Ver Planck et al 
  alpha <- 2
  beta <- model_frame %>%
    group_by(small_area) %>%
    summarize(
      var = var(y)
    ) %>%
    summarize(scale = sum(var, na.rm = TRUE) / nrow(.)) %>%
    pull()

  df <- 2 * alpha
  scale <- beta / alpha
  
  # Fit the model
  mod <- fSAE.Unit(
    y = model.frame(formula, data = data)[, 1],
    X = data.frame(X = model.frame(formula, data = data)[,-1]),
    area = data[[small_area]],
    Narea = pop_size$pop_size,
    Xpop = pop_means,
    fpc = TRUE,
    # nu0 = df,
    # s20 = scale,
    lambda0 = l,
    silent = T
  )

  # Calculate CoV
  mean_y <- model_frame %>%
    dplyr::group_by(small_area) %>%
    dplyr::summarise(mean_y = mean(y))
  CoV <- hbsae::SE(mod) / mean_y$mean_y
  # CoV <- hbsae::relSE(mod)
  ## Add to model object
  mod$CoV <- CoV
  # Add IG prior params to model object
  mod$df <- df
  mod$scale <- scale

  # Print model
  mod
}
