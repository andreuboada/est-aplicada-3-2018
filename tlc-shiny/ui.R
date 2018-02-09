library(tidyverse)
pageWithSidebar(
  headerPanel(""),
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
                value = 30,
                min = 2, 
                max = 500),
    br(),
    sliderInput("k", 
                "Número de muestras de la distribución:", 
                value = 100,
                min = 1,
                max = 1000),
    br(), width = 3),
  mainPanel(
    br(), br(), br(),
    plotOutput("plot", height="600px", width = "400px")
  )
)
