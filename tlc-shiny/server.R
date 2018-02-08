library(shiny)
library(tidyverse)
library(gridExtra)

function(input, output){
  data <- reactive({
    vals <- switch(input$dist,
                   rexp = do.call(input$dist, list(n=input$n, rate=3)),
                   rcauchy = do.call(input$dist, list(n=input$n, location=0, scale=1)),
                   rf = do.call(input$dist, list(n=input$n, df1 = 8, df2 = 6)),
                   rgamma = do.call(input$dist,list(n=input$n, shape=1, scale = 4)),
                   rlnorm = do.call(input$dist,list(n=input$n, meanlog=0, sdlog = 1)),
                   runif = do.call(input$dist,list(n=input$n, min=-10, max = 10)),
                   rpois = do.call(input$dist, list(n=input$n,lambda = 1)),
                   rgeom = do.call(input$dist, list(n=input$n, prob = 0.8)),
                   rnbinom = do.call(input$dist, list(n=input$n, size = 20, prob = 0.3)),
                   rweibull = do.call(input$dist, list(n=input$n, shape = 3, scale = 2))
    )
    return(list(fun=input$dist, vals=vals))
  })
  output$plot <- renderPlot({
    distname <- switch(input$dist,
                       rexp = "Exponencial",rcauchy = "Cauchy",rf = "F",
                       rgamma = "Gamma",rlnorm = "Log-normal",runif = "Uniforme",
                       rpois = "Poisson",rgeom = "Geométrica",
                       rnbinom = "Binomial negativa",rweibull = "Weibull")
    n <- input$n
    k <- input$k
    pdist <- data()$vals
    x <- switch(input$dist,
                rexp = replicate(k, do.call(input$dist, list(n=n, rate=3))),
                rcauchy = replicate(k, do.call(input$dist, list(n=n, location=1, scale = 1))),
                rf = replicate(k, do.call(input$dist, list(n=n, df1=8, df2 = 6))),
                rgamma = replicate(k, do.call(input$dist, list(n=n, shape=1, scale = 4))),
                rlnorm = replicate(k, do.call(input$dist, list(n=n, meanlog=0, sdlog = 1))),
                runif = replicate(k, do.call(input$dist, list(n=n, min=-10, max = 10))),
                rpois = replicate(k, do.call(input$dist, list(n=n, lambda=1))),
                rgeom = replicate(k, do.call(input$dist, list(n=n, prob=0.8))),
                rnbinom = replicate(k, do.call(input$dist, list(n=n, size = 20, prob = 0.3))),
                rweibull = replicate(k, do.call(input$dist, list(n=n, shape = 3, scale = 2)))
    )
    ndist <- rowMeans(x)
    dobs <- data.frame(pdist = pdist)
    nobs <- data.frame(ndist = ndist)
    g1 <- ggplot(data = dobs, aes(x = pdist)) +
      geom_histogram(bins = 30) +
      xlab(label = "X") +
      ylab(label = "Frecuencia") +
      ggtitle(distname)
    g2 <- ggplot(data = nobs, aes(x = ndist)) +
      geom_histogram(aes(y = ..density..), bins = 30) + 
      stat_function(fun=dnorm, args=list(mean=mean(nobs$ndist), sd=sd(nobs$ndist)),
                    color = "red") +
      ggtitle(paste0("Distribución de las medias de una distribución ",distname)) +
      scale_x_continuous(name = expression(paste("Media muestral (", bar(X), ")"))) +
      scale_y_continuous(name = "Densidad")
    grid.arrange(g1,g2,ncol=1)
  })
}