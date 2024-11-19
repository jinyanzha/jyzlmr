## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(jyzlmr)
data=mtcars
result <- lmr("mpg", "wt + hp + qsec", data)
print(result)

