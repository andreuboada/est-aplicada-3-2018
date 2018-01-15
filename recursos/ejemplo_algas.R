library(ggplot2)
library(plyr)
library(Hmisc)
library(dplyr)
library(tidyr)
library(lubridate)
library(stringr)
library(party)

ds.path <- "algas.txt" # Puede ser un URL o una dirección en el directorio

ds.name <- "algas" # Nombre de nuestro conjunto de datos, e.g. algas, german

ds <- loadData(name = ds.name, full_path = ds.path)

#ds <- tbl_df(ds) # Para obtener un print mejorado

sapply(ds, class)

(porcentaje.respuesta.b <- round(100 * prop.table(table(ds$TARGET_B)), digits=1))


# Limpieza de metadatos

names(ds) <- normalizarNombres(names(ds))
names(ds)

# Ajuste de formatos

sapply(ds, class)

# Transformación de variables
vars <- names(ds) # Guardamos los nombres de variables
vars
target <- c("")  # Si el modelo es supervisado

risk <- NULL # Si se proveé, es la importancia de la observación respecto a la variable (es una variable de salida)

costo <- NULL # Costo de equivocarse en la predicción (Si se proveé) (es una variable de salida)

#id <-  # Armar una id con columnas, o seleccionar el id del dataset


# Recodificación

vars.input <- setdiff(vars, target)
idxs.input <- sapply(vars.input, function(x){ which(x == names(ds)) }, USE.NAMES=F)

idxs.numericas <- intersect(idxs.input, which(sapply(ds, is.numeric)))
vars.numericas <- names(ds)[idxs.numericas]

idxs.categoricas <- intersect(idxs.input, which(sapply(ds, is.factor)))
vars.categoricas <- names(ds)[idxs.categoricas]


# Variables a ignorar
### IDs y variables de salida

vars.a.ignorar <- union(union(id, if (exists("risk")) risk), if(exists("cost")) cost)

### Constantes y valores únicos por observación
# Ignoramos las que tengan un único valor por cada observación, pueden ser IDs
# IMPORTANTE: Esto puede eliminar fechas, ver sección anterior

ids <- names(which(sapply(ds, function(x) length(unique(x)) == nrow(ds))))

# Ignoramos los factores que tengan muchos niveles
# IMPORTANTE: ver sección anterior

factors <- which(sapply(ds[vars], is.factor))
niveles <- sapply(factors, function(x) length(levels(ds[[x]])))
(muchos.niveles <- names(which(niveles > 32)))

vars.a.ignorar <- union(vars.a.ignorar, muchos.niveles)

# Constantes


constantes <- names(which( sapply( ds[vars], function(x) all(x == x[1L]))))

vars.a.ignorar <- union(vars.a.ignorar, c(ids, constantes))


### Faltantes
# Las que sean puros NAs
ids.nas.count <- sapply(ds[vars], function(x) sum(is.na(x)))
ids.nas <- names(which(ids.nas.count == nrow(ds)))

vars.a.ignorar <- union(ids.nas, vars.a.ignorar)

# Las que tengan muchos NAs (un 70% o más)
ids.many.nas <- names(which(ids.nas.count >= 0.7*nrow(ds)))

vars.a.ignorar <- union(ids.many.nas, vars.a.ignorar)

length(vars.a.ignorar)

vars.a.ignorar

### Variable de salida (`target`) 

dim(ds)
ds <- ds[!is.na(ds[target[1]]),]
ds <- ds[!is.na(ds[target[2]]),]
dim(ds)

sapply(ds[,target], class)


ds[target[1]] <- as.factor(ds[[target[1]]])

table(ds[target[1]])
sapply(ds[,target], class)

ggplot(data=ds, aes_string(x=target[1])) + geom_bar(width=0.3)

# Variables correlacionadas

(system.time(vars.cor <- cor(ds[which(sapply(ds, is.numeric))], use="pairwise.complete.obs")))

vars.cor[upper.tri(vars.cor, diag=TRUE)] <- NA

vars.cor <- vars.cor                                  %>%
  abs()                                     %>%   
  data.frame()                              %>%
  mutate(var1=row.names(vars.cor))          %>%
  gather(var2, cor, -var1)                  %>%
  na.omit()


vars.cor <- vars.cor[order(-abs(vars.cor$cor)), ]

if (!file.exists("output")) dir.create("output") # Creamos la carpeta output, si no existe

# Guardar a CSV para tenerlo como respaldo
write.csv(vars.cor, "output/absolute_correlation.csv", row.names=FALSE)

(muy.cor <- filter(vars.cor, cor > 0.95)) # Mostramos las que tengan más del 95% de correlación

# Habría que decidir si se remueven y cuales se remueven (var1 o var2)
vars.a.ignorar <- union(vars.a.ignorar, muy.cor$var2)


sapply(names(which(sapply(ds.positive, is.factor))), pruebaChiCuadrada, var2=ds$target.d2)

# Valores faltantes

# En esta sección hay que poner la estrategia de manejo de valores faltantes elegida durante la etapa del EDA.
# 
# Hay muy pocas ocasiones donde es recomendable dejar que el modelo se encargue de las imputaciones.
# 
# Las observaciones a omitir, guárdalas en `observaciones.omitidas`.


observaciones.omitidas <- NULL

if (!file.exists("output")) dir.create("output") # Creamos la carpeta clean, si no existe

if(exists("observaciones.omitidas")) {
  write.csv(observaciones.omitidas, "output/observaciones_omitidas.csv", row.names=FALSE)
}



# Normalizar niveles

factors <- which(sapply(ds[vars], is.factor))
for (f in factors) levels(ds[[f]]) <- normalizarNombres(levels(ds[[f]]))

# Removemos las variables
vars <- setdiff(vars, vars.a.ignorar)


# Identificación de Variables
## Variables independientes

(vars.input <- setdiff(vars, target))
idxs.input <- sapply(vars.input, function(x) which(x == names(ds)), USE.NAMES=FALSE)


## Variables numéricas


idxs.numericas <- intersect(idxs.input, which(sapply(ds, is.numeric)))
(vars.numericas <- names(ds)[idxs.numericas])


## Variables categóricas

idxs.categoricas <- intersect(idxs.input, which(sapply(ds, is.factor)))
(vars.categoricas <- names(ds)[idxs.categoricas])



# Por conveniencia guardamos el número de observaciones supervivientes
num.observaciones <- nrow(ds)


## Variables target

target



# Guardamos todo en la carpeta 
ds.date <- paste0("_", format(Sys.Date(), "%Y%m%d"))
ds.rdata <- paste0(ds.name, ds.date, ".RData") # Guardamos todo en un RData para poder automatizar el modelado

if (!file.exists("clean")) dir.create("clean") # Creamos la carpeta clean, si no existe

save(ds, ds.name, ds.path, ds.date, target, risk, costo, 
     id, 
     #vars.a.ignorar, 
     vars, num.observaciones, 
     vars.input, idxs.input,
     observaciones.omitidas,
     vars.categoricas, idxs.categoricas,
     file=paste0("clean", "/", ds.rdata)
)
