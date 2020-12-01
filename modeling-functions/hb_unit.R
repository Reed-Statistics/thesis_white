hb_unit <- function(data, formula, small_area) {
  # Load packages
  library(tidyverse)
  library(hbsae)
  
  # Area population sizes
  pop_size <- data %>%
    dplyr::group_by(data[[small_area]]) %>%
    dplyr::summarize(
      pop_size = n()
    ) %>%
    dplyr::select(pop_size) 
  
  # Create xpop
  
  # Create lambda
  
  # Run the model
  fSAE.Unit(y = model.frame(formula, data = data)[, 1],
            X = data.frame(X = model.frame(formula, data = data)[, -1]),
            area = data[[small_area]],
            Narea = pop_size$pop_size,
            Xpop = xpop,
            fpc = FALSE,
            nu0 = 2,
            s20 = 10,
            lambda0 = lambda)
}

hb_unit(data = m333,
        formula = BIOLIVE_TPA ~ nlcd11,
        small_area = "subsection")
