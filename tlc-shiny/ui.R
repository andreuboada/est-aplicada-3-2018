library(tidyverse)
pageWithSidebar(
  headerPanel(""),
  sidebarPanel(
    tags$head(
      tags$style(type="text/css", "select { max-width: 140px; }"),
      tags$style(type="text/css", ".span4 { max-width: 190px; }"),
      tags$style(type="text/css", ".well { max-width: 180px; }")
    ),
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
    br()
    ),
  mainPanel(
    plotOutput("plot", height="600px", width = "300px"), 
    style='width: 300px; height: 100px'
  )
)
