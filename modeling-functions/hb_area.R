hb_area <- function(data, formula, small_area) {
  # Load packages
  library(tidyverse)
  library(hbsae)
  
  # Create model frame
  model_frame <- model.frame(formula, data) %>%
    dplyr::mutate(small_area = data[[small_area]])
  colnames(model_frame) <- c("y", "x", "small_area")
  ## Aggregate to area-level
  model_frame <- model_frame %>%
    group_by(small_area) %>%
    dplyr::summarize(
      mean_y = mean(y),
      var_y = var(y),
      mean_x = mean(x)
    )
  head(model_frame)
  
  # Fit the model
  mod <- fSAE.Area(est.init = model_frame$mean_y,
            var.init = model_frame$var_y,
            X = model_frame %>% dplyr::select(mean_x))
  
  # Calculate CoV
  CoV <- hbsae::SE(mod) / model_frame$mean_y
  ## Add to model object
  mod$CoV <- CoV
  
  # Print model
  mod
}

# Example model specification:

# mod_area <- hb_area(data = m333,
#                     formula = BIOLIVE_TPA ~ nlcd11,
#                     small_area = "subsection")
