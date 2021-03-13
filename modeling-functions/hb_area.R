hb_area <- function(data, formula, small_area, pop_data) {
  # Load packages
  library(tidyverse)
  library(hbsae)
  
  # Create unnamed model frame (to call correct y var in a filter)
  mf <- model.frame(formula, data)
  
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

  # Compute direct estimate
  mean <- direct_estimate(model_frame, "y", "small_area") %>%
    dplyr::mutate(var = SD^2)
  
  dir <- ps_dat %>%
    filter(response %in% colnames(mf)[1],
           province %in% unique(data$province)) %>%
    arrange(subsection)
  
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
  
  # Create lambda
  anova <- aov(y ~ small_area, data = model_frame)
  l <- summary(anova)[[1]]["small_area", "F value"]

  # Fit the model
  mod <- fSAE.Area(
    est.init = dir$est,
    var.init = dir$var,
    X = X %>% dplyr::select(mean_x),
    # nu0 = df,
    # s20 = scale,
    lambda0 = l
  )

  # Calculate CoV
   CoV <- hbsae::SE(mod) / mean$Direct
   mod$CoV <- CoV

  # Print model
  mod
}
