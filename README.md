# Another Balatro（重写版）

体验改良模组：对 62 个原版小丑进行数值 / 稀有度 / 机制重做。**本目录是对原
`AnotherBalatro` 的代码质量重写**，所有效果与原模组保持一致，仅改进实现方式。

## 与原版实现的差异

原版把全部机制塞进一个巨大的 `Card:calculate_joker` 全局劫持函数里，按
`ability.name` 字符串分派。这份重写改为逐张小丑调用
`SMODS.Joker:take_ownership(key, { calculate = ..., loc_vars = ..., ... })`，
和 Brook 里各张小丑的写法一致：

- **`calculate`** 挂在小丑对象自己身上：SMODS 已经在
  `Card:calculate_joker` 里内置了 `obj.calculate(self, card, context)` 调用
  （见 `smods/lovely/center.toml`），不需要再自己重复劫持一次。
- **`loc_vars`** 同理挂在对象上，取代原来集中式的
  `Card:generate_UIBox_ability_table` 包装。
- **`add_to_deck` / `remove_from_deck`** 用于"入场生效一次"（鸡蛋/冰激凌的
  售价调整、小丑的负片、Turtle Bean 清零基础手牌上限）或"离场时收尾"
  （恐怖面孔按 Brook「低俗小说」模式释放暂存的弃牌），不再需要额外的全局
  hook。
- 只有真正**跨卡牌共享**的机制才保留全局 hook：
  - `CardArea:add_to_highlighted` / `G.FUNCS.can_play`（飞溅：可勾选任意张
    手牌）；
  - `draw_card` / `G.FUNCS.draw_from_discard_to_deck`（恐怖面孔：弃掉的人头
    牌不回牌库）；
  - `Card:get_chip_h_x_mult`（男爵：手牌中的 K 视为钢铁牌）；
  - `Back:trigger_effect` 的 `final_scoring_step`（跑步选手 / 石头小丑 /
    回溯：整局筹码·倍率的最终结算步骤）。

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

> 注意：本模组与原始 `AnotherBalatro` 使用相同的 `MOD_ID`（`AnotherBalatro`）
> 和 `PREFIX`（`anba`），是对其的正式替代，**不要同时启用两者**。

## 说明与取舍（与原版一致）

- 复制类小丑（蓝图 / 头脑风暴）能正确复制**烧焦小丑、回溯、石头小丑、跑步
  选手**的效果：这几张牌的重做实现被搬到了 `calculate` 之外（延迟到结算末
  步），按"来源卡"（本体，或把它自己那一趟 `calculate` 转交给该小丑的复制
  者）计数，与「复制者会把被复制小丑的 `calculate` 再跑一遍」的原版行为
  等价。
- 烧焦小丑的计数以**每种牌型每回合的首次弃牌事件**为准：该次事件中在场的
  本体与复制者各升级 1 级；之后再弃同一牌型、或中途给蓝图换目标，都不再
  补升级。
- 需要的话可以在 `numeric_jokers.lua` 与各 `jokers_*.lua` 中自行微调数值。
