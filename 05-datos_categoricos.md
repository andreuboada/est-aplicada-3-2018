
# Análisis de datos categóricos

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

Sólo necesitas instalar un paquete una vez, pero debes volver a cargarlo cada vez que inicies una nueva sesión.


```r
library(tidyverse)
```

Las variables categóricas están por doquier. Desde ayudar a decidir cuándo un tratamiento médico es mejor hasta evaluar los factores que afectan nuestras opiniones y conductas, hoy en día los analistas encuentran innumerables usos para los métodos de datos categóricos. Primero vamos a repasar algunos conceptos de probabilidad.

## Repaso y algunos conceptos

Recordemos la **distribución multinomial**. Supongamos que cada uno de $n$ ensayos independientes e idénticos tiene realizaciones en $c$ categorías. Definimos $y_{ij}$ como
$$
y_{ij} = \left\{ \begin{array}{cl}
1 & \text{si el }\; i\text{-ésimo ensayo cae en la categoría }j,\\
0 & \text{en otro caso.}
\end{array}\right.
$$

Entonces $y_i=(y_{i1},y_{i2},\ldots,y_{ic})$ representa _un_ ensayo multinomial, done
$$
\displaystyle{\sum_j{y_{ij}}}=1.
$$

Notemos que $y_{ic}=1-(y_{i1}+\cdots+y_{i,c-1})$ es redundante. Sea $n_j=\displaystyle{\sum_i{y_{ij}}}$ el número de ensayos que caen en la categoría $j$. Los conteos $(n_1,n_2,\ldots,n_c)$ tienen una distribución multinomial.

Sea $\pi_{j}=P(Y_{ij}=1)$, la probabilidad de éxito en la categoría $j$. La función de masa de probabilidad de $(n_1,n_2,\ldots,n_c)$ es 
$$
p(n_1,n_2,\ldots,n_c) = \dfrac{n!}{n_1!n_2!\cdots n_c!}\pi_1^{n_1}\pi_2^{n_2}\cdots \pi_c^{n_c}.
$$

Sea $n=\displaystyle{\sum_j{n_j}}$. Recordemos que esta ecuación es de dimensión $c-1$ porque 
$$
n_c = n - (n_1 + n_2 + \cdots + n_{c-1}).
$$

Se puede ver que
$$
\begin{eqnarray*}
E(n_j) =n\pi_j, \quad && V(n_j)=n\pi_j(1-\pi_j),\\
C(n_i,n_j)=-n\pi_i \pi_j&\quad&\mbox{si } i\neq j
\end{eqnarray*}
$$

**Modelo Poisson**

Sean $(Y_1,Y_2,\ldots,Y_c)$ variables aleatorias Poisson independientes con parámetros $(\mu_1,\mu_2,\ldots,\mu_c)$. La función de masa de probabilidad conjunta es
$$
P(Y_1=n_1, Y_2=n_2, \ldots, Y_c=n_c) = \prod_i{\mbox{exp}(-\mu_i)\dfrac{\mu_i^{n_i}}{n_i!}}.
$$ 

El total $n=\displaystyle{\sum_i{Y_i}}$ también tiene una distribución Poisson con media $\displaystyle{\sum_i{\mu_i}}$. Como $n$ también es una variable aleatoria, al condicionar en $n$, $\{Y_i\}$ ya no tienen una distribución Poisson, pues cada $Y_i$ no puede exceder $n$.

La distribución condicional es
$$
\begin{eqnarray*}
P\left(Y_1=n_1,\ldots,Y_c=n_c \,\middle|\,  \sum_j{Y_j}=n\right) &=& \dfrac{P(Y_1=n_1,\ldots,Y_c=n_c)}{P\left(\sum_j{Y_j}\right)} \\
&=& \dfrac{\prod_i \mbox{exp}(-\mu_i)\mu_i^{n_i}/n_i!}{\mbox{exp}\left(-\sum_j{\mu_j}\right)\left(\sum_j {\mu_j}\right)^n/n!} \\
&=& \dfrac{n!}{\prod_i n_i!} \prod_i{\pi_i^{n_i}}
\end{eqnarray*}
$$
con $\pi_i = \dfrac{\mu_i}{\sum_i \mu_i}$, es decir, se trata de una distribución multinomial con parámetros $(n, \{\pi_i\})$.

Muchos análisis de datos categóricos suponen una distribución multinomial. Tales análisis usualmente tineen resultados similres a aquellos análisis que suponen una distribución Poisson, por las similitudes en sus funciones de verosimilitud.

---

<br>


En la estimación de parámetros a menudo se utilizan dos métodos para obtener intervalos de confianza:

1. Método de Wald

En el caso univariado se utiliza como estimador de la varianza $-E\left(\dfrac{d^2 L(\theta)}{d\theta^2}\right)$ y el estadístico es 
$$z=(\hat{\theta} - \theta_0)/\mbox{SE} \sim N(0,1)$$
o en el caso multivariado,
$$
W = \left(\hat{\theta}- \theta_0\right)^T\left[\mbox{Cov}\left(\hat{\theta}\right)\right]^{-1}\left(\hat{\theta}- \theta_0\right),
$$
y como $\hat{\theta}$ se distribuye normal asintóticamente, entonces la distribución de $W$ es $\chi^2$ con grados de libertad igual al rango de $\mbox{Cov}\left(\hat{\theta}\right)$, el número de parámetros no redundantes.

2. Método de cociente de verosimilitud

Si $l_0$ es el máximo valor de la función de verosimilitud bajo $H_0$ y $l_1$ es el valor máximo sobre el espacio de parámetros (que contiene también el valor bajo $H_0$), entonces $l_0 \leq l_1$ y el estadístico es

$$-2\,  \mbox{log}(\Lambda) = -2\,  \mbox{log}(l_0/l_1)=-2(L_0-L_1) \sim \chi^2_n$$
donde los grados de libertad equivalen a la diferencia de dimensiones de los espacios de parámetros.

### Caso binomial

Definimos la función de verosimilitud de una variable aleatoria binomial con $n$ realizaciones y $x$ éxitos:

$$
L(\theta) = \mbox{log}(\theta^x(1-\theta)^{n-x}) = x\mbox{log}(\theta) + (n-x)\mbox{log}(1-\theta)
$$


```r
likelihood <- function(x, n){
  function(theta){x*log(theta) + (n-x)*log(1-theta)}
}
```

Creamos nuestra función de verosimilitud para $x=3$ y $n=10$:


```r
mi_likelihood <- likelihood(3, 10)
```

Graficamos la función:


```r
ggplot(data = data.frame(x = 0), mapping = aes(x = x)) +
  stat_function(fun = mi_likelihood) + xlim(0.001,0.999)
```

<img src="05-datos_categoricos_files/figure-html/unnamed-chunk-5-1.png" width="70%" style="display: block; margin: auto;" />

El estadístico de Wald da como resultado el invervalo

$$
\hat{\theta} \pm z_{\alpha/2}\sqrt{\dfrac{\hat{\theta}(1-\hat{\theta})}{n}}
$$

El estadístico del cociente de verosimilitud es:

$$
2x\left[x\mbox{log}\left(\dfrac{\hat{\theta}}{\theta_0}\right)+(n-x)\mbox{log}\left(\dfrac{1-\hat{\theta}}{1-\theta_0}\right)\right] = \chi^2_{1,\alpha}
$$

Se puede expresar como

$$
2\sum{\mbox{observado} \,\left[\,\mbox{log}\left(\dfrac{\mbox{observado}}{\mbox{ajustado}}\right)\right]}
$$

Existen varios métodos para obtener intervalos de confianza. Utilizando la función `ciAllx` del paquete `proportion` podemos obtener intervalos de confianza para $\hat{\theta}$ a partir de 6 métodos:


```r
library(proportion)
intervalos <- ciAllx(x = 3, n = 10, alp = 0.05) 
intervalos %>% knitr::kable()
```



method         x   LowerLimit   UpperLimit  LowerAbb   UpperAbb   ZWI 
-----------  ---  -----------  -----------  ---------  ---------  ----
Wald           3        0.016        0.584  NO         NO         NO  
ArcSine        3        0.071        0.603  NO         NO         NO  
Likelihood     3        0.085        0.607  NO         NO         NO  
Score          3        0.108        0.603  NO         NO         NO  
Logit-Wald     3        0.100        0.624  NO         NO         NO  
Wald-T         3        0.002        0.598  NO         NO         NO  

Los intervalos de confianza para todos los métodos son realmente muy similares. Si el tamaño de muestra $n$ es grande, los 6 métodos dan como resultado intervalos de confianza prácticamente idénticos.


```r
ggplot(intervalos, aes(y = method)) + 
  geom_segment(aes(x = LowerLimit, xend = UpperLimit, y = method, yend = method)) + 
  geom_vline(xintercept = 0.3, color = 'red') +
  xlab('Intervalo de confianza para cada método')
```

<img src="05-datos_categoricos_files/figure-html/unnamed-chunk-7-1.png" width="60%" style="display: block; margin: auto;" />

---

<br>

### Estimación de parámetros multinomiales {-}

Definimos la función de verosimilitud
$$
l(n_1,n_2,\ldots,n_c | \pi_1, \pi_2, \ldots, \pi_c) = c \prod_j \pi_j^{n_j}
$$
donde $\pi_j \geq 0$ y $\sum_j{\pi_j}=1$. 

Para estimar $\{\pi_j\}$ maximizamos la log-verosimilitud
$$
L(\pi) = \sum_j{n_j \mbox{log}(\pi_j)}.
$$

Para no tener redundancias vemos $L$ como función de $\pi_1,\pi_2,\ldots,\pi_{c-1}$ pues $\pi_c=1-(\pi_1+ \pi_2+\cdots+\pi_{c-1})$. Por lo tanto,
$$
\dfrac{d \pi_c}{d \pi_j} = -1 \qquad \mbox{para }\; j=1,2,\ldots,c-1.
$$
Por la regla de la cadena,
$$
\dfrac{d\,\mbox{log}(\pi_c)}{d\,\pi_j}=\dfrac{1}{\pi_c} \cdot \dfrac{d\, \pi_c}{d\, \pi_j}=-\dfrac{1}{\pi_c}.
$$
Ahora diferenciamos $L$ con respecto a $\pi_j$
$$
\dfrac{d\, L(\pi)}{d\, \pi_j}=\dfrac{n_j}{\pi_j} - \dfrac{n_c}{\pi_c} = 0.
$$
Por lo que los estimadores de máxima verosimilitud satisfacen que
$$
\dfrac{\hat{\pi}_j}{\hat{\pi}_c} = \dfrac{n_j}{n_c}.
$$
Ahora bien,
$$
1 = \sum_j{\pi_j}= \dfrac{\hat{\pi}_c\left(\sum_j n_j\right)}{n_c}=\dfrac{\hat{\pi}_c n}{n_c},
$$
y se tiene que $\hat{\pi_c}=n_c/n$ y $\hat{\pi_j}=n_j/n$ para $j=1,2,\ldots,c-1$.

Se puede verificar que estos estimadores efectivamente maximizan la verosimilitud. Notemos que $\hat{\pi_j}=n_j/n$ son las proporciones muestrales.

## La $\chi^2$ de Pearson de una multinomial

En 1900 el estadístico Karl Pearson definió una prueba de hipótesis para la multinomial. Su motivación inicial fue analizar las probabilidades de ocurrencias de varias realizaciones en el juego de la ruleta. Consideramos para $j=1,2,\ldots,c$ 
$$
H_0:\pi_j =\pi_{j0} \qquad H_1:\pi_j \neq \pi_{j0}.
$$

Bajo $H_0$, los valores esperados de $\{n_j\}$, llamadas _frecuencias esperadas_ son $\mu_j=n\pi_{j0}$, $j=1,\ldots,c$. El estadístico propueto es
$$
X^2 = \sum_j{\dfrac{(n_j - \mu_j)^2}{\mu_j}} \sim \chi^2_{(c-1)}.
$$

Si las diferencias $\{n_j - \mu_j\}$ son más grandes, esto produce valores $X^2$ más grandes para una $n$ fija. Si $X_o^2$ es el valor observado de $X^2$ entonces el valor p es $P(X^2 \geq X_o^2)$. Si $n$ es grande, $X^2$ tiene una distribución $\chi^2_{c-1}$.


### Cociente de verosimilitud de una multinomial

Bajo $H_0$ la verosimilitud se maximiza cuando $\hat{\pi}_j=\pi_{j0}$ y en el caso general cuando $\hat{pi}_j=\frac{n_j}{n}$. El cociente de verosimilitud es

$$
\Lambda = \dfrac{\prod_j{\pi_{j0}^{n_j}}}{\prod_j{(n_j/n)^{n_j}}}.
$$
Por lo tanto, el estadístico del cociente de verosimilitud es

$$
G^2 = -2\,\mbox{log}(\Lambda) = 2\, \sum_j{n_j \mbox{log}\left(\dfrac{n_j}{n}\pi_{j0}\right)}.
$$

A este estadístico se le llama _estadístico $\chi^2$ de verosimilitud_. Entre más grande sea el valor de $G^2$ hay mayor evidencia en contra de $H_0$. En el caso general, el espacio de parámetros consiste de $\{\pi_j\}$ sujeto a que $\sum_j{\pi_j}=1$, por lo que la dimensión es $c-1$. Bajo $H_0$, se especifica por completo $\{\pi_j\}$, por lo que la dimensión es $0$. La diferencia entre estas dimensiones es $(c-1)$. Si $n$ es grande, entonces $G^2$ tiene una distribución $\chi^2$ con $(c-1)$ grados de libertad.

## Definiciones

Supongamos que se tiene una tabla de contingencias. A continuación introduciremos una notación y algunas definiciones.

### Notación

Sea $\pi_{ij}$ la probabilidad de que una observación $(X,Y)$ esté en la celdilla ($i$,$j$). Las densidades marginales las denotamos por:
$$
\pi_{i+}=\sum_j{\pi_{ij}},\qquad \pi_{+j}  = \sum_i{\pi_{ij}}
$$
Cuando ambas variables son aleatorias, se pueden definir las densidades marginales:
$$
\pi_{j|i} = \pi_{ij}/\pi_{i+}, \qquad \mbox{para toda }i\mbox{ y }j
$$

Se dice que las variables son **independientes** si 
$$
\pi_{ij} = \pi_{i+}\pi_{+j} \quad \mbox{para }\; i=1,\ldots,I\; \mbox{ y para }\; j=1,\ldots,J.
$$
Cuando son independientes se cumple que
$$
\pi_{j|i}=\pi_{ij}/\pi_{i+}=(\pi_{i+}\pi_{+j})/\pi_{i+}=\pi_{+j} \quad \mbox{para }i=1,\ldots,I.
$$

### Razón de momios

\BeginKnitrBlock{nota}<div class="nota">Para una probabilidad de éxito $\pi$ se definen los _momios_ (o _chances_) como
$$
\Omega = \dfrac{\pi}{1-\pi}
$$
Los momios siempre son no negativos.</div>\EndKnitrBlock{nota}

**Ejemplo**

Un sitio de apuestas escribe:
> Momio 7/1: Ganas $7 por cada $1 apostado. Si apuestas $10, cobras $70 más tu apuesta, es decir, $80.
> Momio 5/2: Ganas $5 por cada $2 apostados. Si apuestas $10, cobras $25 más tu apuesta, es decir, $35.
> Momio 3/5: Ganas $3 por cada $5 apostados. Si apuestas $10, cobras $6 más tu apuesta, es decir, $16.


<p class="espacio">
</p>


<img src="figuras/apuesta.png" width="70%" style="display: block; margin: auto;" />

<p class="espacio">
</p>

![](figuras/manicule2.jpg) 
<div class="centered">
<p class="espacio">
</p>
Si el momio es menor que 1 entonces...

(a) La probabilidad de éxito es cero.

(b) La probabilidad de éxito es menor que $1/2$.

(c) El éxito es más probable que el fracaso.

(d) Todas la anteriores.

<p class="espacio3">
</p>
</div>
<br>

\BeginKnitrBlock{information}<div class="information">Si $\Omega > 1$, entonces es más probable el éxito que el fracaso. Por ejemplo, cuando $\pi=0.75$ entonces $\Omega = 0.75/0.25 =3$, un éxito es 3 veces más probable que un fracaso, y esperaríamos 3 éxitos por cada fracaso. Cuando $\Omega = \frac{1}{3}$ un fracaso es tres veces más verosímil que un éxito.</div>\EndKnitrBlock{information}

<br>


