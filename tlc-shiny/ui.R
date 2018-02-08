library(tidyverse)
pageWithSidebar(
  headerPanel("Teorema del límite central"),
  sidebarPanel(
    h4("Parámetros:"),
    radioButtons("dist", "Parent distribution:",
                 list("Exponencial" = "rexp","Cauchy" = "rcauchy",
                      "F" = "rf","Gamma" = "rgamma",
                      "Log-normal" = "rlnorm","Uniforme" = "runif",
                      "Poisson" = "rpois","Geométrica" = "rgeom",
                      "Binomial negativa" = "rnbinom","Weibull" = "rweibull")),
    br(),
    sliderInput("n", 
                "Número de observaciones de la distribución:",
                value = 500,
                min = 2, 
                max = 1000),
    br(),
    sliderInput("k", 
                "Número de muestras de la distribución:", 
                value = 10,
                min = 1,
                max = 1000),
    br()),
  mainPanel(
    plotOutput("plot", height="900px")
  )
)
