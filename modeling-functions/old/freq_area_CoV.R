freq_area_CoV <- function(data, formula, small_area, pop_data, B = 100) {
  # Load packages
  library(tidyverse)
  library(sae)
  
  # Create empty items for looping
  boots <- list()
  fit <- list()
  mean_df <- list()
  final <- data.frame()
  
  mf <- model.frame(formula, data)
  
  dir <- ps_dat %>% # need to have the ps_dat object in global env...
    filter(response %in% colnames(mf)[1],
           province %in% unique(data$province)) %>%
    arrange(subsection)
  
  # Create model frame
  model_frame <- model.frame(formula, data) %>%
    dplyr::mutate(small_area = data[[small_area]])
  colnames(model_frame) <- c("y", "x", "small_area")
  
  # Nest by small area
  data_nested <- model_frame %>%
    mutate(id = small_area) %>%
    group_by(small_area) %>%
    nest()
  
  # Direct X
  X <- pop_data %>%
    dplyr::filter(zoneid %in% model_frame$small_area) %>%
    dplyr::select(zoneid, mean) %>%
    dplyr::rename(mean_x = mean,
                  small_area = zoneid) %>%
    dplyr::arrange(small_area)
  
  # Bootstrap
  for(i in 1:B){
    for(j in 1:length(unique(model_frame$small_area))) {
      boots[[j]] <- sample_n(
        data_nested[[2]][[j]],
        size = length(data_nested[[2]][[j]]$y),
        replace = TRUE
      )
      boots_df <- bind_rows(boots) %>%
        left_join(X, by = c("id" = "small_area"))
    }
    
    # fit[[i]] <- freq_area(boots_df, y ~ mean_x, "id", pop_data)
    fit[[i]] <- sae::eblupFH(dir$est ~ X$mean_x, dir$var)

    mean_df[[i]] <- data.frame(fitted = as.numeric(fit[[i]]$eblup), # fitted = fit[[i]]$eblup[,1],
                               subsection = sort(unique(model_frame$small_area)))
    if (i %% 50 == 1) {
      print(i)
    }
  }
  
  # Create final output
  final <- bind_rows(mean_df) %>%
    group_by(subsection) %>%
    summarize(sd = sd(fitted, na.rm = TRUE))
  
  mean_y <- model_frame %>%
    dplyr::group_by(small_area) %>%
    dplyr::summarise(mean_y = mean(y, na.rm = TRUE))
  
  # freq_mod <- freq_area(model_frame, y ~ x, "small_area")
  
  # COV <- final$sd / freq_mod$eblup[,1]
  COV <- final$sd / mean_y$mean_y
  
  COV
}
