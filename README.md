# LaTeX2Octave

Turning LateX string to normal string to perform numerical calculations in Octave.

### Some examples:

![eq1](https://github.com/squarematr1x/LaTeX2Octave/blob/master/equations/eq1.png?raw=true)

```
>> latex2oct("sin\left(\frac{ln\left(x\right)}{3+a}\right)")
ans = sin((log(x))/(3+a))
```

![eq2](https://github.com/squarematr1x/LaTeX2Octave/blob/master/equations/eq2.png?raw=true)

```
>> latex2oct("2pi+sqrt\left(\frac{-4a}{3b}\right)\cdot c")
ans = 2*pi+sqrt((-4*a)/(3*b))*c
```
![eq3](https://github.com/squarematr1x/LaTeX2Octave/blob/master/equations/eq3.png?raw=true)

```
>> latex2oct("a^{\frac{sin\left(3pi\right)}{cos\left(2pi\right)}}\times b")
ans = a^((sin(3*pi))/(cos(2*pi)))*b
```
![eq4](https://github.com/squarematr1x/LaTeX2Octave/blob/master/equations/eq4.png?raw=true)

```
>> latex2oct("\sqrt[a]{ln\left(x\right)+sin\left(pi\right)}\cdot \sqrt{\frac{r}{3pi}}")
ans = nthroot((log(x)+sin(pi)),a)*sqrt((r)/(3*pi))
```

### How to use in Octave:

Assign values to desired variables:

```
>> x = 4.5;
>> y = 3.2;
```

Call latex2oct funtion with the chosen LaTeX string:

```
>> latex2oct("ln\left(\sqrt{x}\right)\cdot 2y")
ans = log(sqrt(x))*2*y
```

Copy the answer and calculate the final result:

```
>> log(sqrt(x))*2*y
ans =  4.8130
```
