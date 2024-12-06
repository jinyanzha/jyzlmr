#' Linear Regression Function
#'
#' lmr is used to fit linear models, including multivariate ones. It can be used to carry out regression
#' @param Y Response which variable you focus on
#' @param X the covariates which will affect Y
#' @param data Data frame containing the variables data
#' @return lmr function will show the linear regression model details from the variables you interested in.
#' \describe{It may include following:
#'   \item{\bold{R-squared}}{the R-squared for the model}
#'   \item{\bold{F-statistic and degree of freedom}}{the F number and its freedom and p-value}
#'   \item{\bold{residual table}}{the min, 1q, median, 3q,max number for residual}
#'   \item{\bold{regression table}}{includes the different Beta(coefficients) for coviariates, the SD_error,t-value,p-value}
#'   \item{\bold{Confidence Intervals}}{includes the different CI for coviariates}}
#' @examples
#' library(jyzlmr)
#' data=mtcars
#' result <- lmr("mpg", "wt + hp + qsec", data)
#' print(result)
#'
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

  # 95% Confidence Intervals for regression coefficients
  alpha <- 0.05
  t_critical <- qt(1 - alpha / 2, df = residual_df)
  lower_bounds <- beta - t_critical * beta_se
  upper_bounds <- beta + t_critical * beta_se
  confidence_intervals <- data.frame(
    Lower_95 = lower_bounds,
    Upper_95 = upper_bounds,
    row.names = colnames(model_matrix)
  )

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
    dimnames = list(NULL, c("Min", "1Q", "Median", "3Q", "Max"))
  ))

  # Format output text
  summary_text <- paste(
    "Residual standard error: ", round(sqrt(sigma2), 2), " on ", residual_df, " degrees of freedom\n",
    "Multiple R-squared: ", round(R2, 4), ", Adjusted R-squared: ", round(adjusted_R2, 4), "\n",
    "F-statistic: ", round(F_statistic, 2), " on ", (p - 1), " and ", residual_df, " DF, p-value: ",
    formatC(1 - pf(F_statistic, p - 1, residual_df), format = "e", digits = 6)
  )

  # Return results
  return(list(
    summary = summary_text,             # Summary text
    residuals_table = residuals_table,  # Residual table
    regression_table = lm_table,        # Regression results table
    confidence_intervals = confidence_intervals # Confidence intervals for coefficients
  ))
}


