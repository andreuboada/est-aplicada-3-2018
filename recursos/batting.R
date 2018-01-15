#install.packages("Lahman", repos="http://R-Forge.R-project.org")
library(Lahman)
library(dplyr)
library(ggplot2)
library(car)
library(jpeg)
library(plyr)

Master <- read.csv('Master.csv')
Teams <- read.csv('Teams.csv')
Batting <- read.csv('Batting.csv')
tail(Teams,3)

teams2000 <- Teams %>%
  filter(yearID > 2000) %>%
  select(teamID,yearID,lgID,G,W,L,R,RA) %>%
  mutate(RD = R - RA) %>% # run differential
  mutate(Wpot = W / (W+L)) %>% # winning percentage
  mutate(pytWpot = R^2 / (R^2 + RA^2))

teams2000$G <- as.factor(teams2000$G)
rPlot(Wpot ~ pytWpot, 
      data = teams2000, color = 'yearID', type = 'point')
rPlot(Wpot ~ RD, 
      data = teams2000, color = 'yearID', type = 'point')

nPlot(Wpot ~ pytWpot, group = 'yearID',
      data = teams2000, type = 'scatterChart')

# Mickey Mantle
mantle.info <- subset(Master,nameFirst=="Mickey" & nameLast == 'Mantle')
mantle.id <- as.character(mantle.info$playerID)


Batting$SF <- recode(Batting$SF, "NA = 0")
Batting$HBP <- recode(Batting$HBP, "NA = 0")

get.birthyear <- function(player.id){
  playerline <- subset(Master, playerID == player.id)
  birthyear <- playerline$birthYear
  birthmonth <- playerline$birthMonth
  ifelse(birthmonth >=7, birthyear + 1, birthyear)
}

get.birthyear(mantle.id)

get.stats <- function(player.id){
  d <- subset(Batting, playerID==player.id)
  byear <- get.birthyear(player.id)
  d$Age <- d$yearID - byear
  d$SLG <- with(d, (H - X2B - X3B - HR +
                      2*X2B + 3*X3B + 4*HR) / AB)
  d$OBP <- with(d, (H + BB) / (H + AB + BB + SF))
  d$OPS <- with(d, SLG + OBP)
  d
}

Mantle <- get.stats(mantle.id)
with(Mantle, plot(Age, OBP, cex = 1.5, pch = 19))


fit.model <- function(d){
  fit <- lm(OBP ~ I(Age-30) + I((Age - 30)^2), data = d)
  b <- coef(fit)
  Age.max <- 30 - b[2] / b[3] / 2
  Max <- b[1] - b[2] ^2 / b[3] / 4
  list(fit=fit, Age.max=Age.max,Max=Max)
}
F2 <- fit.model(Mantle)
coef(F2$fit)
c(F2$Age.max,F2$Max)

lines(Mantle$Age, predict(F2$fit, Age = Mantle$Age), lwd = 3)
abline(v=F2$Age.max, lwd = 3, lty = 2, col="grey")
abline(h=F2$Max,lwd=3, lty=2, col='grey')
text(29, .72, "Edad cúspide", cex = 2)
text(20,1,"Max", cex = 2)

Fielding <- read.csv('Fielding.csv')

AB.totals <- ddply(Batting, .(playerID), 
                   summarize,
                   Career.AB=sum(AB, na.rm=T))
Batting <- merge(Batting, AB.totals)
Batting.2000 <- subset(Batting, Career.AB >= 2000)

find.position <- function(p){
  positions <- c('OF','1B','2B','SS','3B','C','P','DH')
  d <- subset(Fielding, playerID == p)
  count.games <- function(po)
    sum(subset(d, POS == po)$G)
  FLD <- sapply(positions, count.games)
  positions[FLD == max(FLD)][1]
}

PLAYER <- as.character(unique(Batting.2000$playerID))
POSITIONS <- sapply(PLAYER, find.position)
Fielding.2000 <- data.frame(playerID=names(POSITIONS),
                            POS=POSITIONS)
Batting.2000 <- merge(Batting.2000, Fielding.2000)

C.totals <- ddply(Batting.2000, .(playerID),
                  summarize,
                  C.G=sum(G,na.rm=T),
                  C.AB=sum(AB,na.rm=T),
                  C.R=sum(R,na.rm=T),
                  C.H=sum(H,na.rm=T),
                  C.2B=sum(X2B,na.rm=T),
                  C.3B=sum(X3B,na.rm=T),
                  C.HR=sum(HR,na.rm=T),
                  C.RBI=sum(RBI,na.rm=T),
                  C.BB=sum(BB,na.rm=T),
                  C.SO=sum(SO,na.rm=T),
                  C.SB=sum(SB,na.rm=T))

C.totals$C.AVG <- with(C.totals, C.H/C.AB)
C.totals$C.SLG <- with(C.totals,
                       (C.H - C.2B - C.3B - C.HR + 
                          2*C.2B + 3*C.3B+4*C.HR) / C.AB)

C.totals <- merge(C.totals, Fielding.2000)
C.totals$Value.POS <- with(C.totals,
                          ifelse(POS=='C', 240,
                          ifelse(POS=='SS',168,
                          ifelse(POS=='2B',132,
                          ifelse(POS=='3B',84,
                          ifelse(POS=='OF',48,
                          ifelse(POS=='1B',12,0)))))))

similar <- function(p, number=10){
  P <- subset(C.totals, playerID == p)
  C.totals$SS <- with(C.totals,
                   1000 - 
                     floor(abs(C.G - P$C.G) / 20) -
                     floor(abs(C.AB - P$C.AB) / 75) -
                     floor(abs(C.R - P$C.R) / 10) -
                     floor(abs(C.H - P$C.H) / 15) -
                     floor(abs(C.2B - P$C.2B) / 5) -
                     floor(abs(C.3B - P$C.3B) / 4) -
                     floor(abs(C.HR - P$C.HR) / 2) -
                     floor(abs(C.RBI - P$C.RBI) / 10) -
                     floor(abs(C.BB - P$C.BB) / 25) -
                     floor(abs(C.SO - P$C.SO) / 150) -
                     floor(abs(C.SB - P$C.SB) / 20) -
                     floor(abs(C.AVG - P$C.AVG) / 0.001) -
                     floor(abs(C.SLG - P$C.SLG) / 0.002) -
                     abs(Value.POS - P$Value.POS))
  C.totals <- C.totals[order(C.totals$SS,decreasing=TRUE),]
  C.totals[1:number,]
}

similar(mantle.id,6)

collapse.stint <- function(d){
  G <- sum(d$G); AB <- sum(d$AB); R <- sum(d$R)
  H <- sum(d$H); X2B <- sum(d$X2B); X3B <- sum(d$X3B)
  HR <- sum(d$HR); RBI <- sum(d$RBI); SB <- sum(d$SB)
  CS <- sum(d$CS); BB <- sum(d$BB); SH <- sum(d$SH)
  SF <- sum(d$SF); HBP <- sum(d$HBP)
  SLG <- (H - X2B - X3B - HR + 2*X2B +
            3*X3B + 4*HR) / AB
  OBP <- (H + BB + HBP) / (AB + BB + HBP + SF)
  OPS <- SLG + OBP
  data.frame(G=G,AB=AB,R=R,H=H,X2B=X2B,
             X3B=X3B, HR=HR, RBI=RBI, SB=SB,
             CS=CS, BB=BB, HBP=HBP, SH=SH, SF=SF,
             SLG=SLG, OBP=OBP, OPS=OPS,
             Career.AB=d$Career.AB[1], POS=d$POS[1])
}

Batting.2000 <- ddply(Batting.2000,
                      .(playerID,yearID), collapse.stint)

player.list <- as.character(unique(Batting.2000$playerID))
birthyears <- sapply(player.list, get.birthyear)
Batting.2000 <- merge(Batting.2000,
                      data.frame(playerID=player.list,
                                 Birthyear=birthyears))
Batting.2000$Age <- with(Batting.2000, yearID - Birthyear)

Batting.2000 <- Batting.2000[complete.cases(Batting.2000$Age),]

fit.trajectory <- function(d){
  fit <- lm(OPS ~ I(Age-30) + I((Age-30)^2), data = d)
  data.frame(Age=d$Age, Fit=predict(fit,Age=d$Age))
}

plot.trajectories <- function(first, last, n.similar=5, ncol){
  get.name <- function(playerid){
    d1 <- subset(Master, playerID == playerid)
    with(d1, paste(nameFirst,nameLast))
  }
  player.id <- subset(Master,
                      nameFirst== first & nameLast == last)$playerID
  player.id <- as.character(player.id)
  player.list <- as.character(similar(player.id,n.similar)$playerID)
  Batting.new <- subset(Batting.2000, playerID %in% player.list)
  
  F2 <- ddply(Batting.new, .(playerID), fit.trajectory)
  F2 <- merge(F2,
              data.frame(playerID=player.list,
                         Name=sapply(as.character(player.list),get.name)))
  print(ggplot(F2,aes(Age,Fit))+geom_line(size=1.5)+
          facet_wrap(~Name,ncol=ncol)+theme_bw())
  return(Batting.new)
}

d <- plot.trajectories(first="Mickey",last="Mantle",n.similar=6,ncol=2)
d <- plot.trajectories(first="Hunter",last="Pence",n.similar=6,ncol=2)

data(pitches, package = "pitchRx")
rivera <- subset(pitches, pitcher_name == "Mariano Rivera")

diamond <- readJPEG("Comerica.jpg")

rivera$break_angle <- as.numeric(rivera$break_angle)
ggplot(rivera, aes(x = break_angle, fill = pitch_type)) + 
  geom_density(alpha = 0.2)

ggplot(rivera, aes(x,y)) + 
  coord_equal() + 
  annotation_raster(diamond, 25, 200, 50, 200) +
  stat_binhex(alpha = .9, binwidth=c(5,5)) + 
  scale_fill_gradient(low='pink', high='blue')

ggplot(rivera, aes(x,y)) + 
  coord_equal() + 
  annotation_raster(diamond, 25, 200, 50, 200) +
  geom_point() +
  theme()

library(pitchRx)
Rivera <- subset(pitches, pitcher_name=="Mariano Rivera")
interactiveFX(Rivera)

strikes <- subset(pitches, des == "Called Strike")
strikeFX(strikes, geom="tile", layer=facet_grid(.~stand))

strikeFX(pitches, geom="tile", density1=list(des="Called Strike"), 
         density2=list(des="Called Strike"), layer=facet_grid(.~stand))

strikeFX(pitches, geom="tile", density1=list(des="Called Strike"),
         density2=list(des="Ball"), layer=facet_grid(.~stand))


noswing <- subset(pitches, des %in% c("Ball", "Called Strike"))
noswing$strike <- as.numeric(noswing$des %in% "Called Strike")
library(mgcv)
m1 <- bam(strike ~ s(px, pz, by=factor(stand)) +
            factor(stand), data=noswing, family = binomial(link='logit'))
strikeFX(noswing, model=m1, layer=facet_grid(.~stand))

data(Batting)
head(Batting)

batting <- battingStats()
batting <- merge(batting, 
                 Salaries[,c("playerID", "yearID", "teamID", "salary")], 
                 by=c("playerID", "yearID", "teamID"), all.x=TRUE)
masterInfo <- Master[, c('playerID', 'birthYear', 'birthMonth',
                         'nameLast', 'nameFirst', 'bats')]
batting <- merge(batting, masterInfo, all.x = TRUE)
batting$age <- with(batting, yearID - birthYear -
                      ifelse(birthMonth < 10, 0, 1))

batting <- arrange(batting, playerID, yearID, stint)
eligibleHitters <- subset(batting, yearID >= 1900 & PA > 450)
topHitters <- ddply(eligibleHitters, .(yearID), subset, (BA == max(BA))|BA > .400)
topHitters$ba400 <- with(topHitters, BA >= 0.400)
bignames <- rbind(subset(topHitters, ba400),
                  subset(topHitters, yearID > 1950 & BA > 0.380))
bignames <- subset(bignames, select = c('playerID', 'yearID', 'nameLast',
                                        'nameFirst', 'BA'))
topHitters <- subset(topHitters, select = c('playerID', 'yearID', 'BA', 'ba400'))

bignames$xoffset <- c(0, -3, -3, -3, 0, -3, -4, 0, -10, 4, 7, 3, 0, 0, -2, 0, 0)
bignames$yoffset <- c(0, 0, -0.003, 0, 0, 0, 0.002, 0, -0.0035, 0, 0.001, 0, 0, 0, -0.003, 0, 0)  +  0.002

ggplot(topHitters, aes(x = yearID, y = BA)) +
  geom_point(aes(colour = ba400), size =4) +
  geom_hline(yintercept = 0.39999, size = 1,color='lightseagreen') +
  geom_text(data = bignames, aes(x = yearID + xoffset, y = BA + yoffset,
                                 label = paste(nameFirst,nameLast)), size = 5) +
  scale_colour_manual(values = c('FALSE' = 'deeppink', 'TRUE' = 'darkviolet')) +
  ylim(0.330, 0.430) +
  xlab('Año') +
  scale_y_continuous('Promedio de Bateo',
                     breaks = seq(0.34, 0.42, by = 0.02),
                     labels = c('.340', '.360', '.380', '.400', '.420')) +
  geom_smooth() +
  theme(legend.position = 'none',axis.text=element_text(size=18,face='bold'),
        axis.title = element_text(face="bold", colour="palevioletred4", size=20))

  ######### Hunter Pence #########

# Comparar su salario respecto a bateadores similares
library(Lahman)
library(dplyr)
library(ggplot2)
library(lubridate)
bstats <- battingStats()
pence <- Batting %>% filter(playerID=='pencehu01')
data(Batting)

find.position <- function(p){
  positions <- c('OF','1B','2B','SS','3B','C','P','DH')
  d <- subset(Fielding, playerID == p)
  count.games <- function(po)
    sum(subset(d, POS == po)$G)
  FLD <- sapply(positions, count.games)
  positions[FLD == max(FLD)][1]
}

AB.totals <- ddply(Batting, .(playerID), 
                   summarize,
                   Career.AB=sum(AB, na.rm=T))
Batting <- merge(Batting, AB.totals)
Batting.2000 <- subset(Batting, Career.AB >= 2000)

PLAYER <- as.character(unique(Batting.2000$playerID))
POSITIONS <- sapply(PLAYER, find.position)
Fielding.2000 <- data.frame(playerID=names(POSITIONS),
                            POS=POSITIONS)
Batting.2000 <- merge(Batting.2000, Fielding.2000)

C.totals <- ddply(Batting.2000, .(playerID),
                  summarize,
                  C.G=sum(G,na.rm=T),
                  C.AB=sum(AB,na.rm=T),
                  C.R=sum(R,na.rm=T),
                  C.H=sum(H,na.rm=T),
                  C.2B=sum(X2B,na.rm=T),
                  C.3B=sum(X3B,na.rm=T),
                  C.HR=sum(HR,na.rm=T),
                  C.RBI=sum(RBI,na.rm=T),
                  C.BB=sum(BB,na.rm=T),
                  C.SO=sum(SO,na.rm=T),
                  C.SB=sum(SB,na.rm=T))

C.totals$C.AVG <- with(C.totals, C.H/C.AB)
C.totals$C.SLG <- with(C.totals,
                       (C.H - C.2B - C.3B - C.HR + 
                          2*C.2B + 3*C.3B+4*C.HR) / C.AB)

C.totals <- merge(C.totals, Fielding.2000)
C.totals$Value.POS <- with(C.totals,
                           ifelse(POS=='C', 240,
                                  ifelse(POS=='SS',168,
                                         ifelse(POS=='2B',132,
                                                ifelse(POS=='3B',84,
                                                       ifelse(POS=='OF',48,
                                                              ifelse(POS=='1B',12,0)))))))

similar <- function(p, number=10){
  P <- subset(C.totals, playerID == p)
  C.totals$SS <- with(C.totals,
                      1000 - 
                        floor(abs(C.G - P$C.G) / 20) -
                        floor(abs(C.AB - P$C.AB) / 75) -
                        floor(abs(C.R - P$C.R) / 10) -
                        floor(abs(C.H - P$C.H) / 15) -
                        floor(abs(C.2B - P$C.2B) / 5) -
                        floor(abs(C.3B - P$C.3B) / 4) -
                        floor(abs(C.HR - P$C.HR) / 2) -
                        floor(abs(C.RBI - P$C.RBI) / 10) -
                        floor(abs(C.BB - P$C.BB) / 25) -
                        floor(abs(C.SO - P$C.SO) / 150) -
                        floor(abs(C.SB - P$C.SB) / 20) -
                        floor(abs(C.AVG - P$C.AVG) / 0.001) -
                        floor(abs(C.SLG - P$C.SLG) / 0.002) -
                        abs(Value.POS - P$Value.POS))
  C.totals <- C.totals[order(C.totals$SS,decreasing=TRUE),]
  C.totals[1:number,]
}

hence_similares <- similar('pencehu01',50)

jugadores <- hence_similares$playerID

data(Salaries)
data(Master)

info_jugadores <- Master %>% 
  filter(playerID %in% jugadores) %>%
  mutate(finalGame=ymd(finalGame),
         debut=ymd(debut))

salarios_jugadores <- Salaries %>% 
  filter(playerID %in% jugadores) 

# Filtrar aquellos cuyo debut haya sido después del 2000
# y que hayan tenido un juego por lo menos desde el 2008
# de menor a 40 años.

info_jugadores <- info_jugadores %>%
  filter(year(finalGame) >= 2008 & year(debut) >= 2000) %>%
  mutate(edad = 2015 - birthYear) %>%
  filter(edad < 40)

# ¿Cuál es su promedio de bateo?
bateo <- info_jugadores %>%
  left_join(hence_similares, by = 'playerID') %>%
  left_join(salarios_jugadores, by = 'playerID') %>%
  arrange(desc(SS)) %>%
  group_by(playerID) %>%
  filter(row_number(playerID)==1)%>%
  mutate(nombre = paste(nameFirst,nameLast),
         SS = SS/1000)

# colores <- c('purple','blue','violet','darkslategrey','deeppink',
#              'darkslateblue','lightblue4','steelblue','violetred4',
#              'turquoise','slateblue','orchid3','plum4','lightpink4',
#              'mediumpurple4','maroon')
# +
#   scale_fill_manual(values=colores)
bateo <- within(bateo, nombre <- factor(nombre,levels=nombre[order(SS)]))
ggplot(bateo, aes(x = nombre, y = SS, color = nombre)) + 
  geom_point() +
  theme(axis.text.x=element_blank(),
        axis.title.x=element_blank(),
        axis.title.y=element_blank())
library(tidyr)
bateo_2 <- bateo %>%
  ungroup() %>%
  dplyr::select(nombre,edad,salary) %>%
  mutate(edad = edad/38, salary=salary/396000)

bateo_3 <- bateo_2 %>%
  gather(variable,valor,-nombre)

ggplot(bateo_3, aes(x=nombre, y=valor, fill = variable)) + 
  geom_bar(stat='identity', position='dodge') +
  scale_fill_manual(values=c('slateblue','deeppink')) +
  theme(axis.text.x=element_text(angle=35,size=16))

ggplot(bateo_2, aes(x=edad, y=salary))+geom_point()+geom_smooth(method='lm')