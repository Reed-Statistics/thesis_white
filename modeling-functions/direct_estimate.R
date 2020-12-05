direct_estimate <- function(data, response, small_area) {
  # Load packages
  library(sae)
  
  # Create dataframe
  dat <- data.frame(
    y = data[[response]],
    small_area = data[[small_area]]
  )
  
  # Compute estimate
  sae::direct(y = dat$y,
              dom = dat$small_area,
              replace = TRUE)
}

# Example

# direct <- direct_estimate(m333,
#                 "BIOLIVE_TPA",
#                 "subsection")
