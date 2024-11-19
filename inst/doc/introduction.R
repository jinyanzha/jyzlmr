## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## -----------------------------------------------------------------------------
##When you have some data, you may want to find out if there is a relationship between different variables, whether these relationships are significantly associated, and how a change in one variable affects another. For instance, if one variable doubles, how does the other change, and how do multiple variables interact with each other? The lmr function uses linear regression to quickly answer these questions and provide you with the final results.

## ----setup--------------------------------------------------------------------
##here is a date for cars, I want to find whether weight, horsepower and quarter  mile time will affect miles per gallon 
library(jyzlmr)
data=mtcars
result <- lmr("mpg", "wt + hp + qsec", data)
print(result)
## we can see the result, only weight's p-value smaller than 0.05, which means only weight has the significantly association with Mile per galon

