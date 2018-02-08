
# Teorema del Límite Central

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




A continuación discutiremos el Teorema del Límite Central (CLT), el cual nos ayuda a realizar cálculos importantes relacionados con la probabilidad de las cosas. Se utiliza con frecuencia en la ciencia para probar hipótesis estadísticas. 

Para utilizarlo, tenemos que hacer diferentes supuestos. Sin embargo, si los supuestos son verdaderos, entonces podemos calcular probabilidades exactas de eventos mediante el uso de una fórmula matemática muy sencilla.

## La distribución de \bar{Y}

\BeginKnitrBlock{nota}<div class="nota">**_El Teorema del Límite Central_**
  
El CLT es uno de los resultados matemáticos más utilizados en la ciencia. Nos dice que cuando el tamaño de la muestra es grande, la media $\bar{Y}$ de una muestra aleatoria sigue una distribución normal con centro en la media poblacional $\mu_Y$ y con desviación estándar igual a la desviación estándar de la población $\sigma_Y$ **dividida por la raíz cuadrada del tamaño de la muestra** $\sqrt{N}$. Nos referimos a la desviación estándar de la distribución de una variable aleatoria como el error estándar de la variable aleatoria.</div>\EndKnitrBlock{nota}

<br>

Si tomamos muchas muestras de tamaño $N$, entonces la cantidad:

$$
\frac{\bar{Y} - \mu}{\sigma_Y/\sqrt{N}}
$$

se aproxima con una distribución normal con centro en 0 y con desviación estándar 1.

Ahora nos interesa la diferencia entre dos medias muestrales. Aquí, de nuevo, un resultado matemático nos puede ayudar. Si tenemos dos variables aleatorias $X$ y $Y$ con medias $\mu_X$ y $\mu_Y$ y varianzas $\sigma_X$ y $\sigma_Y$ respectivamente, entonces tenemos el siguiente resultado: la media de la suma $Y + X$ es la suma de las medias $\mu_Y + \mu_X$. Esto implica que la media de $Y - X = Y + aX$ con $a = -1$, es $\mu_Y - \mu_X$. 

Sin embargo, el siguiente resultado quizás no sea tan intuitivo. Si $X$ y $Y$ son independientes entre sí, entonces la varianza de $Y + X$ es la suma de las varianzas $\sigma_Y^2 + \sigma_X^2$. Esto implica que la varianza de la diferencia $Y - X$ es la varianza de $Y + aX$ con $a = -1$ que es $\sigma^2_Y + a^2\sigma_X^2 = \sigma ^ 2_Y + \sigma_X ^ 2$. Así que la varianza de la diferencia es también la suma de las varianzas. Si esto parece un resultado contraintuitivo, recordemos que si $X$ y $Y$ son independientes entre sí, el signo realmente no importa. Finalmente, otro resultado útil es que la suma de variables normales (mutuamente independientes) es otra vez normal.

El cociente 

$$
\frac{(\bar{Y}-\bar{X}) - (\mu_Y - \mu_X)}{\sqrt{\frac{\sigma_X^2}{M} + \frac{\sigma_Y^2}{N}}}
$$

se aproxima por una distribución normal centrada en 0 y con desviación estándar 1. Usando esta aproximación, el cálculo de probabilidades es simples porque conocemos la proporción de la distribución bajo cualquier valor. Por ejemplo, sólo el 5% de estos valores son mayores que 2 (en valor absoluto):


```r
pnorm(-2) + (1 - pnorm(2))
#> [1] 0.0455
```

---

<br>

## ¿De dónde proviene la distribución normal?

En 1894, Francis Galton inventó lo que ahora conocemos como **tablero de Galton**, para ilustrar el Teorema del Límite Central, y en particular, que la distribución binomial es una aproximación a la distribución normal. El tablero consta de una tablero vertical con varias filas de clavos acomodados en forma de arreglo triangular. En la parte inferior hay varias cubetas para cada posible camino que forman los clavos en el tablero. Se deja caer canicas desde la parte superior, las cuales van botando, rebotando y saltando, aleatoriamente, y van depositándose, a medida que caen, en las cubetas de la parte inferior. 

Las canicas chocarán con el primer clavo teniendo una probabilidad de $1/2$ de ir a la izquierda o la derecha. A medida que caen, cada canica tiene más caminos a donde ir, es decir más posibilidades para desviarse a la izquiera o a la derecha. A lo largo de esta estructura, las canicas toman caminos aleatorios hasta caer en alguna de las cubetas. Es consecuencia de las leyes del universo que está sostenido por una tela sobre la cual subyace lo aleatorio, que las canicas caen con mayor probabilidad en las cubetas que están al centro, mientras que la probabilidad de que caigan en cubetas más alejadas es cada vez menor cuando la canica se aleja más y más de la cubeta del centro.

<p class="espacio">
</p>

<img src="figuras/galton.png" width="70%" style="display: block; margin: auto;" />

<p class="espacio">
</p>

<img src="figuras/galton_70.gif" width="40%" style="display: block; margin: auto;" />

<p class="espacio">
</p>

\BeginKnitrBlock{information}<div class="information">**Nota:** Puedes ver el script para hacer la simulación del tablero de Galton [aquí](https://github.com/andreuboada/est-aplicada-3-2018/blob/master/recursos/tablero_galton.r).</div>\EndKnitrBlock{information}

<br>

La primera versión de este teorema fue postulada por el matemático francés Abraham De Moivre que, en un notable artículo publicado en 1733, usó la distribución normal para aproximar la distribución del número de soles resultante de muchos lanzamientos de una moneda justa. Este hallazgo estaba muy por delante de su tiempo y permaneció en el olvido hasta que el famoso matemático francés Pierre-Simon Laplace lo rescató de la oscuridad en su monumental obra __Théorie analytique des probabilités__, publicada en 1812. Laplace extendió el hallazgo de De Moivre al aproximar la distribución binomial en general con la distribución normal. El teorema en su forma más general fue demostrado por primera vez por el príncipe de las matemáticas, Carl Friedrich Gauss, en 1813. Hoy en día es conocida en su honor como **distribución Gaussiana**, cuando en su tiempo no era más que la **ley del error**.

Supongamos que $x$ y $y$ son errores **independientes** cometidos al azar cuando se han hecho dos mediciones __independientemente__ una de la otra.

<img src="04-tlc_files/figure-html/unnamed-chunk-8-1.png" width="70%" style="display: block; margin: auto;" />

<br>

\noindent
De tal forma que se cumple que
$$
g(r) \Delta x \Delta y = f(x) \Delta x f(y) \Delta y,
$$
por lo cual
$$
g(r) = f(x)f(y).
$$
Esto significa nada más que la magnitud del error $g(r)$ es el producto de las magnitudes de los errores en $x$ y $y$ **de forma independiente**.
\noindent
Las coordenadas $x$,$y$ son tales que
$$
x = r \cos(\theta), \; \;\; y = \mbox{sen}(\theta).
$$
Sabemos que
\begin{eqnarray*}
\dfrac{dx}{d\theta} &=& -r\mbox{sen}(\theta)\\
\dfrac{dy}{d\theta} &=& r \cos{(\theta)}
\end{eqnarray*}

Derivando con respecto a $\theta$:
\noindent
\begin{eqnarray*}
0 &=& dfrac{d f(x)}{d \theta} f(y) + \dfrac{d f(y)}{d \theta} f(x)\\
&=& \dfrac{df}{dx}\cdot \dfrac{d x}{d \theta}\cdot f(y) + \dfrac{d f}{d y}\cdot\dfrac{d y}{d\theta} \cdot f(x) \\
&=& -r f^\prime(x) \mbox{sen}(\theta)f(y) + f^\prime(y)\cdot r \cos(\theta) f(x)\\
&=& -y f^\prime(x)f(y) + xf^\prime(y)f(x).
\end{eqnarray*}
Por lo tanto, 
$$
yf^\prime(x)f(y) = x f^\prime(y)f(x).
$$
Se tiene que
$$
\dfrac{f^\prime(x)}{f(x)x} = \dfrac{f^\prime(y)}{f(y)y},
$$
para toda $x$ y $y$. Como $x$ y $y$ son mediciones arbitrarias, esto implica que
$$
\dfrac{f^\prime(x)}{f(x)x}
$$
debe ser constante. Por lo tanto,
$$
\displaystyle{\int{\dfrac{f^\prime(x)}{f(x)x}}\,dx = \int{c \,dx}}. 
$$
Multiplicando por $x$,
$$
\displaystyle{\int{\dfrac{f^\prime(x)}{f(x)}}\,dx = \int{cx\, dx}}. 
$$
Por lo cual,
$$
\mbox{ln}f(x) = c\cdot \dfrac{x^2}{2} + c^\prime.
$$

### ¿Qué signo tiene c?

Vemos que
$$
f(x) = Ae^{c\frac{x^2}{2}},
$$
donde $A=e^{c^\prime}$. Como $f(x)$ es la función de densidad de este fenómeno de errores independientes entonces se debe cumplir que:
$$
1 = \displaystyle{\int f(x)\, dx},
$$
y podemos concluir que $c<0$, para que $f(x)$ pueda ser función de densidad.
\noindent
Integramos:
$$
A \displaystyle{\int{e^{c\cdot \frac{x^2}{2}}}\, dx}.
$$
Sea $u=\sqrt{-\dfrac{c}{2}}x$, entonces $du = \sqrt{-\dfrac{c}{2}}\,dx$. Por lo cual,
$$
1 = A\sqrt{-\dfrac{2}{c}} \displaystyle{\int_{-\infty}^{\infty}{e^{-u^2}}\,du = A \sqrt{-\dfrac{2}{c}} \cdot \sqrt{\pi}}.
$$
Para obtener lo anterior, se desea demostrar que 
\noindent
\[
\boxed{\int_0^\infty{e^{-x^2}dx} = \dfrac{\sqrt{\pi}}{2}.}
\]
Sea 
\[
I = \int_{-\infty}^\infty{e^{-x^2}dx}, 
\]
entonces
\[
I^2=\left(\int_{-\infty}^\infty{e^{-x^2}dx}\right)\left(\int_{-\infty}^\infty{e^{-y^2}dy}\right)=\int_{-\infty}^\infty{\int_{-\infty}^{\infty}{e^{-(x^2+y^2)}dxdy}}.
\]
Si $x=r\mbox{cos}(\theta)$ y $y=r\mbox{sen}(\theta)$ entonces $x^2+y^2=r^2$ y se puede demostrar que $dxdy=rd\theta dr$. Por lo tanto,
\begin{eqnarray*}
I^2&=&\int_{-\infty}^\infty{\int_{-\infty}^{\infty}{e^{-(x^2+y^2)}dxdy}}\\
&=&\int_{0}^\infty{\int_{0}^{2\pi}{re^{-r^2}d\theta dr}}\\
&=&-\pi\int_{0}^{\infty}{-2re^{-r^2}dr}\\
&=&-\pi e^{-r^2}{\biggr\rvert_{0}^{\infty}}\\
&=&\pi.
\end{eqnarray*}
Por lo cual, $I=\sqrt{\pi}$. Como $e^{-x^2}$ es una función simétrica alrededor de $0$, entonces se tiene, finalmente, que
\[
\int_{0}^{\infty}{e^{-x^2}dx}=\dfrac{1}{2}\int_{-\infty}^{\infty}{e^{-x^2}dx}=\dfrac{\sqrt{\pi}}{2}.
\]

Finalmente,
$$
1 =A \sqrt{-\dfrac{2}{c}} \cdot \sqrt{\pi},
$$
y despejando $A$, obtenemos que
$$
A = \sqrt{-\dfrac{c}{2\pi}}.
$$

Sean $\mu$, el valor esperado de $X$, y $\sigma^2$ la varianza de $X$, $E(X)$ y $V(X)$, respectivamente. Vemos que
\noindent
\begin{eqnarray*}
E(X) &=& \displaystyle{\int_{-\infty}^{\infty}{Ax e^{c\frac{x^2}{2}}}\, dx}\\
&=& \sqrt{-\dfrac{c}{2\pi}}\displaystyle{\int_{-\infty}^\infty{xe^{c\frac{x^2}{2}}}\,dx}.
\end{eqnarray*}
Por lo tanto, 
$$
E(X) = -\dfrac{1}{c} \sqrt{-\dfrac{c}{2\pi}}\,e^{c\frac{x^2}{2}}{\biggr\rvert_{-\infty}^{\infty}}=0.
$$
Ahora bien,
$$
E(X^2) = V(X).
$$
Tenemos que
$$
E(X^2) = \sqrt{-\dfrac{c}{2\pi}} \displaystyle{\int_{-\infty}^\infty{x^2e^{c\frac{x^2}{2}}}\,dx}.
$$
Integrando por partes (con $u=x$ y $dv = xe^{c\frac{x^2}{2}}\,dx$) ahora obtenemos
\begin{eqnarray*}
\sigma^2 = V(X) &=& \sqrt{-\dfrac{c}{2\pi}} \left(\dfrac{1}{c}xe^{cx^2/2}{\biggr\rvert_{-\infty}^{\infty}} - \dfrac{1}{c}\displaystyle{\int_{-\infty}^{\infty}{e^{c{x^2/2}}\,dx}}\right) \\
&=& \sqrt{-\dfrac{c}{2\pi}} \left(-\dfrac{1}{c}\displaystyle{\int_{-\infty}^{\infty}{e^{cx^2/2}}\,dx}\right) \\
&=& \sqrt{-\dfrac{c}{2\pi}} \cdot \left(\dfrac{1}{c}\right) \cdot \sqrt{-\dfrac{2\pi}{c}}.
\end{eqnarray*}
Por lo cual,
$$
c = - \dfrac{1}{\sigma^2}.
$$
Finalmente, la distribución de $X$ con media $0$ y varianza $\sigma^2$ es
$$
f(x) = \dfrac{1}{\sqrt{2\pi\sigma^2}}\,e^{-\frac{1}{2\sigma^2}x^2}.
$$
Si ahora la media es $\mu$, entonces
$$
f(x) = \dfrac{1}{\sqrt{2\pi\sigma^2}}\,e^{-\frac{1}{2\sigma^2}(x-\mu)^2}.
$$
Con la siguiente aplicación podemos simular muestras de cualquier distribución y visualizar la distribución de $\bar{X}$:

<iframe src="https://andreuboada.shinyapps.io/tlc-shiny/?showcase=0" width="70%" height="600px"></iframe>

## Otras observaciones

Otras propiedades de esta distribución se pueden obtener buscando los puntos críticos de su función de densidad
$$
f(x) = Ae^{cx^2/2}.
$$
La primera derivada es
$$
f^\prime(x) = A e^{cx^2/2}\cdot cx.
$$
Por lo que $f^\prime(x)=0$ cuando $x=0$. La segunda derivada es 
$$
f^{\prime\prime}(x) = cA\left(e^{cx^2/2}+xe^{cx^2/2}\cdot cx\right).
$$
Por lo tanto,
\begin{eqnarray*}
f^{\prime\prime}(0) &=& cA \\
&=& c\sqrt{-\dfrac{c}{2\pi}} \\
&=& \sqrt{\dfrac{1}{2\pi\sigma^2}} > 0.
\end{eqnarray*}

Por lo tanto, si $\sigma^2 = 1$, entonces el máximo de $f(x)$ se alcanza en $x=0$, que coincide con la media, y el valor de $f$ en $x=0$ es
$$
\sqrt{\dfrac{1}{2\pi}} \approx 0.3989.
$$
Ahora bien, $f^{\prime\prime}(0) = 0$ si y sólo si
$$
e^{cx^2/2} = -cx^2 e^{cx^2/2},
$$
que ocurre si y sólo si
$$
x = \pm \sigma.
$$
Esto quiere decir que $f(x)$ tiene puntos de inflexión en $-\sigma$ y $\sigma$.

<img src="04-tlc_files/figure-html/unnamed-chunk-10-1.png" width="70%" style="display: block; margin: auto;" />

## Cuantiles de un conjunto de datos

Los cuartos, octavos, etc. son útiles, fáciles de comprender y de calcular a mano (para conjuntos chicos de datos), sin embargo, necesitamos generalizar estos métodos para estudiar con más detalle la distribución de un conjunto de datos.  

Como primera definición tenemos:

El **cuantil** $f$ de un conjunto de datos es el valor $q(f)$ en la escala de medición del conjunto tal que aproximadamente una fracción $f$ de los datos son menores o iguales a $f$.

Por ejemplo, si los datos son $1,2,2,5,$  entonces $1$ es el cuantil $1/4$, $2$ es el cuantil $1/2$ y también el $3/4$, y $5$ es el cuantil $1$.

Tenemos que resolver varios problemas con esta definición:

* ¿Cuál es el cuantil $1/3$ en los datos anteriores?

* Asimetría: el dato más chico es el cuantil $1/n$, donde $n$ es el tamaño del conjunto de datos, pero el más grande es el cuantil $1$ (en lugar del cuantil $1-1/n$, si la definición fuera simétrica).

Problemas adicionales surgen cuando queremos comparar los cuantiles de un conjunto de datos con los cuantiles teóricos de una distribución dada, esto para contestar preguntas como: ¿la distribución de datos es similar a una normal? Para comprender mejor los cuantiles y poder responder estas preguntas comencemos con la construcción de gráficas de cuantiles para densidades de probabilidad.

### Gráficas de cuantiles teóricos

Supongamos que $G$ es la función de distribución de una variable aleatoria continua, tal que $G$ es diferenciable y tiene derivada positiva (por ejemplo, si la variable aleatoria tiene densidad positiva y continua en todos los reales). Entonces podemos construir la función $q:(0,1) \to (\infty, \infty)$ dada por: $$q(f)=G^{-1}(f)$$ para cualquier $f \in (0,1)$. Decimos que $q$ es la **función de cuantiles** de la variable aleatoria con distribución $G$. Bajo esta definición, es claro que si $X$ tiene distribución $G$, entonces $P(X<q(f))=G(q(f))=f$.

#### Ejemplo: normal
Abajo vemos cómo se ve la gráfica de cuantiles de una variable aleatoria normal estándar. A esta función la denotamos como $q_{0,1}(f)$, y en general, a la función de cuantiles de una distribución $Normal(\mu, \sigma^2)$ la denotamos por $q_{\mu, \sigma}(f)$.


```r
curve(qnorm, from = 0, to=1, n = 1000, xlab='Cuantil (f)', ylab='q')
```

<img src="04-tlc_files/figure-html/unnamed-chunk-11-1.png" width="70%" style="display: block; margin: auto;" />

Notemos que $q_{\mu, \sigma}(f) \to \infty$ cunado $f \to 1$, y el cuantil $1$ no esta definido. Análogamente el cuantil $0$ tampoco está definido.

<p class="espacio">
</p>

![](figuras/manicule2.jpg) 
<div class="centered">
<p class="espacio">
</p>
¿Cómo se ve la gráfica de cuantiles de una variable aleatoria uniforme?

(a) Similar al caso normal (una curva).

(b) Como una recta horizontal.

(c) Como una recta vertical.

(d) Como una diagonal.

<p class="espacio3">
</p>
</div>
<br>


### Gráficas de cuantiles para un conjunto de datos
Hay varias maneras razonables de definir los cuantiles de un conjunto de datos, (ver Hyndman y Fan 1996 para una resumen de lo que usan los paquetes estadísticos). Nosotros adoptamos la siguiente construcción:

<p class="espacio3">
</p>

\BeginKnitrBlock{nota}<div class="nota">**Cuantiles de un conjunto de datos.** Si $x_1,...,x_n$ es el conjunto de datos, 
los ordenamos de manera creciente para obtener $x_{(1)},...,x_{(n)}$, donde
$x_{(1)}$ es la observación más chica y $x_{(n)}$ la más grande.
Definimos
$$f_i=\frac{i-0.5}{n}$$
y decimos que $x_{(i)}$ es el cuantil $f_i$.
Si se deseara calcular otros cuantiles $f$, se podría interpolar o 
extrapolar con los puntos $x_{(1)},...,x_{(n)}$ y $f_1,...,f_n$, pero esto no tiene tanto sentido.</div>\EndKnitrBlock{nota}

<p class="espacio3">
</p>

**Ejemplo.** Consideremos el conjunto de datos $4,1,7,3,3,6,10$. Calcular 
$f_1,f_2,...,f_7$ según la definición de arriba.

<p class="espacio">
</p>

![](figuras/manicule2.jpg) 
<div class="centered">
<p class="espacio">
</p>
La distribución de ozono (en cualquier estación) es...

(a) 3

(b) 3.3  

(c) 3.6

(d) 4

<p class="espacio3">
</p>
</div>
<br>


\BeginKnitrBlock{information}<div class="information">**Acerca de nuestra definición de cuantiles.** Un argumento posible para justificar la definición de arriba es (Cleveland, 1994): supongamos que $x_i$ es resultado de redondeo, y los datos $x_1,...,x_n$ son distintos. Cuando contamos cuántas observaciones son menores o iguales a $x_i$, es igualmente probable que la observación *real* correspondiente está por arriba o por debajo de la medida $x_i$. En el primer caso, $x_i$ está por arriba de $(i-1)/n$ observaciones *reales*. En el segundo caso, $x_i$ está por arriba de $f\le i/n$ observaciones *reales*. Promediamos estos dos valores para obtener nuestra definición.</div>\EndKnitrBlock{information}

Otro argumento en favor de nuestra elección es la simetría en los valores $f$ de los cuantiles: el dato más grande es el cuantil $1-0.5/n$ que es complemento de $0.5/n$, que corresponde al cuantil del mínimo. 

Finalmente, notamos que bajo nuestra definición no hay cuantiles $0$ ni $1$. Esto es deseable cuando queremos comparar con densidades cuyos cuantiles teóricos $0$ y $1$ no están definidos.

Podemos hacer gráficas de la función de cuantiles de manera fácil. Estas gráficas se hacen, aproximadamente, como sigue: se ordenan los datos del más chico al más grande, se enumeran como índice, y graficamos los pares resultantes con el índice en el eje horizontal.


```r
library(ggplot2)
library(reshape2) # aquí están los datos de propinas
#> 
#> Attaching package: 'reshape2'
#> The following object is masked from 'package:tidyr':
#> 
#>     smiths
n <- length(tips$total_bill)
tips$probs <- (1:n - 0.5) / n
tips$cuantiles <- quantile(tips$total_bill, probs = tips$probs, type = 5) 
ggplot(tips, aes(x=probs, y = cuantiles)) + 
  xlab('Cuantil (f)') + 
  ylab('Dólares') + 
  geom_point()
```

<img src="04-tlc_files/figure-html/unnamed-chunk-14-1.png" width="70%" style="display: block; margin: auto;" />

#### ¿Qué buscar en una gráfica de cuantiles?
Las gráficas de cuantiles son conceptualmente simples; sin embargo, su interpretación efectiva requiere práctica. Algunas guías son:

1. Podemos leer fácilmente la mediana y los cuartos.

2. Regiones en la escala de medición de los datos (dimensión vertical) con densidades de datos más altas se ven como pendientes bajas en la gráfica. Mientras que pendientes altas indican densidades de datos relativamente más bajas.

3. Una mayor pendiente en la forma general de la gráfica (por ejemplo, en la recta que une los cuartos) indica dispersiones más grandes.

4. Si el conjunto de datos se distribuye aproximadamente uniforme, entonces la gráfica debe parecerse a una recta (diagonal).

5. De manera más general: en las regiones donde el histograma crece conforme aumentan los valores en el conjunto de datos, la pendiente de la gráfica de cuantiles es decreciente (así que la gráfica de cuantiles es cóncava hacia abajo). Cuando el histograma decrece conforme aumentan los valores en el conjunto de datos, la pendiente de la gráfica de cuantiles es creciente (así que observamos concavidad hacia arriba).

6. Si la distribución tiene más dispersión hacia la derecha, la figura general de la gráfica es cóncava hacia arriba. Si tiene más dispersión a la izquierda, es cóncava hacia abajo.

7. ¿Cómo se ve una distribución que parece tener grupos definidos donde se acumulan los datos?



### Diagramas de caja y brazos
Los diagramas de caja y brazos son muy populares, e intentan mostrar gráficamente algo similar al resumen de cinco números de Tukey:

</br>
<a href="https://upload.wikimedia.org/wikipedia/commons/thumb/2/25/Boxplot.svg/457px-Boxplot.svg.png">
<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/2/25/Boxplot.svg/457px-Boxplot.svg.png" width="300px">
<p>
Imagen de Wikipedia.
</p>
</a>
</br>

<!--
Los diagramas de caja y brazos también se pueden ver como una alternativa a las gráficas de cuantiles, donde un número limitado de cuantiles se utiliza para describir cada distribución.
-->

Como vemos en la imagen superior el método muestra la mediana como una línea horizontal (medida de tendencia central), los bordes de la caja indican los cuartiles inferior y superior (o cuantiles 0.25 y 0.75). La distancia entre estos dos se conoce como rango intercuartílico o *IQR* por sus siglas en inglés, el IQR es una medida de dispersión. Alrededor del 50\% de los datos están entre los cuartiles inferior y superior, es así que si el rango intercuartílico es chico los datos de enmedio están muy cercanos alrededor de la mediana, si el rango intercunatílico es grande los datos de enmedio están dispersos alrededor de la mediana. Adicionalmente, las distancias relativas de los cuartiles a lamediana nos dan información de la forma de la distribución, si una es mayor a la otra la distribucción está sesgada.

Las líneas punteadas del diagrama superior indican los *valores adyacentes*, el valor adyacente superior se calcula de la siguiente forma: se toma el dato más grande que está a no más de $1.5IQR$ del cuartil superior. Los valores adyacentes también nos dan un resumen de la forma y dispersión, pero lo hacen para los valores extremos, o colas de la distribución.

Finalmente, los datos mayores (o menores) a los valores adyacentes se grafican de manera individual como puntos. Si hay datos atípicos suelen aparecer como estos puntos graficados individualmente.

### Ejemplo {-}

En el caso de los cantantes obtenemos la siguiente gráfica:


```r
library(lattice)
# calculamos la estatura en centímetros
singer$estatura.m <- singer$height * 2.54
```

Veamos la estructura de los datos:


```r
singer %>% sample_n(10) %>% knitr::kable()
```

       height  voice.part    estatura.m
----  -------  -----------  -----------
143        68  Tenor 1              173
198        72  Bass 1               183
164        69  Tenor 2              175
150        68  Tenor 2              173
65         67  Soprano 2            170
172        70  Bass 1               178
190        68  Bass 1               173
161        71  Tenor 2              180
55         63  Soprano 2            160
107        66  Alto 2               168


```r
singer.medians <- singer %>%
  group_by(voice.part) %>%
  mutate(mediana = median(estatura.m))

ggplot(singer.medians, aes(x = voice.part, y = estatura.m)) + 
  geom_boxplot() +
  geom_jitter(position = position_jitter(height = 0, width = 0.2), 
    color = "darkgray") +
  geom_point(aes(y = mediana), colour = "red", size = 4) + 
  coord_flip()
```

<img src="04-tlc_files/figure-html/unnamed-chunk-18-1.png" width="70%" style="display: block; margin: auto;" />

---

<br>

<br>

Consideramos las siguientes mediciones de ozono en el aire, producidas por la red automática de monitoreo ambiental ([SIMA](http://www.aire.df.gob.mx/default.php?opc='aKBhnmI='&opcion=Zg==)). Las mediciones son concentración de ozono (en ppb o partes por billón) para las estaciones de Tlalnepantla e Iztapalapa, tomadas a las 2 pm, durante 2014. 

**Una exposición de 110 ppb durante una hora se considera aguda.**


```r
library(tidyr)
library(dplyr)
library(ggplot2)

# leemos la base de datos
contaminantes <- read.csv("datos/contaminantes_2014.csv", comment.char = "#", 
  stringsAsFactors = FALSE)
# creamos una variable hora
contaminantes <- mutate(contaminantes, 
  hora = substring(contaminantes$date, 12, 13))
# filtramos para obtener las estaciones y contaminantes de interés
ozono <- filter(contaminantes, id_parameter == "O3", hora == 14,
  id_station %in% c("TLA", "UIZ"))

ozono %>% sample_n(10) %>% knitr::kable()
```

      date               id_station   id_parameter    value   unit  hora 
----  -----------------  -----------  -------------  ------  -----  -----
690   11/12/2014 14:00   UIZ          O3                 60      1  14   
50    25/01/2014 14:00   UIZ          O3                 77      1  14   
597   26/10/2014 14:00   TLA          O3                 NA      1  14   
673   03/12/2014 14:00   TLA          O3                 57      1  14   
231   26/04/2014 14:00   TLA          O3                 96      1  14   
265   13/05/2014 14:00   TLA          O3                 83      1  14   
46    23/01/2014 14:00   UIZ          O3                101      1  14   
350   24/06/2014 14:00   UIZ          O3                 78      1  14   
30    15/01/2014 14:00   UIZ          O3                 44      1  14   
645   19/11/2014 14:00   TLA          O3                 68      1  14   

<br>
<br>

![](figuras/manicule.jpg)  ¿Qué se necesita hacer para limpar este conjuntos de datos?

<p class="espacio">
</p>
<br>

<img src="04-tlc_files/figure-html/unnamed-chunk-20-1.png" width="70%" style="display: block; margin: auto;" />

![](figuras/manicule2.jpg) 
<div class="centered">
<p class="espacio">
</p>
La distribución de ozono (en cualquier estación) es...

(a) Simétrica.  

(b) Tiene sesgo a la derecha. 

(c) Tiene sesgo a la izquierda. 

<p class="espacio3">
</p>
</div>
<br>

### Gráficas qq-normales

En las secciones anteriores hemos usado gráficas de cuantiles para graficar cuantiles de un conjunto de datos y cuantiles teóricos dada una función de distribución. También es posible hacer gráficas de conjuntos de datos contra cuantiles teóricos de una distribución, de manera que podamos visualizar el grado de concordancia entre estas dos.

La más popular de estas gráficas son las *cuantil-cuantil normales* (*q-q normales*). Una manera de hacer estas gráficas para el conjunto de datos $x_1,...,x_n$ es calcular:

$$\bar{x}=\frac{1}{n}\sum_{i=1}^n x_i, s=\sqrt{\frac{1}{n-1}\sum_{i=1}^n(x_i-\mu)^2}$$

y calcular los cuantiles $q_{\bar{x},s}(f)$ de la distribución $Normal(\bar{x},s)$. Entonces calculamos $q_{\bar{x},s}(f)$ donde $f_1,f_2,...,f_n$ son los cuantiles de los datos y graficamos $(x_{i},q_{\bar{x},s}(f_i))$. Si los puntos no se desvían mucho de la recta $x=y$, entonces el conjunto de datos se distribuye, aproximadamente, de manera normal. Las desviaciones de la recta se interpretan como arriba hicimos con la gráfica cuantil cuantil.

Cuando queremos evaluar si la forma de la distribución de los datos es cercana a la normal, no es necesario calcular $\bar{x}$ y $s$, pues para cualquier $\mu$ y $\sigma$ tenemos que:

$$q_{\mu, \sigma}(f) = \sigma q_{0,1}(f)+\mu,$$

lo que implica que si graficamos los cuantiles $q_{0,1}(f_i)$ contra los del conjunto de datos, los datos se distribuyen aproximadamente normal cuando están dispuestos cerca de una recta.

<p class="espacio3">
</p>

\BeginKnitrBlock{nota}<div class="nota">**Construcción de una gráfica normal de cuantiles.** Si los datos ordenados están dados por $x_{1},x_{2},...,x_{n}$, con valores $f$ correspondientes $f_1,f_2,...,f_n$, entonces graficamos los puntos $(q_{0,1},x_{i})$.</div>\EndKnitrBlock{nota}

<p class="espacio3">
</p>

#### Ejemplo: cantantes

En estas gráficas podemos ver:

1. Cada conjunto de datos es razonablemente bien aproximado por una distribución normal. Muchas de las desviaciones que observamos se deben a redondeo.

2. Aunque las medianas varían de grupo a grupo, las pendientes no varían mucho, esto quiere decir que las dispersiones (por ejemplo, desviaciones estándar) son similares a lo largo de todos los grupos.

3. La variación en la dispersión de cada conjunto de datos no está asociado a la mediana de cada uno.


```r
library(ggplot2)
library(lattice)
library(dplyr)
# calculamos la estatura en centímetros
singer$estatura.m <- singer$height * 2.54

# calculamos el valor f dentro de cada grupo
singer_ord <- arrange(group_by(singer, voice.part), estatura.m)
singer_cuant <- mutate(singer_ord, 
  n = n(), 
  valor.f = (1:n[1] - 0.5)/n[1],
  q.norm = qnorm(valor.f)
  )

ggplot(singer_cuant, aes(x = q.norm, y = estatura.m)) +
  geom_point() +
  facet_wrap(~voice.part, nrow = 2) +
  geom_smooth(method = "lm", se = FALSE)
```

<img src="04-tlc_files/figure-html/unnamed-chunk-22-1.png" width="70%" style="display: block; margin: auto;" />

---

<br>

<br>

### El TLC y errores estándar

La idea es ver como se aproxima la distribución muestral de la media (cuando las observaciones provienen de distintas distribuciones) a una Normal conforme aumenta el tamaño de muestra. Para esto, aproximamos la distribución muestral de la media usando simulación.

Vale la pena observar que hay distribuciones que requieren un mayor tamaño de muestra $n$ para lograr una buena aproximación (por ejemplo la log-normal), ¿a qué se debe esto?

¿Por qué tanto énfasis en el TLC? El __error estándar__ es la manera más común para describir la precisión de una estadística. En términos generales, esperamos que $\bar{x}$ este a una distancia de $\mu_P$ menor a un error estándar el 68% del tiempo, y a menos de 2 errores estándar el 95% del tiempo. Estos porcentajes están basados el teorema central del límite que nos dice que bajo ciertas condiciones (bastante generales) de $P$ la distribución de $\bar{x}$ se aproximará a una distribución normal:
$$\bar{x} \overset{\cdot}{\sim} N(\mu_P,\sigma_P^2/n)$$

---

<br>

#### Ley de los Grandes Números

En Noviembre del 2017 El Financiero [publicó](http://www.elfinanciero.com.mx/nacional/reprueban-entidades-estados-en-atencion-a-diabetes-ssa.html) una noticia que afirmab que los estados de Oaxaca, Michoacán, Morelos y Tamaulipas tenían la peor atención a pacientes diabéticos. 

El índice [ICAD](http://oment.uanl.mx/tablero-de-control-de-enfermedades/) mide el cuidado que se les da a los pacientes en las unidades de primer nivel, en todas sus jurisdicciones sanitarias. Además toma en cuenta tres aspectos principales: que se pueda retener al paciente, que se tenga acceso a pruebas diagnósticas y si tiene su diabetes controlada. 

Se cuenta con datos del ICAD de Noviembre del 2016:


```r
icad <- read_csv("datos/icad.csv")
icad %>% sample_n(10) %>% knitr::kable()
```

    fecha   cve_edo  cve_clues     nombre                    calificacion   pac_act
---------  --------  ------------  -----------------------  -------------  --------
 20161125        18  NTSSA000083   EL RECODO                         54.2        11
 20161125         7  CSSSA007330   JUNCANÁ                           39.3         3
 20161125        28  TSSSA002863   U02 COL S MARCOS                  65.1       107
 20161125        12  GRSSA004420   CSR QUETZALAPA                    45.0        12
 20161125        15  MCSSA004856   VILLA CUAUHTÉMOC                  74.5       160
 20161125        12  GRSSA007512   CSR TEHUIXTLA                     57.6        46
 20161125         7  CSSSA005551   S ANTONIO EL PARAJE               56.5        22
 20161125         4  CCSSA001075   CS LA VICTORIA                    64.0         9
 20161125        20  OCSSA000886   MONJAS                            56.9        63
 20161125        14  JCSSA001010   CS S JOSÉ CASAS CAIDAS            55.1        34

Cada unidad de salud o _CLUES_ recibe una calificación __promedio__ y tiene cierto número de pacientes diabéticos activos.

Un efecto interesante es que si vemos el promedio de calificación contra el número de pacientes activos vemos el siguiente fenómeno:


```r
ggplot(icad, aes(x=pac_act, y=calificacion)) + 
  geom_jitter(width = 0.1, height = 0.1) +
  scale_x_continuous(limits = c(0,400)) +
  geom_hline(yintercept = mean(icad$calificacion), color = 'red')
```

<img src="04-tlc_files/figure-html/unnamed-chunk-24-1.png" width="70%" style="display: block; margin: auto;" />

La línea roja representa la media nacional de la calificación promedio de todas las unidades del país. Podemos ver que conforme aumenta el número de pacientes en el hospital las observaciones tienden a acercarse más a la media poblacional.

Podemos simular la media para diferentes tamaños de muestra y ver cómo se comporta la media para varios tamaños de muestra. En los datos del ICAD la media nacional es de 58.867:


```r
set.seed(123456)
sim_media_normal <- function(n){
  media <- mean(rnorm(n = n, mean = 58.86661, sd = 11.12385))
  tibble(n=n, media=media)
}
sim_1 <- map_df(sample(1:500, 1000, replace = T), sim_media_normal)
```


```r
ggplot(sim_1, aes(x = n, y = media)) +
  geom_point() + 
  geom_hline(yintercept = mean(icad$calificacion), color = 'red')
```

<img src="04-tlc_files/figure-html/unnamed-chunk-26-1.png" width="70%" style="display: block; margin: auto;" />

Nuevamente se observa un fenómeno similar. Este fenómeno del error estándar generalmente se observa en la práctica y una buena estrategia para el modelado sería considerar el número de observaciones (pacientes, alumnos, escuelas) utilizados para calcular la media. 

<p class="espacio">
</p>

\BeginKnitrBlock{comentario}<div class="comentario">Alguien nos podría preguntar: ¿por qué debería el promedio acercarse a la media cuando aumentamos el tamaño de la muestra?". </div>\EndKnitrBlock{comentario}

<p class="espacio">
</p>

Debemos interpretar esta pregunta como preguntando por qué el error estándar de la media se reduce a medida que $n$ aumenta. El teorema del límite central muestra que (bajo ciertas condiciones, por supuesto) el error estándar debe hacer esto, y que la media se aproxima a una distribución normal. Pero la pregunta es ¿por qué? 


La mejor justificación simple puede ser que hay más formas de obtener valores _medios_ que valores extremos; por ejemplo, la media de un lanzamiento de un dado (distribución discreta uniforme en $1, 2, ..., 6$) es $3.5$. 

* Con un dado, es igualmente probable que obtengas un "promedio" de 3 o de 1. 

* Pero con dos dados hay cinco formas de obtener un promedio de 3, y solo una forma de obtener un promedio de 1. 

*Hay 5 veces más probabilidades de obtener el valor que está más cerca de la media que el que está más lejos.

Veamos esto con un ejercicio de simulación:


```r
set.seed(110265)
tira_dado <- function(i){
  res <- sample(x = 1:6, size = 1)
  tibble(lanzamiento=i, resultado=res)
}
```

Lanzamos el dado mil veces y calculamos el promedio en cada lanzamiento.


```r
sim_2 <- map_df(1:1000, tira_dado) %>%
  mutate(media = cummean(resultado))
sim_2 %>% head(5) %>% knitr::kable()
```



 lanzamiento   resultado   media
------------  ----------  ------
           1           3    3.00
           2           2    2.50
           3           5    3.33
           4           1    2.75
           5           5    3.20

Esto ocurre debido a la **Ley de los Grandes Números**:


```r
ggplot(sim_2, aes(x = lanzamiento, y = media)) + 
  geom_line() +
  geom_hline(yintercept = 3.5, color = 'red') + 
  scale_x_continuous(limits = c(2,1000)) +
  scale_y_continuous(limits = c(3.3,4.5))
#> Warning: Removed 2 rows containing missing values (geom_path).
```

<img src="04-tlc_files/figure-html/unnamed-chunk-30-1.png" width="70%" style="display: block; margin: auto;" />

### Tarea

La Evaluación Nacional de Logros Académicos en Centros Escolares (ENLACE), es un examen que se pretende realizar cada año en México por la Secretaria de Educación Pública (SEP) a todas las escuelas públicas y privadas de nivel básico; para conocer el nivel de desempeño en las materias de español y matemáticas. Han existido importantes resistencias a la aplicación de este examen y opiniones de intelectuales respecto de las fallas que esta tiene.

En este enlace la SEP publicó los resultados de la prueba ENLACE para todas las escuelas de los 32 estados de México: [http://www.enlace.sep.gob.mx/content/ba/pages/base_de_datos_completa_2013/](http://www.enlace.sep.gob.mx/content/ba/pages/base_de_datos_completa_2013/)

1. Descarga los datos para todas las localidades y cárgalos en R utilizando la función `map_df` del paquete `purrr`.

2. Explica si los datos cumplen los principios de datos limpios.

3. Haz la limpieza necesaria que requieran los datos.

4. Agrega los datos a nivel municipio para calcular el número de alumnos en cada grado y su promedio de puntos en español y matemáticas.

5. Haz una gráfica en la cual cada punto represente un municipio y en el eje x se muestre el número de alumnos que presentaron el examen y en el eje y el promedio de puntos en matemáticas.







