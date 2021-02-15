freq_area <- function(data, formula, small_area, pop_data) {
  # Load packages
  library(tidyverse)
  library(sae)
  
  # Create model frame
  model_frame <- model.frame(formula, data) %>%
    dplyr::mutate(small_area = data[[small_area]])
  colnames(model_frame) <- c("y", "x", "small_area")
  model_frame
  
  mf <- model.frame(formula, data)
  
  dir <- ps_dat %>% # need to have the ps_dat object in global env...
    filter(response %in% colnames(mf)[1],
           province %in% unique(data$province)) %>%
    arrange(subsection)
  
  # Direct X
  X <- pop_data %>%
    dplyr::filter(zoneid %in% model_frame$small_area) %>%
    dplyr::select(zoneid, mean) %>%
    dplyr::rename(mean_x = mean,
                  small_area = zoneid) %>%
    dplyr::arrange(small_area)
  
  # Join pop and dir
  dat <- dir %>%
    left_join(X, by = c("subsection" = "small_area"))

  # Fit the model
  # mod <- sae::eblupFH(formula = dat$Direct.y ~ dat$Direct.x,
  #                     vardir = dat$var)
  mod <- sae::mseFH(formula = dat$est ~ dat$mean_x,
                      vardir = dat$var)
  mod
  
}

# Example

# mod <- freq_area(m333, BIOLIVE_TPA ~ nlcd11, "subsection")
