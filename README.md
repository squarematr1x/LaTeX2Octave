# LaTeX2Octave

Turning LateX string to normal string to be able perform numerical calculations in Octave.

### Some examples

```
>> latex2oct("sin\left(\frac{ln\left(x\right)}{3+a}\right)")
ans = sin((log(x))/(3+a))

>> latex2oct("2pi+sqrt\left(\frac{-4a}{3b}\right)\cdot c")
ans = 2*pi+sqrt((-4*a)/(3*b))*c

>> latex2oct("a^{\frac{sin\left(3pi\right)}{cos\left(2pi\right)}}\times b")
ans = a^((sin(3*pi))/(cos(2*pi)))*b
```
