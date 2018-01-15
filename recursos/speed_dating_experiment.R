library(readr)
library(ggplot2)
library(dplyr)
library(tidyr)

data <- read.csv("speed-dating-experiment/Speed Dating Data.csv")
data$income2 <- sub(",", "", data$income)
data$income2 <- as.numeric(data$income2)

method1 <- data[data$wave>5 & data$wave<10,]
method2 <- data[data$wave<6 | data$wave>9,]

data_ingreso_objetivo <- data %>%
  select(iid,ingreso=income2,objetivo=goal) %>%
  na.omit() %>%
  distinct()
data_ingreso_objetivo$objetivo <- as.factor(data_ingreso_objetivo$objetivo)
levels(data_ingreso_objetivo$objetivo) <- list(Fun=1,`Meet people`=2,`Date`=3,
                                               `Serious relationship`=4, `Experiencie`=5,`Other`=6)
bymedian <- with(data_ingreso_objetivo, reorder(objetivo, ingreso, median))
options(scipen=5)
par(mar=c(12,5,3,3))
boxplot(data_ingreso_objetivo$ingreso~bymedian, ylab="Ingreso", xlab="", xaxt="n")
axis(1, at=1:6, labels=levels(bymedian), las=2)
mtext("Razón por la cual participan", side=1, line=10)

# what matters most in mate choice?
par(mar=c(10,5,3,3))
boxplot(method2$attr1_1, method2$sinc1_1,method2$intel1_1,method2$fun1_1,method2$amb1_1,method2$shar1_1, names=c("Attractiveness", "Sincerity", "Intelligence", "Fun", "Ambition", "Shared Interests"), las=2, ylab="Importance /100")
seleccion_pareja <- data.frame(iid=method2$iid,
                               attr1_1=method2$attr1_1,
                               sinc1_1=method2$sinc1_1,
                               intel1_1=method2$intel1_1,
                               fun1_1=method2$fun1_1,
                               amb1_1=method2$amb1_1,
                               shar1_1=method2$shar1_1) %>%
  distinct() %>%
  na.omit()
seleccion_pareja_final <- data.frame(iid=method2$iid,
                                     attr1_1=method2$attr1_1,
                                     sinc1_1=method2$sinc1_1,
                                     intel1_1=method2$intel1_1,
                                     fun1_1=method2$fun1_1,
                                     amb1_1=method2$amb1_1,
                                     shar1_1=method2$shar1_1,
                               attr1_3=method2$attr1_3,
                               sinc1_3=method2$sinc1_3,
                               intel1_3=method2$intel1_3,
                               fun1_3=method2$fun1_3,
                               amb1_3=method2$amb1_3,
                               shar1_3=method2$shar1_3) %>%
  na.omit() %>% distinct()

# who are the people who only want attractiveness? - CEOs, presidents
# who are the people who don't care? - Professor/want to be professor
par(mar=c(10,5,3,3))
#ggplot(data, aes(factor(career_c), attr1_1)) + geom_boxplot()
atractivo <- method2[!duplicated(method2$iid),]
atractivo_carrera <- atractivo[,c('attr1_1','career_c')] %>% na.omit()
codigos_carrera <- data.frame(career_c=seq(1,17,1), carrera=c("Lawyer", "Academic", "Psychologist", "Doctor", "Engineer", "Entertainment", "Finance/Business", "Real Estate", "International Affairs", "Undecided", "Social Work", "Speech Pathology", "Politics", "Pro sports/Athlete", "Other", "Journalism", "Architecture"))
atractivo_carrera <- atractivo_carrera %>%
  left_join(codigos_carrera, by = 'career_c')
atractivo_carrera$carrera <- as.character(atractivo_carrera$carrera)
aux <- atractivo_carrera %>%
  group_by(carrera) %>%
  summarise(num=n()) %>%
  ungroup() %>% as.data.frame()
aux$carrera <- as.character(aux$carrera)
aux <- aux %>%
  filter(num >= 10 & carrera != 'Undecided')
atractivo_carrera_2 <- atractivo_carrera %>%
  filter(carrera %in% aux$carrera) %>%
  mutate(career_c=ifelse(career_c==11,8,career_c)) %>%
  arrange(career_c)
codigos <- unique(atractivo_carrera_2$carrera)
boxplot(atractivo_carrera_2$attr1_1~atractivo_carrera_2$career_c, xaxt="n",ylab='Importancia al atractivo físico')
abline(h=median(atractivo_carrera$attr1_1, na.rm=T))
axis(1,at=seq(1,9,1),labels=codigos, las=2)

# sincerity - genuinely interesting
sinceridad <- method2[!duplicated(method2$iid),]
sinceridad_carrera <- sinceridad[,c('iid','sinc1_1','career_c')] %>% na.omit()
codigos_carrera <- data.frame(career_c=seq(1,17,1), carrera=c("Lawyer", "Academic", "Psychologist", "Doctor", "Engineer", "Entertainment", "Finance/Business", "Real Estate", "International Affairs", "Undecided", "Social Work", "Speech Pathology", "Politics", "Pro sports/Athlete", "Other", "Journalism", "Architecture"))
sinceridad_carrera <- sinceridad_carrera %>%
  left_join(codigos_carrera, by = 'career_c')
sinceridad_carrera$carrera <- as.character(sinceridad_carrera$carrera)
aux <- sinceridad_carrera %>%
  group_by(carrera) %>%
  summarise(num=n()) %>%
  ungroup() %>% as.data.frame()
aux$carrera <- as.character(aux$carrera)
aux <- aux %>%
  filter(num >= 10 & carrera != 'Undecided')
sinceridad_carrera_2 <- sinceridad_carrera %>%
  filter(carrera %in% aux$carrera) %>%
  mutate(career_c=ifelse(career_c==11,8,career_c)) %>%
  arrange(career_c)
codigos <- unique(sinceridad_carrera_2$carrera)
boxplot(sinceridad_carrera_2$sinc1_1~sinceridad_carrera_2$career_c, xaxt="n", ylab="Importancia a la sinceridad")
abline(h=median(sinceridad_carrera_2$sinc1_1, na.rm=T))
axis(1,at=seq(1,9,1),labels=codigos, las=2)

# Diferencias raciales
raza <- method2 %>% select(iid,samerace,race,imprace,race_o,pid,match) %>% distinct() %>%
  mutate(imprace=1*(imprace>=5)) %>% na.omit()
# Calcula la probabilidad de que una pareja sea match dado que la raza de la pareja es
# Asiática ``Asian/Pacific Islander/Asian-American=4''.
# Calcula la probabilidad de que una pareja sea match.
# ¿Son variables independientes?

# how do people's ratings of their own attractiveness determine their preferences for partners attractiveness
# more attractive people have a stronger preference for attractiveness in a partner
summary(lm(method2$attr3_1~method2$attr1_1))
#plot(method2$attr3_1, method2$attr1_1)
atractivos <- method2 %>% select(iid, attr3_1, attr1_1) %>% na.omit()
ggplot(atractivos, aes(factor(attr3_1), attr1_1)) + geom_boxplot() +
  xlab('Percepción de atractivo físico propio') +
  ylab('Preferencia por una pareja atractiva') +
  theme_classic()
ggplot(atractivos, aes(attr3_1, attr1_1)) + geom_jitter() +
  xlab('Percepción de atractivo físico propio') +
  ylab('Preferencia por una pareja atractiva')

# how did people rate their own intelligence in comparison to their date's?
ggplot(data, aes(y=intel, x=intel3_1)) +
  geom_point(shape=1, position=position_jitter(width=1,height=1)) +
  xlim(0,10) + ylim(0,10) +
  theme(panel.background = element_blank()) +
  ylab("Inteligencia de su cita") + xlab("Propia inteligencia") +
  geom_abline(slope = 1, intercept = 0, color = 'red')

data_inteligencia <- data %>%
  select(iid,`Percepción de inteligencia de su cita`=intel,`Percepción propia de inteligencia`=intel3_1) %>%
  na.omit() %>%
  gather(intel,valor,-iid)
ggplot(data_inteligencia, aes(x=intel,y=valor, group = intel)) + geom_boxplot() +
  xlab('') + theme_classic() +
  theme(axis.text.x = element_text(angle=10,size=12))


# sincerity re-evaluated after the experiment?
boxplot(method2$sinc1_1, method2$sinc1_3, main="Sincerity", names=c("Before", "After"), las=2)


plot(density(data$intel3_1, na.rm=T, bw=1,ltw=2), xlab="Inteligencia percibida", xlim=c(0,10),main = 'Diferencias de percepción')
lines(density(data$intel, na.rm=T, bw=1), col="grey", lty=4, lwd = 4)
legend(0.5,0.25, c('Propia','De su cita'), # puts text in the legend
      lty=c(1,4),
      lwd=c(2,3),col=c('black','grey'),text.font=1,cex=1.2,horiz=F,text.width = 3.3)

# people generally realise they care about attractiveness more than they thought they did
plot(method2$attr1_1, method2$attr1_3, xlab="Initial value on atractiveness", ylab="Value on attractiveness after experiment", xlim=c(0,100), ylim=c(0,100))
lines(seq(0,100,10), seq(0,100,10))

boxplot(method2$attr1_3, method2$sinc1_3,method2$intel1_3,method2$fun1_3,method2$amb1_3,method2$shar1_3, names=c("Attractiveness", "Sincerity", "Intelligence", "Fun", "Ambition", "Shared Interests"), las=2, ylab="Importance /100")

