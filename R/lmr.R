#' Custom Linear Regression Function
#'
#' This function performs a linear regression similar to lm() but without using the built-in lm function.
#'
#' @param Y Response which variable you focus on
#' @param X is the covariates which will affect Y
#' @param data Data frame containing the variables.
#' @return A list containing the regression table and residuals summary.
#' @export




lmr <- function(Y, X, data) {
  # Check if the input is a data frame
  if (!is.data.frame(data)) stop("Data must be a data frame.")
  if (!Y %in% names(data)) stop("Response variable not found in data.")

  # Build formula and model matrix
  formula <- as.formula(paste(Y, "~", X))
  model_matrix <- model.matrix(formula, data)

  # Extract response variable
  y <- as.matrix(data[[Y]])

  # Sample size and number of parameters
  n <- nrow(model_matrix)
  p <- ncol(model_matrix)

  # Compute regression coefficients
  XtX_inv <- solve(t(model_matrix) %*% model_matrix)  # Compute (X'X)^(-1)
  XtY <- t(model_matrix) %*% y
  beta <- XtX_inv %*% XtY

  # Predicted values and residuals
  fitted_values <- model_matrix %*% beta
  residuals <- y - fitted_values

  # SSE (Sum of Squared Errors) and SSY (Total Sum of Squares)
  SSE <- sum(residuals^2)
  SSY <- sum((y - mean(y))^2)

  # SSR (Sum of Squares for Regression)
  SSR <- SSY - SSE

  # R² and Adjusted R²
  R2 <- SSR / SSY
  adjusted_R2 <- 1 - (1 - R2) * (n - 1) / (n - p)

  # F-statistic
  F_statistic <- (SSR / (p - 1)) / (SSE / (n - p))

  # Residual standard error
  residual_df <- n - p
  sigma2 <- SSE / residual_df
  beta_se <- sqrt(diag(sigma2 * XtX_inv))
  t_values <- beta / beta_se
  p_values <- 2 * pt(-abs(t_values), df = residual_df)

  # Regression result table
  lm_table <- data.frame(
    Estimate = beta,
    Std_Error = beta_se,
    t_value = t_values,
    p_value = formatC(p_values, format = "e", digits = 6),
    row.names = colnames(model_matrix)
  )

  # Residual statistics
  residual_summary <- c(
    min(residuals),
    quantile(residuals, 0.25),
    median(residuals),
    quantile(residuals, 0.75),
    max(residuals)
  )
  residuals_table <- as.data.frame(matrix(
    round(residual_summary, 3),
    nrow = 1,
    dimnames = list("value", c("Min", "1Q", "Median", "3Q", "Max"))
  ))

  # Format output text
  summary_text <- paste(
    "Residual standard error: ", round(sqrt(sigma2), 2), " on ", residual_df, " degrees of freedom",

    "Multiple R-squared: ", round(R2, 4), ", Adjusted R-squared: ", round(adjusted_R2, 4),

    "F-statistic: ", round(F_statistic, 2), " on ", (p - 1), " and ", residual_df, " DF, p-value: ",

    formatC(1 - pf(F_statistic, p - 1, residual_df), format = "e", digits = 6)
  )

  # Return results
  return(list(
    summary = summary_text,       # Summary text
    residuals_table = residuals_table,  # Residual table
    regression_table = lm_table        # Regression results table
  ))
}


