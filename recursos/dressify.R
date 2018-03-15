library(tidyverse)

dressify <- read_csv("https://raw.githubusercontent.com/Peaceful-learner/Dressify-Challenge/master/train.csv", na = "null")

train <- dressify %>%
  dplyr::select(-(X16:X19))

train$Style[train$Style %in% c('Flare','Novelty','OL')] <- 'sexy'
train$Style[train$Style %in% c('work')] <- 'vintage'
train$Style <- factor(train$Style)

#Next we assign the "low" to "Low", "high" to "High" factor levels
train$Price[train$Price == "low"] <- "Low"
train$Price[train$Price == "high"] <- "High"

#refactoring the price rating variable in both train and test sets
train$Price <- factor(train$Price)

#performing trivial substitutions
train$NeckLine[train$NeckLine == "sweetheart"] <- "Sweetheart"
train$NeckLine <- factor(train$NeckLine)

train_2 <- train %>% dplyr::select(-ID) %>%
  mutate(Size = as.factor(Size),
         Season = as.factor(Season),
         SleeveLength = as.factor(SleeveLength),
         waiseline = as.factor(waiseline),
         Material = as.factor(Material),
         FabricType = as.factor(FabricType),
         Decoration = as.factor(Decoration),
         PatternType = as.factor(`Pattern Type`),
         Area = as.factor(Area),
         Recommended = as.factor(Recommended)) %>%
  dplyr::select(-`Pattern Type`) %>%
  as_tibble() %>%
  as.data.frame()

library(mi)
mdf <- missing_data.frame(train_2)
show(mdf)
#imputations <- mi(mdf, n.iter = 4, n.chains = 2)
saveRDS(object = imputations, file = "imputations.rds")
dfs <- complete(imputations, m = 1)

id_df <-  train %>% dplyr::select(ID) 

train_3 <- dfs %>%
  as_tibble() %>%
  dplyr::select(-starts_with("missing")) %>%
  bind_cols(id_df) %>%
  dplyr::select(ID, Style:PatternType)

write_csv(x = train_3, "dressify.csv")
