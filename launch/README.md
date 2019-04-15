# 发射

## 发射到圆形轨道

``` VB
runpath("launch_into_circle_orbit", tarHeight).
```

### 参数

- `tarHeight`：轨道高度（米）；Kerbin 大气层高度为 70000 m。

### 需求

- 气压计（`Ship:Sensors:Pres`）。

### 注意

- 需要手动分离（`Stage`）。
- 在滑行时会显示预期点火时间，可以加速时间。

### 思路

- 根据远地点高度调节火箭姿态。
- 根据 MaxQ 调整油门。
- 远地点到达预定高度后，滑行至远地点之前机动。
