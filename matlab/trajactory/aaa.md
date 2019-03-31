$E$ 表示 `Throttle`，$F_{max}$ 表示`最大推力（Thrust）`。

加速度变化：

$$
\Delta \vec{a}(i) = \left[\begin{array} { }
    \Delta a_x(i) \\
    \Delta a_y(i)
\end{array}\right] = \Delta E(i) \cfrac{F_{max}(i)}{m(i)} \left[\begin{array} { }
    \sin\left[\theta(i) + \Delta\theta(i)\right] \\
    \cos\left[\theta(i) + \Delta\theta(i)\right]
\end{array}\right]
$$

$$
\cfrac{\partial \vec{a}(i)}{\partial E(i)} = \cfrac{F_{max}(i)}{m(i)} \left[\begin{array} { }
    \sin\left[\theta(i) + \Delta\theta(i)\right] \\
    \cos\left[\theta(i) + \Delta\theta(i)\right]
\end{array}\right]
$$

$$
\cfrac{\partial \vec{a}(i)}{\partial\theta(i)} = \Delta E(i) \cfrac{F_{max}(i)}{m(i)} \left[\begin{array} { }
    \cos\left[\theta(i) + \Delta\theta(i)\right] \\
    -\sin\left[\theta(i) + \Delta\theta(i)\right]
\end{array}\right]
$$

$$
\begin{aligned}
    \cfrac{\partial \vec{a}(i)}{\partial E(j)} = \cfrac{\partial \vec{a}(i)}{\partial\theta(j)} = \boldsymbol{0}, & & i \neq j
\end{aligned}
$$

速度变化：

$$
\Delta \vec{v}(i) = \sum_{k=0}^i \Delta \vec{a}(k)\Delta t
$$

$$
\begin{aligned}
    \cfrac{\partial \vec{v}(i)}{\partial E(j)} = \cfrac{\partial \vec{a}(j)}{\partial E(j)} \Delta t, & & i \ge j
\end{aligned}
$$

$$
\begin{aligned} { }
    \cfrac{\partial\vec{v}(i)}{\partial\theta(j)} = \cfrac{\partial\vec{a}(j)}{\partial\theta(j)} \Delta t, & & i \ge j
\end{aligned}
$$

位置变化：

$$
\Delta\vec{x}(i) = \sum_{k=0}^i \Delta\vec{v}(k)\Delta t = \sum_{k=0}^i (i-k)\Delta\vec{a}(k) \Delta t^2
$$

$$
\begin{aligned} { }
    \cfrac{\partial\vec{x}(i)}{\partial E(j)} = (i-j)\cfrac{\partial\vec{a}(j)}{\partial E(j)}\Delta t^2, & & i \ge j
\end{aligned}
$$

$$
\begin{aligned} { }
    \cfrac{\partial\vec{x}(i)}{\partial\theta(j)} = (i-j)\cfrac{\partial\vec{a}(j)}{\partial\theta(j)}\Delta t^2, & & i \ge j
\end{aligned}
$$

质量变化：