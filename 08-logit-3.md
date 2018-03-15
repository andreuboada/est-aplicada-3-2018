
# Regresión logística 3

<style>
  .espacio {
     margin-bottom: 1cm;
  }
</style>

<style>
  .espacio3 {
     margin-bottom: 3cm;
  }
</style>


```r
library(tidyverse)
```

## Ejemplo óscares

Algunas de los factores citados usualmente por las personas como importantes para que una película gane un Óscar son:

1. Estar nominada a Mejor Director.

2. Haber ganado un premio en los Director’s Guild Awards.

3. Tener más nominaciones a la Academia.

4. Ganó mejor película en Golden Globe Awards.

5. La calificación en IMdb.

6. El score de Metacritic

7. El gusto de las personas por la película.

8. El score en RT de los críticos más destacados.

9. Las recaudaciones en taquilla dométicas.

10. Las recaudaciones en taquilla generales.

11. El presupuesto con el que se realizó la película.

12. La duración de la película.

13. El número de estrellas "conocidas"


Contamos con datos que provienen de varias fuentes y se tienen las siguientes variables disponibles:

| Variable    | Descripción| Fuente   |
| -------- |-------------------|----------|
| film | Nombre de la película nominada   |
| year | Año de nominación de la película|   |
| release_date | Fecha de lanzamiento | IMdb |
| mpaa | Clasificación | IMdb |
| imdb_score | Rating de IMdb | IMdb |
| metacritic_score | Score de Metacritic | IMdb |
| rt_audience_score | % de personas que la favorecen| Rotten Tomatoes |
| rt_critic_score | Score de "Top critics" | Rotten Tomatoes |
| bo | Recaudado en taquilla | Box Office Mojo |
| budget | Estimated budget | Wikipedia |
| running_time | Duración (en minutos) | Wikipedia
| stars_count | \# de actores mostrados en el recuadro | Wikipedia
| aabd | Nominación a mejor director Óscar| Wikipedia
| dga | Ganadora del Director's Guild | Wikipedia
| noms | Número de nominaciones al Óscar | Wikipedia
| ggbp | Ganadora en los Globos | Wikipedia
| winner | Ganó Óscar | Wikipedia



```r
oscars <- read_csv("datos/oscars.csv")
glimpse(oscars)
#> Observations: 156
#> Variables: 17
#> $ film              <chr> "Forrest Gump", "Four Weddings and a Funeral...
#> $ year              <int> 1994, 1994, 1994, 1994, 1994, 1995, 1995, 19...
#> $ release_date      <date> 1994-07-06, 1994-04-15, 1994-10-14, 1994-10...
#> $ mpaa              <chr> "PG-13", "R", "R", "PG-13", "R", "PG", "G", ...
#> $ imdb_score        <dbl> 8.8, 7.1, 8.9, 7.5, 9.3, 7.6, 6.8, 8.4, 7.7,...
#> $ metacritic_score  <int> 82, 81, 94, 88, 80, 77, 83, 68, 84, 81, 85, ...
#> $ rt_audience_score <int> 95, 74, 96, 87, 98, 87, 67, 85, 90, 94, 92, ...
#> $ rt_critic_score   <int> 72, 95, 94, 96, 91, 95, 97, 77, 98, 93, 93, ...
#> $ bo                <dbl> 677.90, 245.70, 213.90, 24.80, 58.30, 355.20...
#> $ budget            <dbl> 55.0, 2.8, 88.5, 31.0, 25.0, 52.0, 30.0, 65....
#> $ running_time      <int> 142, 117, 154, 133, 142, 140, 92, 178, 136, ...
#> $ stars_count       <int> 5, 10, 12, 5, 7, 6, 2, 4, 4, 3, 5, 7, 12, 5,...
#> $ aabd              <int> 1, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 1,...
#> $ dga               <int> 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1,...
#> $ noms              <int> 19, 12, 17, 11, 7, 7, 6, 6, 17, 1, 12, 7, 12...
#> $ ggbp              <int> 1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 1,...
#> $ winner            <int> 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1,...
```

Ajustamos un modelo de regresión logística para "winner" utilizando como predictores "imdb_score + metacritic_score + rt_audience_score + rt_critic_score + bo + budget + running_time + stars_count + aabd + dga + noms + ggbp":


```r
oscars_2 <- oscars %>%
  mutate(imdb_score = imdb_score/10,
         metacritic_score = metacritic_score/100,
         rt_audience_score = rt_audience_score/100,
         bo = log(bo),
         budget = log(budget),
         running_time = log(running_time),
         stars_count = log(stars_count)) %>%
  filter(year < 2017)
fit.1 <- glm(formula = winner ~ imdb_score + rt_critic_score + bo + budget + 
               running_time + stars_count + aabd + dga + noms + ggbp, 
             family = binomial(link = "logit"), 
             data = oscars_2)
fit.1
#> 
#> Call:  glm(formula = winner ~ imdb_score + rt_critic_score + bo + budget + 
#>     running_time + stars_count + aabd + dga + noms + ggbp, family = binomial(link = "logit"), 
#>     data = oscars_2)
#> 
#> Coefficients:
#>     (Intercept)       imdb_score  rt_critic_score               bo  
#>        -14.7473          11.0596          -0.0426           0.1991  
#>          budget     running_time      stars_count             aabd  
#>         -0.7994           0.9864           0.6808           0.6482  
#>             dga             noms             ggbp  
#>          3.6727           0.1642           0.4169  
#> 
#> Degrees of Freedom: 146 Total (i.e. Null);  136 Residual
#> Null Deviance:	    128 
#> Residual Deviance: 65.7 	AIC: 87.7
```


```r
mean(oscars$dga)
#> [1] 0.154
```


Podemos ver las probabilidades $p_1({x^{(i)}})$, $i=1,\ldots,N$, que _predice_ el modelo utilizando la función `predict`:


```r
predict(fit.1, type="response")
#>        1        2        3        4        5        6        7        8 
#> 0.979292 0.080864 0.210608 0.013778 0.060864 0.188686 0.002499 0.034669 
#>        9       10       11       12       13       14       15       16 
#> 0.042967 0.004579 0.095418 0.007524 0.193038 0.116403 0.930428 0.025499 
#>       17       18       19       20       21       22       23       24 
#> 0.105491 0.023082 0.042503 0.744668 0.011385 0.029657 0.773747 0.119831 
#>       25       26       27       28       29       30       31       32 
#> 0.016132 0.978409 0.062259 0.040791 0.014552 0.032914 0.044156 0.478123 
#>       33       34       35       36       37       38       39       40 
#> 0.018495 0.150354 0.029615 0.938574 0.066907 0.063561 0.021840 0.128031 
#>       41       42       43       44       45       46       47       48 
#> 0.837398 0.026380 0.324370 0.028328 0.053700 0.186569 0.005487 0.102118 
#>       49       50       51       52       53       54       55       56 
#> 0.004324 0.912908 0.032282 0.454924 0.034419 0.060990 0.059391 0.944622 
#>       57       58       59       60       61       62       63       64 
#> 0.071828 0.335235 0.054461 0.014381 0.181415 0.011564 0.034738 0.850732 
#>       65       66       67       68       69       70       71       72 
#> 0.037506 0.054856 0.046618 0.023317 0.757340 0.055775 0.042111 0.028372 
#>       73       74       75       76       77       78       79       80 
#> 0.873698 0.057019 0.087092 0.002829 0.015224 0.011532 0.014084 0.071483 
#>       81       82       83       84       85       86       87       88 
#> 0.010316 0.017203 0.598860 0.000934 0.025656 0.006078 0.118978 0.021457 
#>       89       90       91       92       93       94       95       96 
#> 0.055964 0.031121 0.923980 0.055082 0.002808 0.012944 0.016335 0.007388 
#>       97       98       99      100      101      102      103      104 
#> 0.003131 0.024420 0.006746 0.725232 0.061440 0.114100 0.002055 0.002480 
#>      105      106      107      108      109      110      111      112 
#> 0.017222 0.406895 0.019276 0.025923 0.033696 0.011340 0.060555 0.099039 
#>      113      114      115      116      117      118      119      120 
#> 0.006466 0.356416 0.075537 0.007128 0.030705 0.135007 0.007054 0.039183 
#>      121      122      123      124      125      126      127      128 
#> 0.009095 0.051619 0.002576 0.240445 0.272211 0.004463 0.142060 0.142537 
#>      129      130      131      132      133      134      135      136 
#> 0.065616 0.055508 0.005639 0.008353 0.004578 0.059580 0.042772 0.046167 
#>      137      138      139      140      141      142      143      144 
#> 0.013173 0.500113 0.015982 0.006753 0.036636 0.007289 0.010139 0.825918 
#>      145      146      147 
#> 0.047052 0.138713 0.345245
```

<br>

**Responde las siguientes preguntas:**

![](figuras/manicule2.jpg) 
<div class="centered">
<p class="espacio">
</p>
La variable que tiene más impacto en la probabilidad de ganar un Óscar...

(a) Ganó un premio en el Director's Guild.  

(b) Número de nominaciones a los Óscares. 

(c) Crítica de Rotten Tomatoes (Top critics).

(d) Presupuesto de la película.

<p class="espacio3">
</p>
</div>
<br>

![](figuras/manicule2.jpg) 
<div class="centered">
<p class="espacio">
</p>
Si la película ganó un premio en los Director's Guild, entonces 

(a) la probabilidad logit de ganar un Óscar aumenta en 3.67. 

(b) los momios de ganar un Óscar son $0.92$.

(c) la probabilidad de ganar un Óscar aumenta en $0.92$.

(d) los momios de ganar un Óscar aumentan en $e^{3.67}$.

<p class="espacio3">
</p>
</div>
<br>

Correspondientes al 2017 estas películas fueron nominadas al premio de la academia:


```r
oscars %>% 
  filter(year == 2017) %>% 
  select(film,year,release_date, mpaa, imdb_score,rt_critic_score) %>% 
  knitr::kable()
```



film                                         year  release_date   mpaa     imdb_score   rt_critic_score
------------------------------------------  -----  -------------  ------  -----------  ----------------
Call Me by Your Name                         2017  2018-01-19     R               8.1                96
Darkest Hour                                 2017  2017-12-22     PG-13           7.4                86
Dunkirk                                      2017  2017-07-21     PG-13           8.0                93
Get Out                                      2017  2017-02-24     R               7.7                99
Lady Bird                                    2017  2017-12-01     R               7.6                99
Phantom Thread                               2017  2018-01-19     R               7.8                91
The Post                                     2017  2018-01-12     PG-13           7.3                88
The Shape of Water                           2017  2017-12-22     R               7.7                92
Three Billboards Outside Ebbing, Missouri    2017  2017-12-01     R               8.3                92

Veamos qué predicciones obtenemos para el 2017:


```r
oscars_3 <- oscars %>%
  mutate(imdb_score = imdb_score/10,
         metacritic_score = metacritic_score/100,
         rt_audience_score = rt_audience_score/100,
         bo = log(bo),
         budget = log(budget),
         running_time = log(running_time),
         stars_count = log(stars_count)) %>%
  filter(year == 2017) %>% 
  select(imdb_score,rt_critic_score,bo,budget,running_time,stars_count,aabd,dga,noms,ggbp)
predict(fit.1, type="response", newdata = oscars_3)
#>       1       2       3       4       5       6       7       8       9 
#> 0.07409 0.00672 0.01005 0.06379 0.07457 0.00597 0.00422 0.76347 0.17262
```

La probabilidad de predicción más alta es 0.76347 que corresponde a _The Shape Of Water_.

---

<br>

## Repaso de regresión logística

En un problema de clasificación donde las $y_i$'s son binarias, desearíamos tener un modelo de la forma:
$$
\pi_i = x_i^\prime \beta
$$
donde $\beta$ es un vector de coeficientes. 

<p class="espacio">
</p>

El problema es que el componente lineal puede tomar cualquier valor _real_, mientras que $\pi_i$ sólo puede tomar valores entre $0$ y $1$.

Una alternativa es utilizar los momios:

$$
\Omega_i = \dfrac{\pi_i}{1-\pi_i},
$$
el cociente de la probabilidad y su complemento, la razón de exitosos por fracasados.

<p class="espacio">
</p>

\BeginKnitrBlock{information}<div class="information">**Nota:** 

<p class="espacio">
</p>

* Si la probabilidad de un evento es $1/2$, entonces los momios son _uno a uno_ o _justos_.

* Si la probabilidad es $1/3$, entonces los momios son uno a dos.</div>\EndKnitrBlock{information}

<br>

Los momios toman valores entre $0$ e $\infty$, lo cual no los hace del todo útiles para especificar nuestro modelo. Por lo tanto lo planteamos de la forma:

$$
\mbox{logit}(\pi_i) = x_i^\prime\beta
$$

La trasformación logit es _uno a uno_. La función logit inversa $\mbox{logit}^{-1}$ nos permite regresar de probabilidades logits a probabilidades usuales.

Podemos ver gráficamente la transformación logit:


```r
logit <- function(x){log((x/((1-x))))}
graf_data <- data_frame(x = seq(0, 1, length.out = 100), logit = logit(x))
ggplot(graf_data, aes(x = x)) + 
  geom_line(aes(y = logit), colour = 'lightpink', size=1.2)
```

<img src="08-logit-3_files/figure-html/unnamed-chunk-10-1.png" width="60%" style="display: block; margin: auto;" />

Despejando para $\pi_i$ obtenemos 

$$
\pi_i = \mbox{logit}^{-1}(\eta_i)=\mbox{logit}^{-1}(x_i^\prime\beta)=\dfrac{e^{x_i^\prime\beta}}{1+e^{x_i^\prime\beta}}
$$

donde $\eta_i=x_i^\prime\beta$.

Cada variable aleatoria $y_i$ puede tomar valor de $0$ o $1$, fracaso o éxito, respectivamente. Por lo tanto, $y_i$ tiene una distribución Bernoulli con probabilidad de éxito $\pi_i$. Y se tiene que
$$
p_1(x_i) = \pi_i = \mbox{logit}^{-1}(x_i^\prime\beta).
$$


**Recordemos las interpretaciones de los coeficientes:**

1. Evaluar en o alrededor de la media: $$\mbox{logit}^{-1}(\beta_0+\beta_j\cdot \bar{x}_j).$$

2. Interpretar como un cambio en la probabilidad ante un cambio unitario en $x$ alrededor de la media: $$\mbox{logit}^{-1}(\beta_0+\beta_j\cdot \bar{x}_j) - \mbox{logit}^{-1}(\beta_0+\beta_j\cdot (\bar{x}_j-1)).$$

3. Calcular la derivada de la curva logística en la media: $$\dfrac{\beta_j\, e^{\beta_0+\beta_j \bar{x}_j}}{(1 + e^{\beta_0 +\beta_j \bar{x}_j})^2}.$$

4. Dividir entre 4: $$\dfrac{\beta_j}{4}.$$ Se interpreta como la diferencia en la probabilidad ante un cambio unitario en $x_j$ alrededor de la media (aproximadamente).

5. Calcular el cociente de momios: $$\mbox{log}\left[\dfrac{P(y_i=1|x)}{P(y_i=0|x)} \right] = \alpha + \beta x.$$ Sumar 1 a la variable $x$ es equivalente a sumar $\beta$ en ambos lados de la ecuación. Exponenciando nuevamente ambos lados, el cociente de momios se multiplica por $e^\beta$.

<br>

**Estimación de los parámetros $\beta$:**

Se utiliza descenso en gradiente para estimar los coeficientes $\beta_j$ minimizando la devianza:
$$
D(\beta) = -2\sum_{i=1}^N \log(p_{y^{(i)}} (x^{(i)})).
$$ 

**Responde las siguientes preguntas:**

![](figuras/manicule2.jpg) 
<div class="centered">
<p class="espacio">
</p>
Supongamos que se ajustan los coeficientes de un modelo lineal logístico y una _nueva observación_ $x$ es tal que su predicción es $h(x^\prime \beta)=0.7$. Esto significa que (selecciona una o más):

(a) Nuestra estimación de $P(y=0|x;\beta)$ es 0.7.

(b) Nuestra estimación de $P(y=1|x;\beta)$ es 0.7.

(c) Nuestra estimación de $P(y=0|x;\beta)$ es 0.3.

(d) Nuestra estimación de $P(y=1|x;\beta)$ es 0.3.

<p class="espacio3">
</p>
</div>
<br>

![](figuras/manicule2.jpg) 
<div class="centered">
<p class="espacio">
</p>
Supongamos que se ajusta un modelo logístico $p_1(x_i)=h(\beta_0+\beta_1x_1^{(i)}+\beta_2 x_2^{(i)})$. Supongamos que $\beta_0=6, \;\beta_1=-1,\; \beta_2=0$. ¿Cuál de las siguientes figuras puede servir como una regla de decisión para este modelo?

(a) 

&nbsp; ![](figuras/a.png){width=20%}

(b) 

&nbsp; ![](figuras/b.png){width=20%}

(c) 

&nbsp; ![](figuras/c.png){width=20%}

(d) 

&nbsp; ![](figuras/d.png){width=20%}

<p class="espacio3">
</p>
</div>

<br>

---

<br>

## Regresión logística con interacciones

Recordemos el modelo de pozos en Bangladesh:


```r
wells <- read_csv("datos/wells.csv")
wells <- wells %>% mutate(dist_100 = dist/100)
fit.2 <- glm(switch ~ dist_100, data = wells, family=binomial(link="logit"))
fit.2
```

Posteriormente añadimos una segunda variable:


```r
fit.3 <- glm(switch ~ dist_100 + arsenic, data = wells, family=binomial(link="logit"))
fit.3
#> 
#> Call:  glm(formula = switch ~ dist_100 + arsenic, family = binomial(link = "logit"), 
#>     data = wells)
#> 
#> Coefficients:
#> (Intercept)     dist_100      arsenic  
#>     0.00275     -0.89664      0.46077  
#> 
#> Degrees of Freedom: 3019 Total (i.e. Null);  3017 Residual
#> Null Deviance:	    4120 
#> Residual Deviance: 3930 	AIC: 3940
```

Añadimos una interacción entre estos dos términos:


```r
fit.4 <- glm(switch ~ dist_100 + arsenic + dist_100:arsenic, 
             data = wells,
             family=binomial(link="logit"))
fit.4
#> 
#> Call:  glm(formula = switch ~ dist_100 + arsenic + dist_100:arsenic, 
#>     family = binomial(link = "logit"), data = wells)
#> 
#> Coefficients:
#>      (Intercept)          dist_100           arsenic  dist_100:arsenic  
#>           -0.148            -0.577             0.556            -0.179  
#> 
#> Degrees of Freedom: 3019 Total (i.e. Null);  3016 Residual
#> Null Deviance:	    4120 
#> Residual Deviance: 3930 	AIC: 3940
```

Para entender los números en la tabla, usamos los siguientes trucos:

* Evaluar predicciones e interacciones en la media de los datos, que tienen valores promedio de 0.48 para distancia y 1.66 para arsénico (es decir, una distancia media de 48 metros al pozo seguro más cercano, y un nivel promedio de arsénico de 1.66 entre los pozos inseguros).

* Dividir entre 4 para obtener diferencias predictivas aproximadas en la escala de probabilidad.

Intrepretamos los coeficientes:

1. El término constante no tiene interpretación: $\mbox{logit}^{-1}(-0.15) = 0.47$ es la probabilidad estimada de cambio, si la distancia al pozo seguro más cercano es $0$ y el nivel de arsénico del pozo actual es 0. Esto es imposible porque la distribución de arsénico en pozos inseguros comienza en $0.5$.

    En cambio, podemos evaluar la predicción en los valores promedio de $\mbox{dist_100} = 0.48$ y $\mbox{arsénico} = 1.66$,  la probabilidad de cambiar de pozo es $\mbox{logit}^1(-0.15 - 0.58 \cdot 0.48 + 0.56 \cdot 1.66 - 0.18 \cdot 0.48 \cdot 1.66) = 0.59$.

2. Coeficiente de distancia: esto corresponde a la comparación de dos pozos que difieren en 1 en dist_100, si el nivel de arsénico es 0 para ambos pozos. Una vez más, no debemos tratar de interpretarlo.

    En cambio, podemos ver el valor promedio, arsénico = 1.66, donde la distancia tiene un coeficiente de $-0.58 - 0.18 · 1.66 = -0.88$ en la escala logit. Para interpretar esto rápidamente en la escala de probabilidad, lo dividimos por 4: $-0.88 / 4 = -0.22$. Por lo tanto, al nivel medio de arsénico en los datos, a cada 100 metros de distancia le corresponden a una diferencia negativa aproximada del 22% en la probabilidad de cambio.

3. Coeficiente para arsénico: esto equivale a comparar dos pozos que difieren en 1 en arsénico, si la distancia al pozo seguro más cercano es 0 para ambos.

    Evaluamos la comparación en el valor promedio para la distancia, $\mbox{dist_100} = 0.48$, donde el arsénico tiene un coeficiente de $0.56 - 0.18 · 0.48 = 0.47$ en la escala logit. Para interpretar esto rápidamente en la escala de probabilidad, _lo dividimos entre $4$_: $0.47 / 4 = 0.12$. Por lo tanto, en el nivel medio de distancia en los datos, cada unidad adicional de arsénico corresponde a una diferencia positiva aproximada del 12% en la probabilidad de cambio.

4. _Coeficiente para el término de interacción_: se puede interpretar de dos maneras:
    + por cada unidad adicional de arsénico, el valor $-0.18$ se agrega al coeficiente de distancia. Ya hemos visto que el coeficiente de distancia es $-0.88$ en el nivel promedio de arsénico, por lo que podemos entender la interacción diciendo que la importancia de la distancia como predictor aumenta para los hogares con niveles más altos de arsénico.
    + por cada $100$ metros adicionales de distancia al pozo más cercano, se agrega el valor $-0.18$ al coeficiente de arsénico. Ya hemos visto que el coeficiente de distancia es $0.47$ a la distancia promedio al pozo seguro más cercano, y así podemos entender la interacción diciendo que la importancia del arsénico como predictor disminuye para los hogares que están más lejos de los pozos seguros existentes. 
    
#### Centrando las variables {-}

Como se discutió anteriormente en el contexto de la regresión lineal, antes de ajustar las interacciones tiene sentido centrar las variables de entrada para que podamos interpretar los coeficientes más fácilmente. Las entradas centradas son:


```r
wells <- wells %>% 
  mutate(dist_100_c = dist_100 - mean(dist_100),
         arsenic_c = arsenic - mean(arsenic))
```

Podemos reajustar el modelo usando las variables de entrada centradas, lo que hará que los coeficientes sean mucho más fáciles de interpretar:


```r
fit.5 <- glm(switch ~ dist_100_c + arsenic_c + dist_100_c:arsenic_c, data = wells,
  family=binomial(link="logit"))
fit.5
#> 
#> Call:  glm(formula = switch ~ dist_100_c + arsenic_c + dist_100_c:arsenic_c, 
#>     family = binomial(link = "logit"), data = wells)
#> 
#> Coefficients:
#>          (Intercept)            dist_100_c             arsenic_c  
#>                0.351                -0.874                 0.470  
#> dist_100_c:arsenic_c  
#>               -0.179  
#> 
#> Degrees of Freedom: 3019 Total (i.e. Null);  3016 Residual
#> Null Deviance:	    4120 
#> Residual Deviance: 3930 	AIC: 3940
```

Centramos las entradas, no los predictores. Por lo tanto, no centramos la interacción ($\mbox{dist_100} * \mbox{arsénico}$); más bien, incluimos la interacción de las dos variables de entrada centradas. 


Interpretamos los coeficientes en esta nueva escala:

1. Término constante: $\mbox{logit}^{-1}(0.35) = 0.59$ es la probabilidad estimada cambiar de pozo, si $\mbox{dist_100_c} = \mbox{arsenic_c} = 0$, es decir, en las medias de la distancia al pozo seguro más cercano y el nivel de arsénico. (Obtuvimos este mismo cálculo, pero con más esfuerzo, con nuestro modelo anterior con datos no centrados).

2. Coeficiente de distancia: éste es el coeficiente de distancia (en la escala logit) si el nivel de arsénico está en su valor promedio. Para interpretar esto rápidamente en la escala de probabilidad, lo dividimos por 4: $-0.88 / 4 = -0.22$. Por lo tanto, al nivel medio de arsénico en los datos, cada 100 metros de distancia corresponde a una diferencia negativa aproximada del 22% en la probabilidad de cambio.

3. Coeficiente para arsénico: este es el coeficiente para el nivel de arsénico si la distancia al pozo seguro más cercano está en su valor promedio. Para interpretar esto rápidamente en la escala de probabilidad, lo dividimos por 4: $0.47 / 4 = 0.12$. Por lo tanto, en el nivel medio de distancia en los datos, cada unidad adicional de arsénico corresponde a una diferencia positiva aproximada del $12\%$ en la probabilidad de cambio.

4. Coeficiente para el término de interacción: esto no se modifica al centrarse y tiene la misma interpretación que antes.

Las predicciones para nuevas observaciones no se modifican. Centrar los predictores cambia las interpretaciones de los coeficientes pero no cambia el modelo subyacente.

![](figuras/manicule.jpg) Estima el error estándar del coeficiente de interacción usando la técnica de _bootsrap_. ¿Es significativo dicho coeficiente?

<p class="espacio">
</p>
<br>


```r
summary(fit.5)
#> 
#> Call:
#> glm(formula = switch ~ dist_100_c + arsenic_c + dist_100_c:arsenic_c, 
#>     family = binomial(link = "logit"), data = wells)
#> 
#> Deviance Residuals: 
#>    Min      1Q  Median      3Q     Max  
#>  -2.78   -1.20    0.77    1.08    1.85  
#> 
#> Coefficients:
#>                      Estimate Std. Error z value Pr(>|z|)    
#> (Intercept)            0.3511     0.0399    8.81   <2e-16 ***
#> dist_100_c            -0.8737     0.1048   -8.34   <2e-16 ***
#> arsenic_c              0.4695     0.0421   11.16   <2e-16 ***
#> dist_100_c:arsenic_c  -0.1789     0.1023   -1.75     0.08 .  
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#> 
#> (Dispersion parameter for binomial family taken to be 1)
#> 
#>     Null deviance: 4118.1  on 3019  degrees of freedom
#> Residual deviance: 3927.6  on 3016  degrees of freedom
#> AIC: 3936
#> 
#> Number of Fisher Scoring iterations: 4
```

## Gráficas del modelo con interacciones

La forma más clara de visualizar el modelo de interacción es graficar la función de la curva de regresión para cada posible escenario.


```r
invlogit <- function(x){
  exp(x)/(1+exp(x))
}
ggplot(wells, aes(x = dist_100, y = switch)) +
  geom_jitter(width = 0.308, height = 0.1, size = 0.1) +
  stat_function(fun = function(x){
    invlogit(fit.5$coef[1] + fit.5$coef[2]*x + 0.5 + fit.5$coef[4]*0.5*x)}, xlim = c(-0.3,3.5)) +
  stat_function(fun = function(x){
    invlogit(fit.5$coef[1] + fit.5$coef[2]*x + 1 + fit.5$coef[4]*1*x)}, xlim = c(-0.3,3.5)) +
  annotate("text", x = 0.50, y = 0.45, label = "As=0.5", size = 4) +
  annotate("text", x = 0.75, y = 0.65, label = "As=1.0", size = 4)
```

<img src="08-logit-3_files/figure-html/unnamed-chunk-17-1.png" width="70%" style="display: block; margin: auto;" />


```r
ggplot(wells, aes(x = arsenic, y = switch)) +
  geom_jitter(width = 0.308, height = 0.1, size = 0.1) +
  stat_function(fun = function(x){
    invlogit(fit.5$coef[1] + 0 + fit.5$coef[3]*x + fit.5$coef[4]*0*x)}, xlim = c(-0.3,10)) +
  stat_function(fun = function(x){
    invlogit(fit.5$coef[1] + fit.5$coef[2]*0.5 + fit.5$coef[3]*x + fit.5$coef[4]*0.5*x)}, xlim = c(-0.3,10)) +
  annotate("text", x = 0.7, y = 0.80, label = "dist=0", size = 4) +
  annotate("text", x = 2.0, y = 0.65, label = "dist=50", size = 4)
```

<img src="08-logit-3_files/figure-html/unnamed-chunk-18-1.png" width="70%" style="display: block; margin: auto;" />

La interacción no es grande en el rango de la mayoría de los datos. En la gráfica de arriba vemos que las líneas se empiezan a juntar a los $300$ metros de distancia. 

Las diferencias en el cambio asociadas con las diferencias en el nivel de arsénico son grandes si se está cerca de un pozo seguro, pero el efecto disminuye si se está lejos de un pozo seguro. Esta interacción tiene algún sentido; sin embargo, hay cierta incertidumbre en el tamaño de la interacción (de la tabla de regresión anterior, una estimación de $-0.18$ con un error estándar de $0.10$). Solo hay unos pocos datos en el área donde la interacción hace alguna diferencia.

## Agregar más predictores

¿Son más propensos los usuarios a cambiar de pozo si pertenecen a alguna asociación en su comunidad o si tienen mayor educación? Para ver, agregamos dos entradas:

* assoc = 1 si un miembro del hogar pertenece a alguna organización comunitaria

* educ = años de educación del usuario del pozo.

En realidad, trabajamos con $\mbox{educ4} = \mbox{educ} / 4$, por las razones habituales de hacer que su coeficiente de regresión sea más interpretable: ahora representa la diferencia predictiva de agregar cuatro años de educación.


```r
wells <- wells %>% mutate(educ4 = educ / 4)
fit.6 <- glm(switch ~ dist_100_c + 
               arsenic_c + dist_100_c:arsenic_c +
               assoc + educ4, 
             data = wells,
             family=binomial(link="logit"))
fit.6
#> 
#> Call:  glm(formula = switch ~ dist_100_c + arsenic_c + dist_100_c:arsenic_c + 
#>     assoc + educ4, family = binomial(link = "logit"), data = wells)
#> 
#> Coefficients:
#>          (Intercept)            dist_100_c             arsenic_c  
#>                0.203                -0.875                 0.475  
#>                assoc                 educ4  dist_100_c:arsenic_c  
#>               -0.123                 0.168                -0.161  
#> 
#> Degrees of Freedom: 3019 Total (i.e. Null);  3014 Residual
#> Null Deviance:	    4120 
#> Residual Deviance: 3910 	AIC: 3920
```

Nota:

* Para los hogares con pozos inseguros, pertenecer a una asociación comunitaria sorprendentemente no es predictivo de cambio de pozo, después de controlar los otros factores en el modelo. 

* Sin embargo, las personas con educación superior tienen más probabilidades de cambiar: la diferencia estimada bruta es $0.17 / 4 = 0.04$, o una diferencia positiva de $4\%$ en la probabilidad de cambio cuando se comparan hogares que difieren en 4 años de educación.


El coeficiente para la educación tiene sentido y es estadísticamente significativo, por lo que lo mantenemos en el modelo. El coeficiente de asociación comunitaria no tiene sentido y no es estadísticamente significativo, por lo que lo eliminamos.



```r
fit.7 <- glm (switch ~ dist_100_c + arsenic_c + dist_100_c:arsenic_c + educ4,
              data = wells,
              family = binomial(link="logit"))
fit.7
#> 
#> Call:  glm(formula = switch ~ dist_100_c + arsenic_c + dist_100_c:arsenic_c + 
#>     educ4, family = binomial(link = "logit"), data = wells)
#> 
#> Coefficients:
#>          (Intercept)            dist_100_c             arsenic_c  
#>                0.148                -0.875                 0.477  
#>                educ4  dist_100_c:arsenic_c  
#>                0.169                -0.163  
#> 
#> Degrees of Freedom: 3019 Total (i.e. Null);  3015 Residual
#> Null Deviance:	    4120 
#> Residual Deviance: 3910 	AIC: 3920
```

Añadimos otras interacciones (centrando la variable de educación):


```r
wells <- wells %>% mutate(educ4_c = educ4 - mean(educ4))
fit.8 <- glm(switch ~ dist_100_c + arsenic_c + educ4_c + dist_100_c:arsenic_c +
               dist_100_c:educ4_c + arsenic_c:educ4_c, 
             data = wells,
             family = binomial(link="logit"))
summary(fit.8)
#> 
#> Call:
#> glm(formula = switch ~ dist_100_c + arsenic_c + educ4_c + dist_100_c:arsenic_c + 
#>     dist_100_c:educ4_c + arsenic_c:educ4_c, family = binomial(link = "logit"), 
#>     data = wells)
#> 
#> Deviance Residuals: 
#>    Min      1Q  Median      3Q     Max  
#> -2.571  -1.196   0.731   1.072   1.871  
#> 
#> Coefficients:
#>                      Estimate Std. Error z value Pr(>|z|)    
#> (Intercept)            0.3563     0.0403    8.84  < 2e-16 ***
#> dist_100_c            -0.9029     0.1073   -8.41  < 2e-16 ***
#> arsenic_c              0.4950     0.0431   11.50  < 2e-16 ***
#> educ4_c                0.1850     0.0392    4.72  2.4e-06 ***
#> dist_100_c:arsenic_c  -0.1177     0.1035   -1.14   0.2557    
#> dist_100_c:educ4_c     0.3227     0.1066    3.03   0.0025 ** 
#> arsenic_c:educ4_c      0.0722     0.0439    1.65   0.0996 .  
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#> 
#> (Dispersion parameter for binomial family taken to be 1)
#> 
#>     Null deviance: 4118.1  on 3019  degrees of freedom
#> Residual deviance: 3891.7  on 3013  degrees of freedom
#> AIC: 3906
#> 
#> Number of Fisher Scoring iterations: 4
```

Podemos interpretar estas nuevas interacciones entendiendo cómo la educación modifica la diferencia predictiva correspondiente a la distancia y el arsénico.

* _Interacción de distancia y educación_: una diferencia de 4 años de educación corresponde a una diferencia de $0.32$ en el coeficiente para $\mbox{dist_100}$. Como ya hemos visto, $\mbox{dist_100}$ tiene un coeficiente negativo en promedio; por lo tanto, los cambios positivos en la educación reducen la asociación negativa de la distancia. Esto tiene sentido: las personas con más educación probablemente tengan otros recursos, por lo que andar una distancia extra para obtener agua no es una carga tan pesada.

* _Interacción de arsénico y educación_: una diferencia de 4 años de educación corresponde a una diferencia de $0.07$ en el coeficiente de arsénico. Como ya hemos visto, el arsénico tiene un coeficiente positivo en promedio; por lo tanto, aumentar la educación aumenta la asociación positiva del arsénico. Esto tiene sentido: las personas con más educación podrían estar más informadas sobre los riesgos del arsénico y, por lo tanto, ser más sensibles al aumento de los niveles de arsénico (o, a la inversa, tener menos prisa para cambiar de pozos con niveles de arsénico relativamente bajos).


**Estandarizar los predictores**

Deberíamos considerar seriamente la posibilidad de estandarizar todos los predictores como una opción predeterminada para ajustar modelos con interacciones. Las dificultades con $\mbox{dist_100}$ y $\mbox{educ4}$ en este ejemplo sugieren que la estandarización, restar la media de cada una de las variables de entrada y dividir entre 2 desviaciones estándar.


## Evaluación de modelos de regresión logística

Podemos definir residuales en regresión logística como
$$
\mbox{residual}_i = y_i − E(y_i|X_i) = y_i − \mbox{logit}^{-1}(X_i\beta).
$$
Los datos $y_i$ son discretos y también los residuales. Por ejemplo, si $\mbox{logit}^{-1} (X_i\beta) = 0.7$, entonces $\mbox{residual}_i = -0.7$ o $+0.3$, dependiendo de si $y_i = 0$ o $1$. 

Graficamos los residuales de la regresión logística: 


```r
fit.8 <- glm(switch ~ dist_100_c + arsenic_c + educ4_c + dist_100_c:arsenic_c +
               dist_100_c:educ4_c + arsenic_c:educ4_c,
             data = wells,
             family=binomial(link="logit"))

# Probabilidades de predicción
wells$pred.8 <- fit.8$fitted.values

ggplot(wells, aes(x=pred.8, y=switch-pred.8)) +
  geom_point(size=1) +
  geom_abline(slope = 0, intercept = 0) +
  xlab("P(switch) de predicción") +
  ylab("Observado - estimado")
```

<img src="08-logit-3_files/figure-html/unnamed-chunk-22-1.png" width="70%" style="display: block; margin: auto;" />

Vemos que esto no es útil. En la gráfica se ve un patrón fuerte en los residuales debido a que las observaciones de $y_i$ son _discretas_. Esto nos sugiere hacer una gráfica de residuales agrupados.


Para calcular los residuales agrupados dividimos los datos en clases (cubetas) en función de sus valores ajustados. Luego graficamos el residual promedio contra el valor promedio ajustado para cada cubeta. 

Calculamos la agrupación de los residuales con la siguiente función:


```r
binned_residuals <- function(x, y, nclass=sqrt(length(x))){
  breaks.index <- floor(length(x)*(1:(nclass-1))/nclass)
  breaks <- c (-Inf, sort(x)[breaks.index], Inf)
  output <- NULL
  xbreaks <- NULL
  x.binned <- as.numeric (cut (x, breaks))
  for (i in 1:nclass){
    items <- (1:length(x))[x.binned==i]
    x.range <- range(x[items])
    xbar <- mean(x[items])
    ybar <- mean(y[items])
    n <- length(items)
    sdev <- sd(y[items])
    output <- rbind(output, c(xbar, ybar, n, x.range, 2*sdev/sqrt(n)))
  }
  colnames(output) <- c ("xbar", "ybar", "n", "x.lo", "x.hi", "2se")
  return (list(binned=output, xbreaks=xbreaks))
}
```

![](figuras/manicule.jpg) La función *binned_residuals* recibe como entrada un vector $x$. ¿Es significativo dicho coeficiente?

<p class="espacio">
</p>
<br>

Veamos la gráfica:


```r
br.8 <- binned_residuals(wells$pred.8, wells$switch-wells$pred.8, nclass=40) %>% 
  .$binned %>%
  as.data.frame()

ggplot(br.8, aes(xbar, ybar)) +
  geom_point() +
  geom_line(aes(x=xbar, y=`2se`), color="grey60") +
  geom_line(aes(x=xbar, y=-`2se`), color="grey60") +
  geom_abline(intercept = 0, slope = 0) +
  xlab("P(switch) de predicción") +
  ylab("Residual promedio")
```

<img src="08-logit-3_files/figure-html/unnamed-chunk-24-1.png" width="70%" style="display: block; margin: auto;" />

<p class="espacio3">
</p>

Lo que observamos es los datos divididos en 40 cubetas de igual tamaño. Las líneas de color gris se calculan como 
$$
\displaystyle{2\sqrt{\frac{p(1 - p)}{n}}},
$$
donde $n$ es el número de puntos por cubeta. En este caso, $n = 3020/40 = 75$ en este caso) indican 

Si consideramos $\pm 2$ errores estándar esperamos que caigan adentro de estas bandas aproximadamente el 95% de los residuales agrupados (si el modelo fuera realmente verdadero).

---

<br>

### Gráficas de residuales agrupados vs predictores

Podemos estudiar los residuales graficándolos contra algunos predictores.

Graficamos los residuales contra la distancia al pozo seguro más cercano:


```r
br.8.dist <- binned_residuals(wells$dist_100, wells$switch-wells$pred.8, nclass=40) %>% 
  .$binned %>%
  as.data.frame()
ggplot(br.8.dist, aes(xbar, ybar)) +
  geom_point() +
  geom_line(aes(x=xbar, y=`2se`), color="grey60") +
  geom_line(aes(x=xbar, y=-`2se`), color="grey60") +
  geom_abline(intercept = 0, slope = 0) +
  xlab("P(switch) de predicción") +
  ylab("Distancia al pozo seguro más cercano")
```

<img src="08-logit-3_files/figure-html/unnamed-chunk-25-1.png" width="70%" style="display: block; margin: auto;" />

No observamos algún patrón en los residuales de la gráfica anterior, lo cual es consistente con el modelo.

Vemos ahora la gráfica con arsénico:


```r
br.8.ars <- binned_residuals(wells$arsenic, wells$switch-wells$pred.8, nclass=40) %>% 
  .$binned %>%
  as.data.frame()
ggplot(br.8.ars, aes(xbar, ybar)) +
  geom_point() +
  geom_line(aes(x=xbar, y=`2se`), color="grey60") +
  geom_line(aes(x=xbar, y=-`2se`), color="grey60") +
  geom_smooth(method = 'loess', se=F, color="red", size=0.5) +
  geom_abline(intercept = 0, slope = 0) +
  xlab("P(switch) de predicción") +
  ylab("Arsénico")
```

<img src="08-logit-3_files/figure-html/unnamed-chunk-26-1.png" width="70%" style="display: block; margin: auto;" />

Esta gráfica sí muestra un patrón en los residuales. Tiene un residual negativo extremo. Además podemos decir que:

* las personas en los pozos para las primeras 3 cubetas tienen probabilidad de cambio promedio de:


```r
personas_cub3 <- wells %>% filter(arsenic <= 0.59)
sum(personas_cub3$switch)/nrow(personas_cub3)
#> [1] 0.308
```

* el modelo predice que la probabilidad de cambio de estas personas en las primras tres cubetas es en promedio:


```r
mean(personas_cub3$pred.8)
#> [1] 0.485
```

Esto quiere decir que la probabilidad de que realmente cambien de pozo es aproximadamente 20% menos que la que predice el modelo. 

* Observamos un patrón en los residuales: los residuales positivos (ej promedio) están en la mitad del rango de arsénico, y los residuales están en los extremos.

<p class="espacio3">
</p>

### Transformaciones

Ahora consideramos transformar la variable de arsénico: vemos un patrón en los residuales en el cual estos primero aumentan y luego disminuyen. 

Para solucionar esto hay algunas opciones:

* usar una __transformación logarítmica__.

* agregar un término cuadrático al término lineal.

En este caso como la variable de arsénico es no negativa es un poco más práctico utilizar la transformación de logaritmo.


```r
wells <- wells %>% mutate(arsenic_log = log(arsenic),
                          arsenic_log_c = arsenic_log - mean(arsenic_log))
fit.9 <- glm(switch ~ dist_100_c + arsenic_log_c + educ4_c +
               dist_100_c:arsenic_log_c + dist_100_c:educ4_c + arsenic_log_c:educ4_c,
             data = wells,
             family=binomial(link="logit"))
summary(fit.9)
#> 
#> Call:
#> glm(formula = switch ~ dist_100_c + arsenic_log_c + educ4_c + 
#>     dist_100_c:arsenic_log_c + dist_100_c:educ4_c + arsenic_log_c:educ4_c, 
#>     family = binomial(link = "logit"), data = wells)
#> 
#> Deviance Residuals: 
#>    Min      1Q  Median      3Q     Max  
#> -2.103  -1.162   0.718   1.040   1.923  
#> 
#> Coefficients:
#>                          Estimate Std. Error z value Pr(>|z|)    
#> (Intercept)                0.3452     0.0405    8.53  < 2e-16 ***
#> dist_100_c                -0.9796     0.1112   -8.81  < 2e-16 ***
#> arsenic_log_c              0.9036     0.0695   13.00  < 2e-16 ***
#> educ4_c                    0.1785     0.0390    4.58  4.7e-06 ***
#> dist_100_c:arsenic_log_c  -0.1567     0.1851   -0.85   0.3974    
#> dist_100_c:educ4_c         0.3384     0.1078    3.14   0.0017 ** 
#> arsenic_log_c:educ4_c      0.0601     0.0703    0.85   0.3926    
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#> 
#> (Dispersion parameter for binomial family taken to be 1)
#> 
#>     Null deviance: 4118.1  on 3019  degrees of freedom
#> Residual deviance: 3863.1  on 3013  degrees of freedom
#> AIC: 3877
#> 
#> Number of Fisher Scoring iterations: 4
```

Esto da resultados similares al modelo anterior, los signos de las interacciones son los mismos y los signos de los efectos principales también son los mismos.

Volvemos a hacer la gráfica de niveles de arsénico vs residuales:


```r
wells$pred.9 <- fit.9$fitted.values
br.fit.9 <- binned_residuals(wells$arsenic, wells$switch-wells$pred.9, nclass=40) %>% 
  .$binned %>%
  as.data.frame()
ggplot(br.fit.9, aes(xbar, ybar)) +
  geom_point() +
  geom_line(aes(x=xbar, y=`2se`), color="grey60") +
  geom_line(aes(x=xbar, y=-`2se`), color="grey60") +
  geom_smooth(method = 'loess', se=F, color="red", size=0.5) +
  geom_abline(intercept = 0, slope = 0) +
  xlab("Residual promedio P(switch)") +
  ylab("Arsénico")
```

<img src="08-logit-3_files/figure-html/unnamed-chunk-30-1.png" width="70%" style="display: block; margin: auto;" />

Los residuales se ven mucho mejor, aunque para niveles bajos de arsénico aún hay muchos residuales negativos: los usuarios de pozos con niveles de arsénico justo por encima de $0.50$ tienen menos probabilidad de cambiarse que la que predice el modelo.

Posibles explicaciones:

+ psicológicamente, las mediciones justo por encima de $0.50$ podrían parecer no muy graves

+ por error de medición, tal vez algunos de los pozos con $0.51$ o $0.52$ se midieron antes o después y de encontrar niveles de arsénico por debajo de $0.5$


### Tasa de error y comparación contra el modelo nulo

La __tasa de error__ se define como la proporción de casos para los cuáles la predicción de $y_i$ a partir de la probabilidad estimada
$$
\pi_i=p_1(x_i)=\mbox{logit}^{-1}(X_i\beta)
$$
es _incorrecta_.

Para hacer la predicción para cada $y_i$ es necesario definir un **punto de corte**, en principio se utiliza el $0.5$ de la forma que la predicción de $y_i$, denotada por $\hat{y}_i$, es
$$
\hat{y}_{i} = \left\{ \begin{array}{cl}
1 & \text{si }\;\mbox{logit}^{-1}(X_i\beta) > 0.5,\\
0 & \text{en otro caso.}
\end{array}\right.
$$

Por lo tanto, calculamos la tasa de error para el ejemplo de los pozos:


```r
(error_rate <- mean((wells$pred.9>0.5 & wells$switch==0) | (wells$pred.9<=0.5 & wells$switch==1)))
#> [1] 0.365
```

\BeginKnitrBlock{nota}<div class="nota">Observaciones:
  
* La tasa de error siempre debe ser menor que $1/2$.

* Si la tasa de error fuera mayor o igual a $1/2$, entonces poniendo todas las $\beta^\prime\mbox{s}$ igual a cero obtendríamos un mejor modelo.

* El **modelo nulo** se define como el modelo que asigna la misma probabilidad $p$ a toda $y_i$, y dicha probabilidad es $$p = \dfrac{1}{n}\sum_{i=1}^N{y_i}.$$</div>\EndKnitrBlock{nota}

<p class="espacio3">
</p>

![](figuras/manicule2.jpg) 
<div class="centered">
<p class="espacio">
</p>

¿Cuál o cuáles de las siguientes afirmaciones son ciertas?

(a) La tasa de error del modelo nulo es igual a $p$.

(b) El modelo nulo es aquel en el cual todas las observaciones son equiprobables.

(c) El modelo nulo es simplemente regresión logística con sólo un término constante.

(d) La tasa de error del modelo nulo es igual a $1-p$.

<p class="espacio3">
</p>
</div>
<br>

Por ejemplo, en el modelo de los pozos la tasa de error del modelo nulo es:


```r
mean(1-wells$switch)
#> [1] 0.425
```

Es decir, $58\%$ de los encuestados cambiaron de pozo, pero $42\%$ no cambiaron de pozo.

<p class="espacio3">
</p>

\BeginKnitrBlock{information}<div class="information">**Interpretación del modelo nulo:** 
  
  + el modelo sin predictores le da a cada persona un $58\%$ de posibilidad de cambio (que corresponde a una predicción puntual de cambiar para cada persona), y

  + esta predicción será incorrecta el $42\%$ de las veces.</div>\EndKnitrBlock{information}

<p class="espacio3">
</p>

\BeginKnitrBlock{nota}<div class="nota">Nota:

<p class="espacio">
</p> 

* Utilizamos la **devianza** para evaluar el ajuste de un modelo porque la tasa de error no es un resumen perfecto del _desajuste_ del modelo. La razón de esto es que la tasa de error no puede distinguir entre predicciones de $0.6$ y $0.9$, por ejemplo, porque únicamente toma en cuenta predicciones de $y_i$'s.

* Es importante poder predecir $y_i$'s pero generalmente es más útil trabajar con las probabilidades porque en estas subyace la incertidumbre de la predicción.

* La tasa de error se utiliza a menudo porque es fácil de interpretar y en la práctica puede llegar a ser muy útil.

* Una tasa de error igual a la tasa de error del modelo nulo es terrible, y la mejor tasa de error posible es cero.

* Una tasa de error alta (cercana a la del modelo nulo pero menor) no significa que el modelo no sea útil. La interpretación del modelo puede aportar a explicar el fenómeno de estudio.</div>\EndKnitrBlock{nota}

<p class="espacio3">
</p>

La razón por la cual la tasa de error del modelo de pozos es alta se resume en los siguientes puntos:

* La mayoría de los datos están alrededor de las medias de los predictores (la distancia menor a 100 m y arsénico en  0.5 y 1).

* Por el punto anterior, para la mayoría de los datos la probabilidad de cambio $P(\mbox{switch})=0.58$ funciona bien, que es simplementa la media en los datos.

* El modelo da información sobre lo que está pasando en los extremos, pero relativamente hay muy pocos datos, por lo que la precisión predictiva general del modelo no es muy alta.

---

<br>

## Diferencias predictivas promedio en la escala de probabilidad

Recordemos:

1. Las regresiones logísticas son inherentemente más difíciles que las regresiones lineales para interpretar.

2. La regresión logística es no lineal en la escala de probabilidad, es decir, a una diferencia unitaria en $x$ no le corresponde una diferencia constante en $P(y_i=1)$.

3. Como resultado de esto, los coeficientes de regresión logística no se pueden interpretar directamente en la escala de probabilidad.

<p class="espacio3">
</p>

Se puede calcular la _diferencia predictiva promedio_ como función de los valores de entrada de los predictores para luego dar una diferencia _promedio_ en $P(y=1)$ correspondiente a una diferencia en cada una de las variables de entrada.

Comenzamos utilizando el siguiente modelo sin interacciones para hacer más simple la explicación:


```r
fit.10 <- glm(switch ~ dist_100 + arsenic + educ4,
               data = wells,
               family=binomial(link="logit"))
summary(fit.10)
#> 
#> Call:
#> glm(formula = switch ~ dist_100 + arsenic + educ4, family = binomial(link = "logit"), 
#>     data = wells)
#> 
#> Deviance Residuals: 
#>    Min      1Q  Median      3Q     Max  
#> -2.577  -1.197   0.755   1.063   1.699  
#> 
#> Coefficients:
#>             Estimate Std. Error z value Pr(>|z|)    
#> (Intercept)  -0.2139     0.0931   -2.30    0.022 *  
#> dist_100     -0.8956     0.1046   -8.56  < 2e-16 ***
#> arsenic       0.4684     0.0416   11.26  < 2e-16 ***
#> educ4         0.1713     0.0383    4.47  7.7e-06 ***
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#> 
#> (Dispersion parameter for binomial family taken to be 1)
#> 
#>     Null deviance: 4118.1  on 3019  degrees of freedom
#> Residual deviance: 3910.4  on 3016  degrees of freedom
#> AIC: 3918
#> 
#> Number of Fisher Scoring iterations: 4
```

<p class="espacio3">
</p>

**Ejemplo: Diferencia predictiva promedio en probabilidad de cambio, comparando hogares que están a 100 metros o menos de un pozo seguro más cercano.**

<p class="espacio3">
</p>

Comparemos dos hogares:

* uno con $\mbox{dist_100} = 0$, y 

* uno con $\mbox{dist_100} = 1$, 

pero ambos con los mismos valores en las otras variables de entrada: arsénico y educ4.

La _diferencia predictiva_ en probabilidad de cambiar de pozo entre los dos hogares:
$$
\begin{eqnarray*}
\delta(\mbox{arsenic}, \mbox{educ4}) = \mbox{logit}^{−1}(−0.21 − 0.90 \cdot 1 + 0.47 \cdot \mbox{arsenic} + 0.17 \cdot \mbox{educ4}) &−&\\ \mbox{logit}^{−1}(−0.21 − 0.90 \cdot 0 + 0.47 \cdot \mbox{arsenic} + 0.17 \cdot \mbox{educ4}).
\end{eqnarray*}
$$
Escribimos $\delta$ como una función de arsénico y educ4 para enfatizar que depende de los niveles de estas otras variables.


Promeiamos las diferencias predictivas sobre los $n$ hogares en los datos para obtener:
$$
\mbox{diferencia predictiva promedio} = \dfrac{1}{n}\sum_{i=1}^n{\delta(\mbox{arsenic}_i, \mbox{educ4}_i)}
$$

Hacemos el cálculo:


```r
b <- coef(fit.10)
hi <- 1
lo <- 0
delta <- invlogit (b[1] + b[2]*hi + b[3]*wells$arsenic + b[4]*wells$educ4) -
         invlogit (b[1] + b[2]*lo + b[3]*wells$arsenic + b[4]*wells$educ4)
print(mean(delta))
#> [1] -0.204
```

El resultado es $-0.20$, lo que implica que, en promedio en los datos, los hogares que están a 100 metros del pozo seguro más cercano tienen un $20\%$ menos de probabilidades de cambiar, en comparación con los hogares que están justo al lado del pozo seguro más cercano, con mismos niveles de arsénico y mismos niveles de educación.

---

<br>

**Ejemplo: Diferencia predictiva promedio en probabilidad de cambio, comparando hogares con niveles de arsénico existentes de 0.5 y 1.0.**

Calculamos la diferencia predictiva y la diferencia predictiva promedio, comparando los hogares en dos niveles diferentes de arsénico, suponiendo que la distancia al pozo seguro más cercano y los niveles de educación son iguales. Elegimos $\mbox{arsenic} = 0.5$ y $1.0$ como puntos de comparación porque $0.5$ es el nivel más bajo inseguro, $1.0$ es el doble, y esta comparación captura gran parte del rango de los datos:


```r
hi <- 1.0
lo <- 0.5
delta <- invlogit (b[1] + b[2]*wells$dist_100 + b[3]*hi + b[4]*wells$educ4) -
         invlogit (b[1] + b[2]*wells$dist_100 + b[3]*lo + b[4]*wells$educ4)
print (mean(delta))
#> [1] 0.0564
```

El resultado es $0.06$, por lo que esta comparación corresponde a una diferencia del $6\%$ en la probabilidad de cambiar de pozo.

**Ejemplo: Diferencia predictiva promedio en probabilidad de cambio, comparando hogares con 0 y 12 años de educación.**

Calcular nuevamente la diferencia predictiva promedio de la probabilidad de cambio de pozo para hogares con 0 vs 12 años de educación:


```r
hi <- 3
lo <- 0
delta <- invlogit (b[1]+b[2]*wells$dist_100+b[3]*wells$arsenic+b[4]*hi) -
         invlogit (b[1]+b[2]*wells$dist_100+b[3]*wells$arsenic+b[4]*lo)
print (mean(delta))
#> [1] 0.117
```

---

<br>

### Diferencias predictivas promedio en presencia de interacciones {-}

Por ejemplo, consideremos la diferencia predictiva promedio, comparando $\mbox{dist} = 0$ con $\mbox{dist} = 100$, para el modelo que incluye una interacción distancia $\times$ arsénico:


```r
fit.11 <- glm(switch ~ dist_100 + arsenic + educ4 + dist_100:arsenic,
              data = wells,
              family=binomial(link="logit"))
summary(fit.11)
#> 
#> Call:
#> glm(formula = switch ~ dist_100 + arsenic + educ4 + dist_100:arsenic, 
#>     family = binomial(link = "logit"), data = wells)
#> 
#> Deviance Residuals: 
#>    Min      1Q  Median      3Q     Max  
#> -2.715  -1.189   0.748   1.069   1.722  
#> 
#> Coefficients:
#>                  Estimate Std. Error z value Pr(>|z|)    
#> (Intercept)       -0.3490     0.1264   -2.76   0.0057 ** 
#> dist_100          -0.6047     0.2095   -2.89   0.0039 ** 
#> arsenic            0.5554     0.0695    7.99  1.4e-15 ***
#> educ4              0.1692     0.0383    4.42  1.0e-05 ***
#> dist_100:arsenic  -0.1629     0.1023   -1.59   0.1115    
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#> 
#> (Dispersion parameter for binomial family taken to be 1)
#> 
#>     Null deviance: 4118.1  on 3019  degrees of freedom
#> Residual deviance: 3907.9  on 3015  degrees of freedom
#> AIC: 3918
#> 
#> Number of Fisher Scoring iterations: 4
```

Calculamos la diferencia predictiva promedio entre hogares a 0 y 100 metros de distancia del pozo seguro como:


```r
b <- coef(fit.11)
hi <- 1
lo <- 0
delta <- invlogit(b[1] + b[2]*hi + b[3]*wells$arsenic + b[4]*wells$educ4 + b[5]*hi*wells$arsenic) -
         invlogit(b[1] + b[2]*lo + b[3]*wells$arsenic + b[4]*wells$educ4 + b[5]*lo*wells$arsenic)
print(mean(delta))
#> [1] -0.194
```

### Notación general para diferencias predictivas {-}

Consideramos que deseamos evaluar las diferencias predictivas una a la vez y usamos la notación de:

* $u$ para la entrada de interés, y 

* $v$ para el vector de todas las otras entradas.

Supongamos que estamos considerando comparaciones entre $u=u^{(1)}$ y $u=u^{(0)}$ y todas las demás variables permanecen constantes.

La diferencia predictiva en probabilidades entre los dos casos que difiere solo en $u$ es:
$$
\delta(u^{(\mbox{hi})},u^{(\mbox{lo})},v,\beta) = P(y=1|u^{(\mbox{hi})},v,\beta)−P(y=1|u^{(\mbox{lo})},v,\beta).
$$

La diferencia predictiva media es la media de las $n$ diferencias predictivas correspondientes a cada observación en los datos:
$$
\Delta(u^{(\mbox{hi})}, u^{(\mbox{lo})}) = \dfrac{1}{n} \sum_{i=1}^n{\delta(u^{(\mbox{hi})}, u^{(\mbox{lo})}, v_i, β),}
$$
donde $v_i$ representa el vector de otras variables de entrada para la $i$-ésima observación. 

<p class="espacio3">
</p>

Consideremos el modelo de regresión logística con la interacción de educación y distancia:


```r
fit.12 <- glm(switch ~ dist_100 + arsenic + educ4 + dist_100:educ4,
              data = wells,
              family=binomial(link="logit"))
```

Los coeficientes del modelo son:

```r
coef(fit.12)
#>    (Intercept)       dist_100        arsenic          educ4 dist_100:educ4 
#>       0.000496      -1.389852       0.480599      -0.008308       0.382545
```


```r
b <- coef(fit.12)
hi <- 3
lo <- 0
delta <- invlogit(b[1] + b[2]*wells$dist_100 + b[3]*wells$arsenic + b[4]*hi + b[5]*wells$educ*wells$dist_100) -
         invlogit(b[1] + b[2]*wells$dist_100 + b[3]*wells$arsenic + b[4]*lo + b[5]*wells$educ*wells$dist_100)
print(mean(delta))
#> [1] -0.00468
```

![](figuras/manicule2.jpg) 
<div class="centered">
<p class="espacio">
</p>

La diferencia predictiva promedio entre hogares con 0 años y 12 años de educación es:

(a) -0.05

(b) 0.30

(c) 0.12

(d) 0.05

<p class="espacio3">
</p>
</div>
<br>

![](figuras/manicule2.jpg) 
<div class="centered">
<p class="espacio">
</p>
En regresión logística, el gradiente de $D(\beta)$ está dado por
$$
p_1(x) = h\left(\beta_0+\beta_1 x_1 + \beta_2x_2\right).
$$
<p class="espacio3">
</p>

Se cuenta con los datos de la siguiente tabla y que aparecen en la gráfica de la derecha:

<p class="espacio3">
</p>

<center>
![](figuras/ejemplo.png){width=60%}
</center>

<p class="espacio3">
</p>
<p class="espacio3">
</p>

¿Cuál de las siguientes afirmaciones son ciertas? Selecciona una o más.


(a) $D(\beta)$ será una función convexa, por lo que descenso en gradiente debería converger al mínimo global.

(b) Para incrementar el ajuste del modelo a los datos podríamos agregar términos polinomiales o de interacción, por ejemplo, $p_1(x_i)=h\left(\beta_0+\beta_1 x_1 + \beta_2x_2 + \beta_3x_1^2 + \beta_4x_1x_2 +\beta_5x_2^2\right)$.

(c) Los datos no se pueden separar utilizando una recta de modo que las observaciones de éxito estén de un lado de la recta y las observaciones de fracaso del otro. Por lo tanto, descenso en gradiente no podría converger.

(d) Como lo datos no se pueden separar mediante una recta, entonces el método de regresión logística produciría los mismos resultados que aplicar regresión lineal a estos datos.

<p class="espacio3">
</p>
</div>
<br>

![](figuras/manicule2.jpg) 
<div class="centered">
<p class="espacio">
</p>
En regresión logística el gradiente de la devianza está dado por
$$
\dfrac{\partial D(\beta)}{\partial \beta_j} = \sum_{i=1}^N(h_\beta(x^{(i)}) - y^{(i)})x_j^{(i)}.
$$
¿Cuál de las siguientes expresiones es una actualizción correcta para descenso en gradiente con parámetro $\alpha$? Selecciona una o más.

(a) $\beta_j := \beta_j - \alpha\frac{1}{N}\sum_{i=1}^N\left(\beta^Tx-y^{(i)}\right)x_j^{(i)}.$

(b) $\beta := \beta - \alpha\frac{1}{N}\sum_{i=1}^N\left(\dfrac{1}{1+e^{-\beta^Tx^{(i)}}}-y^{(i)}\right)x^{(i)}.$

(c) $\beta := \beta - \alpha\frac{1}{N}\sum_{i=1}^N\left(\beta^Tx-y^{(i)}\right)x^{(i)}.$

(d) $\beta_j := \beta_j - \alpha\frac{1}{N}\sum_{i=1}^N\left(\dfrac{1}{1+e^{-\beta^Tx^{(i)}}}-y^{(i)}\right)x_j^{(i)}$ &nbsp; (actualiza simultáneamente para toda $j$).

<p class="espacio3">
</p>
</div>
<br>

![](figuras/manicule2.jpg) 
<div class="centered">
<p class="espacio">
</p>

¿Cuáles de las siguientes afirmaciones son ciertas? 

(a) La devianza $D(\beta)$ en regresión logística con $N\geq 1$ observaciones siempre es no negativa.

(b) En regresión logística, descenso en gradiente algunas veces converge a un mínimo global (no logra encontrar el mínimo global). Esta es la razón por la cual preferimos algoritmos más avanzados de optimización, como BFGS y Región de confianza.

(c) La regresión lineal siempre funciona bien para hacer clasificación si se clasifica utilizando un umbral en la predicción hecha por regresión lineal.

(d) La función logística $h(x)=\frac{1}{1+e^{-x}}$ nunca es mayor que uno ($>1$).

<p class="espacio3">
</p>
</div>
<br>

---

<br>

## Tarea

1. Utiliza los datos de cambio de pozos de arsénico del archivo wells.csv.

a. Ajusta un modelo de regresión logística para la probabilidad de cambio de pozo utilizando una transformación logarítmica para la variable de distancia.

b. Haz una gráfica que muestre la probabilidad de cambio de pozo como función de la distancia al pozo, y que en la gráfica se muestren también los datos.

c. Haz una gráfica de residuales contra ajustados utilizando residuales agrupados.

d. Calcula la tasa de error del modelo ajustado y compárala con la tasa de error del modelo nulo.

e. Crea variables indicadores correspondientes a:

    + $\mbox{dist} < 100$,
    
    + $100 \leq \mbox{dist} < 200$, y 
    
    + $\mbox{dist} \geq 200$.
    
  Ajusta una regresión logística para $P(\mbox{switch})$ utilizando estas tres variables indicadoras. Con este nuevo modelo repite las gráficas de los incisos b y c, y los cálculos del inciso d.


2. Continuamos con los datos de los pozos.

a. Ajusta una regresión logística utilizando como predictores distancia, el logaritmo del arsénico y su interacción. Interpreta los coeficientes estimados y sus errores estándar.

b. Haz gráficas que muestren la relación entre la probabilidad de cambio de pozo, la distancia y el nivel de arsénico.

c. Calcula las diferencias predictivas promedio correspondientes a:

    + la diferencia entre $\mbox{dist}=0$ y $\mbox{dist=100}$, cuando arsénico permanece constante.
    
    + la diferencia entre $\mbox{dist=100}$ y $\mbox{dist=200}$, cuando arsénico permanece constante.
    
    + la diferencia entre $\mbox{arsenic=0.5}$ y $\mbox{arsenic=1.0}$, cuando distancia permanece constante.
    
    + la diferencia entre $\mbox{arsenic=1.0}$ y $\mbox{arsenic=2.0}$, cuando distancia permanece constante.

Discute los resultados.
