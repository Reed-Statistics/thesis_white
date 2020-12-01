# This function produces the hierachical Bayesian unit-level small area estimation model.
# Currently, this function has not been generalized for more than one predictor. 

hb_unit <- function(data, formula, small_area) {
  # Load packages
  library(tidyverse)
  library(hbsae)
  
  # Create model frame
  model_frame <- model.frame(formula, data) %>%
    dplyr::mutate(small_area = data[[small_area]])
  colnames(model_frame) <- c("y", "x", "small_area")
  
  # Area population sizes
  pop_size <- model_frame %>%
    dplyr::group_by(small_area) %>%
    dplyr::summarize(
      pop_size = n()
    ) %>%
    dplyr::select(pop_size) 
  
  # Create population means matrix
  xpop <- model_frame %>%
    group_by(small_area) %>%
    summarize(
      x = mean(x),
      y = mean(y)
    ) %>%
    column_to_rownames("small_area")
  
  pop_means <- xpop %>% dplyr::select(x)
  
  # Create lambda
  anova <- aov(y ~ small_area, data = model_frame)
  l <- summary(anova)[[1]]["small_area", "F value"]
  
  # Create scale and shape hyperparameters
  ## these are chosen from Ver Planck et al 
  shape <- 2
  scale <- model_frame %>%
    group_by(small_area) %>%
    summarize(
      var = var(y)
    ) %>%
    summarize(scale = sum(var) / nrow(.)) %>%
    pull()
  
  # Fit the model
  mod <- fSAE.Unit(
    y = model.frame(formula, data = data)[, 1],
    X = data.frame(X = model.frame(formula, data = data)[,-1]),
    area = data[[small_area]],
    Narea = pop_size$pop_size,
    Xpop = pop_means,
    fpc = FALSE,
    nu0 = shape,
    s20 = scale,
    lambda0 = l
  )
  
  # Calculate CoV
  CoV <- hbsae::SE(mod) / xpop$y
  ## Add to model object
  mod$CoV <- CoV
  
  # Print model
  mod
}

# Example model specification:

# mod_unit <- hb_unit(data = m333,
#                     formula = BIOLIVE_TPA ~ nlcd11,
#                     small_area = "subsection")
