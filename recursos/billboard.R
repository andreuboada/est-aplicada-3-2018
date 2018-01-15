library(ggplot2)
library(RColorBrewer)
library(reshape2)
library(gridExtra)
library(dplyr)
library(tidyr)
library(readr)
library(stringr)
allthesongs <- read.csv("billboard/billboard_lyrics_1964-2015.csv", stringsAsFactors=FALSE)

allthesongs <- allthesongs %>%
  dplyr::select(-Source)


artists <- data.frame(table(allthesongs$Artist))
artists$Var1 <- as.character(artists$Var1)
artists$Artist <- sapply(artists$Var1, function(x) strsplit(x, " featuring")[[1]][1])
artists <- aggregate(Freq ~ Artist, artists, sum)
artists <- artists[order(-artists$Freq), ]
artists20 <- artists[1:20, ]
artists20<- artists20[order(artists20$Freq), ]
artists20$Artist <- factor(artists20$Artist, levels=artists20$Artist)

c <- ggplot(artists20, aes(Artist, Freq)) + geom_bar(stat="identity", fill="black",width = 0.3) + theme_classic() +
  labs(title="Número de canciones, Top 20 artistas") + geom_text(aes(label=Freq), hjust=-0.25) +
  annotate("text", y=30, x=4, label="Billboard cierre de año\nHot 100 1965-2015") +
  ylab("") + xlab("") + coord_flip()

d <- ggplot(artists, aes(Freq)) + geom_bar(fill="black") + theme_classic() + ylab("") + xlab("") +
  labs(title="Número de canciones por artista") +
  annotate("text", y=150, x=30, label="Billboard cierre de año \nHot 100 1965-2015")

grid.arrange(d,c, ncol=2, widths=c(0.45, 0.55)) #artists_billboard.png



colaboraciones <- allthesongs[grepl("feat|duet| with | and ", allthesongs$Artist), ]
write.csv(x = colaboraciones, file = 'colaboraciones.csv', fileEncoding = 'latin1', row.names = F)
obten_artistas <- function(i){
  artista <- colaboraciones$Artist[i]
  aux <- str_split(artista,'featuring|feat|duet| with | and ')[[1]]
  auxx<-data.frame(i=colaboraciones$Rank[i],
                   num_artista=paste0('artista',1:length(aux)),
                   artista=aux,
                   cancion=colaboraciones$Song[i],
                   year=colaboraciones$Year[i],
                   letra=colaboraciones$Lyrics[i])
  auxx$num_artista <- as.character(auxx$num_artista)
  auxx$artista <- as.character(auxx$artista)
  auxx$letra <- as.character(auxx$letra)
  auxx$cancion <- as.character(auxx$cancion)
  auxx$year <- as.character(auxx$year)
  return(auxx)
}
artistas <- lapply(1:nrow(colaboraciones), obten_artistas)
colaboraciones_2 <- Reduce(bind_rows, artistas)

nombre <- function(str){
  aux <- str_split(str,' ')[[1]]
  aux <- aux[which(nchar(aux)>0)]
  res <- paste0(aux, collapse = ' ')
  return(str_to_upper(res))
}

artistas <- colaboraciones_2$artista

artistas <- Reduce(rbind, lapply(artistas, nombre))

colaboraciones_2$artista <- artistas

artistas_con_mas_colaboraciones <- colaboraciones_2 %>%
  group_by(artista) %>%
  summarise(num_colaboraciones = n()) %>%
  arrange(desc(num_colaboraciones)) %>%
  head(30)
art_colab <- artistas_con_mas_colaboraciones$artista

colaboraciones_3 <- colaboraciones_2 %>%
  tidyr::spread(num_artista,artista) %>%
  gather(num_artista,artista,-i,-cancion,-year,-letra,-artista1) %>%
  filter(!is.na(artista)) %>%
  filter(artista1 %in% art_colab | artista %in% art_colab) %>%
  rename(Rank=i)

colab_rihanna <- colaboraciones_3 %>% filter(artista1=='RIHANNA'|artista=='RIHANNA') %>%
  mutate(top15 = 1*(Rank<=15)) %>%
  mutate(top15 = as.factor(top15)) %>%
  mutate(Artista = 'Rihanna')
colab_beyonce <- colaboraciones_3 %>% filter(artista1=='BEYONCE'|artista=='BEYONCE') %>%
  mutate(top15 = 1*(Rank<=15)) %>%
  mutate(top15 = as.factor(top15)) %>%
  mutate(Artista = 'Beyoncé')
colabs_ri_be <- bind_rows(colab_rihanna,colab_beyonce) %>%
  mutate(Artista = as.factor(Artista)) %>%
  select(cancion,year,Rank,Artista,top15,letra)
write.csv(x = colabs_ri_be, file = 'colabs_rihanna_beyonce.csv', fileEncoding = 'utf-8',row.names = F)

ggplot(colabs_ri_be, aes(x=Artista, fill=top15)) +
  geom_bar(position="dodge",alpha=0.7) +
  stat_count(aes(label=paste0(sprintf("%1.1f", ..count../sum(..count..)*100),
                              "%\n", ..count..), y=0.5*..count..),
             geom="text", colour="black", size=2, position=position_dodge(width=1))

resumen = colabs_ri_be %>% group_by(Artista, top15) %>%
  tally %>%
  group_by(Artista) %>%
  mutate(pct = n/sum(n),
         n.pos = (cumsum(n) - 0.5*n)/sum(n))

ggplot(resumen, aes(x=Artista, y=pct, fill=top15)) +
  geom_bar(stat="identity",alpha=0.7) +
  geom_text(aes(label=paste0(sprintf("%1.1f", pct*100),"%"), y=n.pos),
            colour="black") +
  scale_y_continuous(name = 'Frecuencia relativa condicional') + theme_bw()


todas_no_colab <- allthesongs[!grepl('featuring|feat|duet| with | and ', allthesongs$Artist), ]
no_colab_rih <- todas_no_colab %>%
  filter(grepl('rihanna',Artist)) %>%
  mutate(top50 = 1*(Rank<=50)) %>%
  mutate(top50 = as.factor(top50)) %>%
  mutate(Artista = 'Rihanna')

no_colab_bey <- todas_no_colab %>%
  filter(grepl('beyonce',Artist))  %>%
  mutate(top50 = 1*(Rank<=50)) %>%
  mutate(top50 = as.factor(top50)) %>%
  mutate(Artista = 'Beyoncé')
no_colab_ri_be <- bind_rows(no_colab_rih,no_colab_bey) %>%
  mutate(Artista = as.factor(Artista)) %>%
  select(cancion=Song,year=Year,Rank,Artista,top50,letra=Lyrics)
write.csv(x = no_colab_ri_be, file = 'no_colab_rihanna_beyonce.csv', fileEncoding = 'latin1',row.names = F)


resumen = no_colab_ri_be %>% group_by(Artista, top50) %>%
  tally %>%
  group_by(Artista) %>%
  mutate(pct = n/sum(n),
         n.pos = (cumsum(n) - 0.5*n)/sum(n))

ggplot(resumen, aes(x=Artista, y=pct, fill=top50)) +
  geom_bar(stat="identity",alpha=0.7) +
  geom_text(aes(label=paste0(sprintf("%1.1f", pct*100),"%"), y=n.pos),
            colour="black") +
  scale_y_continuous(name = 'Frecuencia relativa condicional') + theme_bw()

complejidad <- allthesongs %>%
  filter(grepl('beyonce|rihanna', Artist)) %>%
  filter(!is.na(Lyrics)) %>%
  select(Lyrics)
write.csv(x = complejidad, file = 'complejidades.csv', fileEncoding = 'utf-8', row.names = F)


complejidades <- read_csv(file = 'results_complejidades.csv') %>%
  select(coleman_liau=`Coleman Liau Index`)

compejidades_2 <- allthesongs %>%
  filter(grepl('beyonce|rihanna', Artist)) %>%
  filter(!is.na(Lyrics)) %>%
  bind_cols(complejidades) %>%
  filter(!is.na(coleman_liau))%>%
  mutate(`Beyonce` = 1*(grepl('beyonce',Artist)) )


write.csv(x = compejidades_2, file = 'complejidad_lirica_beyonce_rihanna.csv', fileEncoding = 'latin1', row.names = F)
