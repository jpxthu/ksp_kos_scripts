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
\begin{array} { }
    \cfrac{\partial \vec{a}(i)}{\partial E(j)} = \cfrac{\partial \vec{a}(i)}{\partial\theta(j)} = \boldsymbol{0}, & i \neq j
\end{array}
$$

速度变化：

$$
\Delta \vec{v}(i) = \sum_{k=0}^i \Delta \vec{a}(k)\Delta t
$$

$$
\begin{array} { }
    \cfrac{\partial \vec{v}(i)}{\partial E(j)} = \cfrac{\partial \vec{a}(j)}{\partial E(j)} \Delta t, & i \ge j
\end{array}
$$

$$
\begin{array} { }
    \cfrac{\partial\vec{v}(i)}{\partial\theta(j)} = \cfrac{\partial\vec{a}(j)}{\partial\theta(j)} \Delta t, & i \ge j
\end{array}
$$

位置变化：

$$
\Delta\vec{x}(i) = \sum_{k=0}^i \Delta\vec{v}(k)\Delta t = \sum_{k=0}^i (i-k)\Delta\vec{a}(k) \Delta t^2
$$

$$
\begin{array} { }
    \cfrac{\partial\vec{x}(i)}{\partial E(j)} = (i-j)\cfrac{\partial\vec{a}(j)}{\partial E(j)}\Delta t^2, & i \ge j
\end{array}
$$

$$
\begin{array} { }
    \cfrac{\partial\vec{x}(i)}{\partial\theta(j)} = (i-j)\cfrac{\partial\vec{a}(j)}{\partial\theta(j)}\Delta t^2, & i \ge j
\end{array}
$$

质量变化：

$$
\begin{aligned}
    \cfrac{\partial m(i)}{\partial E(j)} &= - FuelRate \cdot \Delta E(j) \Delta t, & i \ge j \\
    \cfrac{\partial m(i)}{\partial \theta(j)} &= 0
\end{aligned}
$$

优化目标：

$$
\min \Rightarrow C_{vx}\left(v_x - v_{x,tar}\right)^2 + C_{vy}v_y^2 + C_h\left(h - h_{tar}\right)^2 - C_mm + \sum 
$$