# Linear regression analysis ----------------------------------------------

# Packages
if (!"ggplot2" %in% .packages()) library(ggplot2)

# 1 Import data ----------------------------------------------------------

# 1.1 Calibration curve data
curve_data <- read.csv("data/calibration_curve_data.csv")

# 1.2 Tomato extracts
sample_data <- read.csv("data/sample_data.csv")

# 2 Linear regression analysis -------------------------------------------

# 2.1 Fitting linear model
model_lm <- lm(C ~ S, data = curve_data)  

# 2.2 Linear model summary 
model_sum <- summary(model_lm)

# 2.3 ANOVA for linear summary
model_anova <- anova(model_lm)

# 2.4 Point plot for data and the model 
model_plot <- ggplot(curve_data, aes(x = S, y = C)) +
  geom_point() +
  geom_smooth(method = "lm", formula = y ~ x, se = FALSE) +
  xlab("Signal (mAU)") +
  ylab("Concentration (mmol)") +
  theme_classic() +
  theme(
    axis.text.x = element_text(color = "black", size = 13),
    axis.text.y = element_text(color = "black", size = 13),
    axis.title = element_text(color = "black", size = 15)
  )

# 3 Save model results ----------------------------------------------------

capture.output(model_sum, file = "data/model_summary.txt")
write.csv(model_anova, file = "data/model_ANOVA.csv", na = " ")
ggsave(filename = "graphs/model_plot.jpg", model_plot)


# 4 Sample concentration predictions ----------------------------------------

# 4.1 Predictions data frame 
sample_pred <- predict.lm(model_lm, newdata = sample_data)
sample_pred <- data.frame(C = round(sample_pred, 2))

# 4.2 Join both signals and predictions data frames
sample_pred <- cbind(sample_data, sample_pred)

# 4.3 Sample red points on model_plot
sample_plot <- model_plot +
  geom_point(data = sample_pred, aes(x = S, y = C), color = "red") 

# 5 Save prediction results -----------------------------------------------

write.csv(sample_pred, file = "data/sample_results.csv")
ggsave(filename = "graphs/sample_plot.jpg", sample_plot)
