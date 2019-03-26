# 阻力（Drag）

> 本页含有 LaTeX 公式，GitHub 暂不支持，原公式可前往[引用网页](#参考文献)查看。

因为飞行姿态原因，一般火箭飞行时受到空气阻力影响远大于升力。阻力与空气密度、飞行速度和飞行器形状有关：

$$
F_D = \cfrac{1}{2} \rho v^2 C_D A \tag{1}
$$

其中：
- $F_D$ 为`阻力`，是施力平行流场方向的分量；
- $\rho$ 为`空气密度（Density）`，KSP 中的空气严格遵循`理想气体（状态）方程（Ideal Gas Law）`，其中：
  - $p$ 为气压（Pressure）；
  - $R$ 为`个别气体常数（Specific Gas Constant）`，287.053 $J \cdot kg^{-1} \cdot K^{-1}$；
  - $T$ 为热力学温度。
$$
\rho = \cfrac{p}{RT} \tag{2}
$$
- $v$ 是`流体相对物体的速度（Velocity）`，KSP 中可以用飞行器速度；
- $C_D$ 是`阻力系数（Drag Coefficient）`，是一个无量纲的系数；
- $A$ 为`参考面积`。

## 阻力系数（Drag Coefficient）

超音速时会激增，跟材质和外形等有关，通常靠实验得出。暂时没有找到现成的数据，外形不同的火箭都需要实测（整流罩内载荷不受影响）。

对于某个确定的飞行器，$C_D$ 仅和马赫数 $N_M$ 有关：

$$
N_M = v/c \tag{3}
$$

其中 $c$ 为`音速（Speed of Sound）`，可以计算得到

$$
c = \sqrt{1.4 \cdot R \cdot T} \tag{4}
$$

将公式 2、3、4 带入公式 1，得到

$$
F_D = \cfrac{p N_M^2 C_D A}{2.8 R^2 T^2} = C_R\cfrac{p N_M^2}{T^2} \tag{6}
$$

$F_D$ 可以通过加速度计、推力、重力、离心力、火箭质量算出，相关量在安装气压计、温度计、加速度计（双 C 地震仪）后在 kOS 中可以直接拿到。这样可以得到离散的 $C_R$ 结果，拟合/平滑后得到近似结果 $C_R(N_M)$。这样在知道气压、温度、速度后，就可以估算出阻力。

在 KSP 中试飞 [Tundra](https://forum.kerbalspaceprogram.com/index.php?/topic/166915-16x-tundra-exploration-v1305-march-6th-spacex-falcon-9-dragon-v2-and-starship/) 的 Nose 得到的数据和下图中 Round Nose 很像：

![](http://www.braeunig.us/space/pics/cd.gif)

## 参考文献

[1] **Atmosphere**, KSP Wiki, [https://wiki.kerbalspaceprogram.com/wiki/Atmosphere](https://wiki.kerbalspaceprogram.com/wiki/Atmosphere).

[2] **The Drag Coefficient**, NASA, [https://www.grc.nasa.gov/www/k-12/rocket/dragco.html](https://www.grc.nasa.gov/www/k-12/rocket/dragco.html).

[3] **The Drag Equation**, NASA, [https://www.grc.nasa.gov/www/k-12/rocket/drageq.html](https://www.grc.nasa.gov/www/k-12/rocket/drageq.html).

[4] **阻力系数**, 维基百科, [https://zh.wikipedia.org/zh-hans/阻力係數](https://zh.wikipedia.org/zh-hans/阻力係數).

[5] **阻力方程**, 维基百科, [https://zh.wikipedia.org/wiki/阻力方程](https://zh.wikipedia.org/wiki/阻力方程).
