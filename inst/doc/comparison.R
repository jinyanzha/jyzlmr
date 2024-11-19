## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------

library(jyzlmr)
data=mtcars
result <- lmr("mpg", "wt + hp + qsec", data)



# Run lmr function
start_time <- Sys.time()
lmr_result <- lmr("mpg", "wt + hp + qsec", data)
lmr_time <- Sys.time() - start_time
print(lmr_result)

# Compare with lm function
start_time <- Sys.time()
lm_model <- lm(mpg ~ wt + hp + qsec, data = data)
lm_time <- Sys.time() - start_time
lm_summary <- summary(lm_model)
print(lm_summary)


cat("lmr runtime:", lmr_time, "\n")
cat("lm runtime:", lm_time, "\n")



