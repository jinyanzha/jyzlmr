

## Overview

`lmr()` is a linear regression function developed in R that provides a easy way for finding the association betwwen variables.
This function allows users to fit a linear model, obtain regression coefficients, calculate residuals, and assess model quality 
through metrics such as R-squared and F-statistic.

- You can learn more about `lmr` in `vignette("introduction",package="jyzlmr")`.
- You can run example in `?lmr` help page
- You can find the comparison between `lmr` and original function `lm` in `vignette("comparison",package="jyzlmr")`



## Features

`lmr()` can output the following data:

- Regression coefficients for a linear model.
  

- Provide standard errors, t-values, and p-values for the estimated coefficients.

- model metrics including R-squared, Adjusted R-squared, and F-statistic.

- Display a summary of residuals.
 
- Confidence Interval for all regression coefficients

## Installation

``` r
# Install devtools if it is not already installed
install.packages("devtools")

# Install lmr from GitHub
devtools::install_github("jinyanzha/jyzlmr")
```



## Usage

``` r
library(jyzlmr)
data=mtcars
result <- lmr("mpg", "wt + hp + qsec", data)
print(result)

"Residual standard error:  2.58  on  28  degrees of freedom Multiple R-squared:  0.8348 ,
Adjusted R-squared:  0.8171 F-statistic:  47.15  on  3  and  28  DF, p-value:  4.506417e-11"

Residual Table
#>             min       1Q     Median   3Q    Max  
#>   value  -3.859   -1.642    -0.464  1.194  5.609


Regression_table
#>                 Estimate  Std_Error   t_value      p_value
#>   (Intercept) 27.61052686 8.41992848  3.279188 2.784556e-03
#>   wt          -4.35879720 0.75270039 -5.790879 3.217222e-06    
#>   hp          -0.01782227 0.01498117 -1.189645 2.441762e-01   
#>   qsec         0.51083369 0.43922153  1.163043 2.546284e-01


Confidence_intervals
#>                Lower_95    Upper_95
#>  (Intercept) 10.3630852 44.85796848
#>  wt          -5.9006341 -2.81696034
#>  hp          -0.0485098  0.01286526
#>  qsec        -0.3888708  1.41053822   
```

## Function Details

- Input Parameters:

  - `Y`: The response variable (character string representing the column name in `data`).
  - `X`: Predictor variables(eg.,"X1+X2")
  - `data`: A data frame that contains both `Y` and `X` variables.
  

- Output:
  - model metrics including R-squared, Adjusted R-squared, F-statistic and p-values.
  - Residuals Table: A table summarizing residuals (`Min`, `1Q`, `Median`, `3Q`, `Max`).
  - Regression Table: A table containing coefficients, standard errors, t-values, and relevant p-values.
  - Confidence Interval: A table containing all coefficients' confidence interval


## Interpretation of Output
- The R-squared value represents the proportion of the variance explained by the model.
- The Adjusted R-squared accounts for the number of predictors in the model, providing a better measure for models with multiple predictors.
- The F-statistic tests whether the overall regression model is a good fit for the data.
- Residual standard error provides a measure of the typical size of residuals.
- Confidence Interval provide a range within which we expect the true value of the regression coefficient to lie, with a certain level of confidence, in this case, 95%.
