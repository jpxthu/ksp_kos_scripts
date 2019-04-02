根据 $t(i)$ 时刻高度 $h(i)$ 估计气压 $P(i)$，算出最大推力 $F_{max}(i)$。

推力加速度：

$$
a_f(i) = E(i)F_{max}(i)/m(i)
$$

重力加速度：

$$
g(i) = \cfrac{MU}{\left[h(i)+R\right]^2}
$$

向心加速度：

空气阻力加速度：

合加速度：

$$
\begin{aligned}
    a_x(i) &= a_f(i)\sin\theta(i) \\
    a_y(i) &= a_f(i)\cos\theta(i) - g(i)
\end{aligned}
$$

速度：

$$
\begin{aligned}
    \vec{v} &= \int \vec{a}dt \\
    \vec{v}(i) &= \left[\begin{array} { }
        v_x(i) \\ 
        v_y(i)
    \end{array}\right] = \left[\begin{array} { }
        v_x(i-1) + a_x(i)dt \\
        v_y(i-1) + a_y(i)dt
    \end{array}\right]
\end{aligned}
$$

位置：

$$
\begin{aligned}
    \vec{p} &= \int \vec{v}dt \\
    h(i) &= h(i-1) + v(i)dt
\end{aligned}
$$

质量：

$$
\begin{aligned}
    m(i) = m(i-1) + FuelRate \cdot E(i)dt
\end{aligned}
$$
