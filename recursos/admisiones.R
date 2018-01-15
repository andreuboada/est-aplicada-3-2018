datos <- read.csv('admissions.csv')
head(datos)
attach(datos)

#Tabla de frecuencias de admisiones y género
tabla = table(Gender,Admit)
prop.table(tabla,1)

# El 70% de las mujeres son rechazadas y hombres sólo el 55%.

# Por departamento
summary(Dept)

tabla2 = table(Gender,Dept)
prop.table(tabla2,1)
# Hay más hombres en A,B.
# Hay más mujeres en C,E.
# D, F están más distribuidos.

tabla3 = table(Dept,Admit)
prop.table(tabla3,1)
# A mayor letra, menos admitidos.

#El 92% de las mujeres aplican a C,D,E,F.
#El 78% de los hombres aplican a A,B,D,F.
#Los hombres aplican más a A,B que es donde hay más admitidos.
#Además, en el depto E mucho más mujeres aplican y únicamente 25% son admitidos.
#Esto refleja en la relación Género -> Admisión.

# No hay flecha directa de Género a Admisión porque condicionado
# a departamento el género no afecta tanto para saber si está admitido.
# Es decir, conociendo a qué departamento pertence, el saber de qué
# género es ya no te da más información sobre si es admitido o no.

deptA <- subset(datos,Dept == 'A')
tabA <- table(deptA$Gender,deptA$Admit)
prop.table(tabA,1)

deptB <- subset(datos,Dept == 'B')
tabB <- table(deptB$Gender,deptB$Admit)
prop.table(tabB,1)

deptC <- subset(datos,Dept == 'C')
tabC <- table(deptC$Gender,deptC$Admit)
prop.table(tabC,1)

deptD <- subset(datos,Dept == 'D')
tabD <- table(deptD$Gender,deptD$Admit)
prop.table(tabD,1)

deptE <- subset(datos,Dept == 'E')
tabE <- table(deptE$Gender,deptE$Admit)
prop.table(tabE,1)

deptF <- subset(datos,Dept == 'F')
tabF <- table(deptF$Gender,deptF$Admit)
prop.table(tabF,1)

# Los porcentajes entre mujer hombre por departamento son muy parecidos.
# Se puede observar que dado el departamento el género no tiene tanto efecto
# sobre admisión porque las tablas de contingencias muestran renglones
# "parecidos" entre hombres y mujeres.