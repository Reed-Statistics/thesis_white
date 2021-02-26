# Summary Stats

median(res$cov_dirps)
median(res$cov_freq_area)
median(res$cov_freq_unit)
median(res$cov_hb_area)
median(res$cov_hb_unit)

median((res$est_dirps - res$est_hb_unit) / res$est_dirps)
median((res$est_dirps - res$est_hb_area) / res$est_dirps)

precision <- res %>%
  mutate(
    cov_dirps_under = case_when(cov_dirps < 0.1 ~ TRUE,
                                TRUE ~ FALSE),
    cov_freq_area_under = case_when(cov_freq_area < 0.1 ~ TRUE,
                                    TRUE ~ FALSE),
    cov_freq_unit_under = case_when(cov_freq_unit < 0.1 ~ TRUE,
                                    TRUE ~ FALSE),
    cov_hb_area_under = case_when(cov_hb_area < 0.1 ~ TRUE,
                                  TRUE ~ FALSE),
    cov_hb_unit_under = case_when(cov_hb_unit < 0.1 ~ TRUE,
                                  TRUE ~ FALSE)
  )

mean(precision$cov_dirps_under)
mean(precision$cov_freq_area_under)
mean(precision$cov_freq_unit_under)
mean(precision$cov_hb_area_under)
mean(precision$cov_hb_unit_under)

precision <- precision %>%
  mutate(
    upper_limit = est_dirps + 2*sd_dirps,
    lower_limit = est_dirps - 2*sd_dirps
  ) %>%
  mutate(
    hb_area_in = case_when(
      (est_hb_area < upper_limit & est_hb_area > lower_limit) ~ TRUE,
      TRUE ~ FALSE
    ),
    freq_area_in = case_when(
      (est_freq_area < upper_limit & est_freq_area > lower_limit) ~ TRUE,
      TRUE ~ FALSE
    ),
  )


upper_half <- precision %>%
  mutate(
    section = str_remove_all(subsection, "[:lower:]"),
    province = str_sub(section, end = -2)
  ) %>%
  filter(province == "M333") %>%
group_by(response) %>%
  filter(est_dirps >= median(est_dirps))

  

# data wrangling

estimates_long <- res %>%
  pivot_longer(cols = c("est_hb_unit", "est_hb_area", "est_freq_unit", "est_freq_area", "est_dirmean", "est_dirps"),
               names_to = "estimator",
               values_to = "estimate") %>%
  dplyr::select(-cov_hb_unit, -cov_hb_area, -cov_freq_unit, -cov_freq_area, -cov_dirmean, -cov_dirps, -cov_freq_area_boot) %>%
  mutate(estimator = stringr::str_sub(estimator, start = 5))

cov_long <- res %>%
  pivot_longer(cols = c("cov_hb_unit", "cov_hb_area", "cov_freq_unit", "cov_freq_area", "cov_dirmean", "cov_dirps"),
               names_to = "estimator",
               values_to = "cov") %>%
  dplyr::select(-est_hb_unit, -est_hb_area, -est_freq_unit, -est_freq_area, -est_dirmean, -est_dirps, -cov_freq_area_boot) %>%
  mutate(estimator = stringr::str_sub(estimator, start = 5))

res_long <- estimates_long %>%
  full_join(cov_long) %>%
  mutate(
    section = str_remove_all(subsection, "[:lower:]"),
    province = str_sub(section, end = -2)
  )

res_long <- res_long %>%
  dplyr::select(-X1, -ps_x, -sd_dirps, -se_freq_area, -sd_freq_area_boot)
# write.csv(res_long, "final_results_long.csv")



# ggplots

plot1 <- res_long %>%
  filter(province == "M333",
         response == "BALIVE_TPA") %>%
  mutate(subsection = stringr::str_sub(subsection, 5)) %>%
  mutate(subsection = fct_reorder(subsection, cov)) %>%
  filter(estimator != "dirmean") %>%
  ggplot(aes(x = subsection,
             y = cov,
             color = estimator)) +
  geom_point() +
  scale_color_manual(values = c("#A9A9A9", "#E8AA27", "#BE4D28", "#80BBA2", "#295043"),
                     labels = c("Post-strat", "Area EBLUP", "Unit EBLUP", "Area HB", "Unit HB")) +
  theme_bw() +
  labs(x = "Eco-subsection",
       y = "Coeffcient of variation",
       title = "Northern Rocky Forest CoV (Basal Area)",
       color = "Est:") +
  theme(legend.position = "bottom") +
  theme(text = element_text(size = 15)) 



plot2 <- res_long %>%
  filter(province == "M333",
         response == "BALIVE_TPA") %>%
  mutate(subsection = stringr::str_sub(subsection, 5)) %>%
  mutate(subsection = fct_reorder(subsection, cov)) %>%
  filter(estimator != "dirmean") %>%
  ggplot(aes(x = subsection,
             y = estimate,
             color = estimator)) +
  geom_point() +
  scale_color_manual(values = c("#A9A9A9", "#E8AA27", "#BE4D28", "#80BBA2", "#295043"),
                     labels = c("Post-strat", "Area EBLUP", "Unit EBLUP", "Area HB", "Unit HB")) +
  theme_bw() +
  labs(x = "Eco-subsection",
       y = "Estimate of Mean Basal Area",
       title = "Northern Rocky Forest Estimates (Basal Area)",
       color = "Est:") +
  theme(legend.position = "bottom") +
  theme(text = element_text(size = 15)) 

freq_se <- res %>%
  dplyr::select(response, subsection, se_freq_area) %>%
  mutate(
    section = str_remove_all(subsection, "[:lower:]"),
    province = str_sub(section, end = -2)
  ) %>%
  filter(province == "M333",
         response == "BALIVE_TPA")

plot3 <- res_long %>%
  filter(province == "M333",
         response == "BALIVE_TPA") %>%
  left_join(freq_se) %>%
  mutate(subsection = stringr::str_sub(subsection, 5)) %>%
  mutate(subsection = fct_reorder(subsection, cov)) %>%
  filter(estimator != "dirmean") %>%
  mutate(
    se = case_when(
      estimator == "hb_area" ~ se_freq_area,
      estimator != "hb_area" ~ NA_real_,
    )
  ) %>%
  ggplot(aes(x = subsection,
             y = estimate,
             color = estimator)) +
  geom_point() +
  geom_errorbar(aes(ymin = estimate - se, ymax = estimate + se)) +
  scale_color_manual(values = c("#A9A9A9", "#E8AA27", "#BE4D28", "#80BBA2", "#295043"),
                     labels = c("Post-strat", "Area EBLUP", "Unit EBLUP", "Area HB", "Unit HB")) +
  theme_bw() +
  labs(x = "Eco-subsection",
       y = "Estimate of Mean Basal Area",
       title = "Northern Rocky Forest Estimates (Basal Area)",
       color = "Est:") +
  theme(legend.position = "bottom") +
  theme(text = element_text(size = 15)) 

plot4 <- res %>%
  filter(response == "BALIVE_TPA") %>%
  ggplot(aes(x = est_dirps,
             y = est_hb_area)) +
  geom_point() +
  geom_smooth(method = "lm", se = F, color = "#80BBA2") +
  theme_bw() +
  labs(x = "Direct (Post-Strat) Estimate",
       y = "Hierarchical Bayesian Area Level Estimate",
       title = "Direct and HB Estimate Correlation (Basal Area)") +
  theme(text = element_text(size = 15)) 


