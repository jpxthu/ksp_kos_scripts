# 燃料

## 查看某一个燃料箱

1. 将需要关注的燃料箱打上 tag。如：tank1。

2. `set p to Ship:PartsTagged("tank1")[0].` 获取该部件（Part）。

3. 在 `Resources` 列表中查找需要关注的资源种类：
``` BASIC
for r in p:Resources {
    if r:Name = "LiquidFuel" {
        set l to r.
        break.
    }
}
print l:Amount.
```
