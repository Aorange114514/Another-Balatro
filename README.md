# Another Balatro
体验改良模组：对 62 个原版小丑进行数值 / 稀有度 / 机制重做。

## 目录结构

```
AnotherBalatroRework.lua      # 主文件：HEADER + 加载 src/ 下各文件
src/
  helpers.lua                 # 共享小工具（ABR 命名空间）
  numeric_jokers.lua          # 纯数值/稀有度覆盖（保留原版硬编码效果）
  jokers_a.lua                # 重做小丑 A 组（普通~罕见稀有度为主）
  jokers_b.lua                # 重做小丑 B 组（罕见~传说稀有度为主）
  mechanics.lua               # 无法挂在单张小丑上的全局机制
  final_scoring.lua           # 结算末步的筹码/倍率乘算（配合触发计数）
localization/
  en-us.lua / zh_CN.lua       # 与原模组一致的英文/中文文案
```

## 安装

1. 需要 [Steamodded (SMODS)](https://github.com/Steamodded/smods)。
2. 将整个 `AnotherBalatroRework` 文件夹放入游戏的 `Mods` 目录。
3. 启动游戏，在 SMODS 模组菜单中启用即可。
