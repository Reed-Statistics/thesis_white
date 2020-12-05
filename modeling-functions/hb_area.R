hb_area <- function(data, formula, small_area) {
  # Load packages
  library(tidyverse)
  library(hbsae)
  
  # Create model frame
  model_frame <- model.frame(formula, data) %>%
    dplyr::mutate(small_area = data[[small_area]])
  colnames(model_frame) <- c("y", "x", "small_area")
  # Direct X
  X <- model_frame %>%
    group_by(small_area) %>%
    dplyr::summarize(
      mean_x = mean(x)
    ) %>%
    dplyr::arrange(small_area)

  # Compute direct estimate
  dir <- direct_estimate(model_frame, "y", "small_area") %>%
    dplyr::mutate(var = SD^2)
  
  # Fit the model
  mod <- fSAE.Area(est.init = dir$Direct,
            var.init = dir$var,
            X = X %>% dplyr::select(mean_x))
  
  # Calculate CoV
  CoV <- hbsae::SE(mod) / dir$Direct
  ## Add to model object
  mod$CoV <- CoV
  
  # Print model
  mod
}

# Example model specification:

mod_area <- hb_area(data = m333,
                    formula = BIOLIVE_TPA ~ nlcd11,
                    small_area = "subsection")
