tablero_galton <- function(n = 5, sleep = 0.3){
  sl = sleep/2
  pelota <- function(x,y, blanco = TRUE, sleep = sl){
    points(x,y,pch = pchpelota, cex = cexpelota, 
           bg = bgpelota, fg = fgpelota)
    Sys.sleep(sleep)
    if(blanco)
      points(x,y,pch = 16, cex = cexpelota, col = 'white')
  }
  impar <- function(x){
    x != as.integer(x/2) * 2
  }
  npar <- function(x){
    !impar(x)
  }
  
  np <- 10
  mp <- 8
  dx <- 0.5
  uy <- 4
  ly <- 8
  colpin <- 1
  pchpin <- 21
  cexpin <- 1.2
  cexpelota <- 1.5
  bgpelota <- 'grey'
  fgpelota <- 'blue'
  pchpelota <- 21
  coltrace <- 'red'
  collwd <- 1
  const <- 1
  dy <- 0.5
  eps <- dy / 4
  
  x1 <- seq(1,np, 2*dx)
  y1 <- seq(mp,1,-1) * const
  xs <- rep(c(x1+0.5,x1),mp/2)
  ys <- rep(y1, each = length(x1))
  par(pty = "s")
  plot(xs,ys, type = 'n', 
       xlim = c(0,np + 1.5),
       ylim = c(-ly, mp*const + uy),
       axes = FALSE, xlab = '', ylab = '')
  box()
  rug(seq(0,np+1,1),0.3,col='grey',lwd=2)
  points(xs,ys,
         pch = pchpin,
         cex = cexpin,
         bg = colpin,
         fg = colpin,
         ylim=c(-mp,mp))
  xd <- seq(0,np + 1, 0.1)
  #yd <- dnorm(xd, mean(x1), sqrt(n/4)/3 * n/3.5 - ly - 1)
  lines(5.5 - c(2,0.3,0.3), c(12.4,9.9,9), lwd=2, col = 'black')
  lines(5.5 + c(0.3,0.3), c(12.5,9), lwd = 2, col = 'black')
  pelota(x=5.5,y=9.4,FALSE)
  for(j in 0:3)
    for(i in 0:j)
      pelota(5.5 - i * 0.5, 10 + j * 0.7, sleep = 0, blanco = FALSE)
  bins <- numeric(np + 1)
  for(i in 1:n){
    dy <- 0.5
    starty <- mp * const + dy
    midx <- mean(x1)
    x <- midx
    xt <- x
    yt <- starty + dy
    for(y in seq(starty,1,-dy)){
      if(y%%1 == 0)
        x = x + sign(runif(1,-1,1)) * dx
      xt <- c(xt,x)
      yt <- c(yt,y)
      if(n <= 5){
        pelota(x,y + eps, sleep = sleep)
      }
      lines(xt, yt, col = coltrace, lwd = collwd)
    }
    binx <- x + 0.5
    bins[binx] = bins[binx] + 1
    if(n <= 5){
      while(y > -ly - 1 + bins[binx] * dy){
        pelota(x,y, sleep = sleep)
        y <- y - dy
      }
  }
    y <- -ly - 1 + bins[binx] * dy
    epsx <- sign(5-x) * (impar(bins[binx])-0.5) * 0.5
    epsy <- npar(bins[binx]) * 0.5
    epsy2 <- ((bins[binx]-1)%/%2) * 0.35
    pelota(x + epsx, y - epsy -epsy2, FALSE)
    lines(xt, yt, col = 'white', lwd = collwd)
  }
  if(n > 5){
    dy <- 0.5
    starty <- mp * const + dy
    midx <- mean(x1)
    xt <- x
    yt <- starty + dy
    X <- rep(1:length(bins), bins) - 0.5
    m <- mean(X)
    s <- sd(X)
    n <- sum(bins)
    lines(xd, dnorm(xd,m,s)* n/3 -ly - 1, col = 'green', lwd = 3)
  }
}

tablero_galton()
tablero_galton(n = 90, sleep = 0.25)
