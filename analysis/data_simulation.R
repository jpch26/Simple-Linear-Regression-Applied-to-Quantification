# Data simulation ---------------------------------------------------------

set.seed(5)  # For reproducibility

# 1. Function to simulate the data
response <- function(x, coeff, intercept) {
  resps <- x * coeff + intercept
  resps <- resps + rnorm(n = length(x), sd = 3.25)
  return(resps)
}

# 2. Concentration values

conc <- rep(seq(20, 110, by = 10), 3)

# 3. Signal values

sig <- response(conc, coeff = 2.3, intercept = 0.5)
sig <- round(sig, 2)

# 4. Data frame with concentration and area values

calibration_curve_data <- data.frame(C = conc, S = sig)

# 5. Samples data (signals for samples with unknown concentrations)

# 5.1 Obtained signals
sample_sig <- c(rnorm(4, 80, 5), rnorm(4, 140, 5), rnorm(4, 190, 5))

# 5.2 Variety code
variety <- rep(1:3, each = 4)

# 5.3 Data frame
sample_data <- data.frame(
  V = variety,
  S = round(sample_sig, 2)
)
# 5. Save main_data

write.csv(
  calibration_curve_data, 
  file = "data/calibration_curve_data.csv", 
  row.names = FALSE
  )

write.csv(sample_data, file = "data/sample_data.csv", row.names = FALSE)
