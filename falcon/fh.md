# Falcon Heavy 猎鹰重型

- 每个部分需要装配 CPU、加速度传感器、气压计、温度计、电池。每个 CPU 运行不同的脚本，其中 `boot` 目录下有自启动脚本。
- 需要在坎巴拉太空中心发射。

## 主火箭

起飞时火箭功率较小，节省燃料，比助推火箭燃烧更久。降落在海上。

配两个 CPU：
1. Tag 为 `cpuMain`，运行脚本 `fh_main`，主管助推火箭的分离、主火箭分离和回收。
2. Tag 为 `cpuMainImpact`，运行脚本 `fh_main_impact`，运算落地轨道并发送给主 CPU。

## 副火箭（北）

返回发射台北边几十米处的平地上，两条白线交叉处。

配两个 CPU：
1. Tag 为 `cpuNorth`，运行脚本 `fh_north`，主管助推火箭的回收。
2. Tag 为 `cpuNorthImpact`，运行脚本 `fh_north_impact`，运算落地轨道并发送给主 CPU。

## 副火箭（南）

返回发射台南边几十米处的平地上，两条白线交叉处。

配两个 CPU：
1. Tag 为 `cpuSouth`，运行脚本 `fh_South`，主管助推火箭的回收。
2. Tag 为 `cpuSouthImpact`，运行脚本 `fh_South_impact`，运算落地轨道并发送给主 CPU。

## 载荷

配一个 CPU，Tag 随意，运行脚本 `fh_load`，负责火箭入轨。

初始点火（Stage）和发射架分离需要手动操作，之后全自动。可以在脚本内自行修改。
