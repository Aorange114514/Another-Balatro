# Another Balatro

体验改良模组：对 62 个原版小丑进行数值 / 稀有度 / 机制重做。

## 安装
1. 需要 [Steamodded (SMODS)](https://github.com/Steamodded/smods)。
2. 将整个 `AnotherBalatro` 文件夹放入游戏的 `Mods` 目录。
3. 启动游戏，在 SMODS 模组菜单中启用即可。

## 内容概要（对照 request.txt）
- 稀有度 / 售价 / 默认数值调整：直接覆盖中心数据（`rarity`、`cost`、`config`），
  新生成的小丑即采用新数值。
- 行为 / 机制重做：以包装 `Card:calculate_joker` 的方式按 `ability.name` 拦截原版
  硬编码逻辑（与 SteelJokerRework 同思路），全部效果在
  `AnotherBalatro.lua` 的 `REWORK` 表中实现。
- 累积/计数类小丑的描述已加「(当前 X) /（当前 #）」，并在
  `Card:generate_UIBox_ability_table` 中提供自定义 tooltip 变量。
- 本地化：`localization/en-us.lua`（英文）、`localization/zh_CN.lua`（中文）。

## 说明与取舍
- 复制类小丑（蓝图 / 头脑风暴）现在能正确复制**烧焦小丑、回溯、石头小丑、跑步选手**的
  效果：这几张牌的重做实现被搬到了 `Card:calculate_joker` 之外（延迟到结算末步），
  模组按"来源卡"（本体，或把它自己那一趟 `calculate_joker` 转交给该小丑的复制者）
  计数，与「复制者会把被复制小丑的 `calculate_joker` 再跑一遍」的原版行为等价。
- 烧焦小丑的计数以**每种牌型每回合的首次弃牌事件**为准：该次事件中在场的本体与复制者
  各升级 1 级；之后再弃同一牌型、或中途给蓝图换目标，都不再补升级（避免出现"本体没
  升级、复制者却升级"的错位结算）。
- 需求 #1 / #11 / #12 等涉及“负片、钢铁重触发、不回牌组”的机制以最简单可靠的
  方式实现（自动 set_edition negative、repetition 上下文、回合末移除）。
- 个别含“幂 / 筹码倍率”的需求（#20 跑步选手、#44 石头小丑、
  #51 回溯）在“最终结算步”统一结算。
- 需要的话可以在 `CONFIG_OVERRIDES` 与 `REWORK` 中自行微调数值。
