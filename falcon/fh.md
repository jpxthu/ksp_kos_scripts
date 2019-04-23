# Falcon Heavy 猎鹰重型

- 每个部分需要装配 CPU、加速度传感器、气压计、温度计、电池。每个 CPU 运行不同的脚本，其中 `boot` 目录下有自启动脚本。
- 需要在坎巴拉太空中心发射。

## 主火箭

起飞时火箭功率较小，节省燃料，比助推火箭燃烧更久。助推火箭分离后开启全功率。降落在海上。

燃料箱 tag 为 `ftMain`，发动机 tag 为 `egMain`。

配两个 CPU：
1. Tag 为 `cpuMain`，运行脚本 `fh_main`，主管助推火箭的分离、主火箭分离和回收。
2. Tag 为 `cpuMainImpact`，运行脚本 `fh_main_impact`，运算落地轨道并发送给主 CPU。

## 副火箭（北）

返回发射台北边几十米处的平地上，两条白线交叉处。

燃料箱 tag 为 `ftNorth`。

配两个 CPU：
1. Tag 为 `cpuNorth`，运行脚本 `fh_north`，主管助推火箭的回收。
2. Tag 为 `cpuNorthImpact`，运行脚本 `fh_north_impact`，运算落地轨道并发送给主 CPU。

## 副火箭（南）

返回发射台南边几十米处的平地上，两条白线交叉处。

燃料箱 tag 为 `ftSouth`。

配两个 CPU：
1. Tag 为 `cpuSouth`，运行脚本 `fh_South`，主管助推火箭的回收。
2. Tag 为 `cpuSouthImpact`，运行脚本 `fh_South_impact`，运算落地轨道并发送给主 CPU。

## 载荷

配一个 CPU，tag 随意，运行脚本 `fh_load`，负责火箭入轨和对接。脚本初始等待 30 秒，是我预留的提前量，用来指定对接目标、调整视角，方便录像。

## 太空舱

对接口 tag 为 `p0`。可以在 `fh_load.ks` 中修改。

配一个 CPU，tag 随意，运行脚本 `fh_pot`，负责起飞点火、打开发射架，出大气层后抛整流罩、打开对接口。

## 太空站

很久之前自己发射的太空站。目标对接口 tag 为 `p1`，发射之后也可以更改。可以在 `fh_load.ks` 中修改。
