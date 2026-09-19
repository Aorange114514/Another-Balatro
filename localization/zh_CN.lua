return {
    descriptions = {
        Joker = {
            j_joker = {
                name = '小丑',
                text = {
                    '{C:mult}+#1#{}倍率',
                    '此小丑始终为{C:dark_edition}负片{}效果',
                    '{C:inactive}（{C:attention}+1{C:inactive}个小丑栏位）',
                },
            },
            j_half = {
                name = '半张小丑',
                text = {
                    '如果计分的牌不超过{C:attention}#2#{}张，',
                    '获得{C:mult}+#1#{}倍率',
                },
            },
            j_stencil = {
                name = '模具小丑',
                text = {
                    '每个空的{C:attention}小丑牌{}槽位提供',
                    '{C:chips}+10{}筹码与{X:mult,C:white}X1.5{}倍率',
                    '{s:0.8}模具小丑自身算作空位',
                    '{C:inactive}（当前为{C:attention}#1#{C:inactive}个空位）',
                },
            },
            j_ceremonial = {
                name = '仪式匕首',
                text = {
                    '在选择{C:attention}盲注{}时，摧毁右侧的小丑牌，',
                    '并将其售价的{C:attention}3倍{}永久添加至这张牌的{C:mult}倍率{}',
                    '{C:inactive}（当前为{C:mult}+#1#{C:inactive}倍率）',
                },
            },
            j_banner = {
                name = '旗帜',
                text = {
                    '每个剩余{C:attention}弃牌{}次数',
                    '使{C:mult}倍率{}乘以{X:mult,C:white}X1{}',
                    '{C:inactive}（总倍率 = 1 + 剩余弃牌数）',
                },
            },
            j_marble = {
                name = '大理石小丑',
                text = {
                    '每个{C:attention}盲注{}的第一张计分牌',
                    '变为{C:attention}石头牌{}',
                },
            },
            j_loyalty_card = {
                name = '积分卡',
                text = {
                    '每打出一手牌，给予{X:mult,C:white}X#1#{}倍率，',
                    '随后该倍率增加{C:attention}X0.5{}；',
                    '若增加后超过{C:attention}X4{}，则重置为{X:mult,C:white}X0.5{}',
                    '{C:inactive}（当前为{X:mult,C:white}X#1#{C:inactive}）',
                },
            },
            j_8_ball = {
                name = '八号球',
                text = {
                    '每张计分的{C:attention}8{}有',
                    '{C:green}#1#/#2#{}几率生成一张',
                    '{C:tarot}塔罗牌{}',
                    '{C:inactive}（必须有空位）',
                },
            },
            j_misprint = {
                name = '印错小丑',
                text = { '' },
            },
            j_fibonacci = {
                name = '斐波那契',
                text = {
                    '计分的{C:attention}A{}、2、3、5、8每张',
                    '给予{C:mult}+#1#{}倍率与{C:chips}+20{}筹码',
                },
            },
            j_steel_joker = {
                name = '钢铁小丑',
                text = {
                    '留在手牌中的{C:attention}钢铁牌{}会额外触发一次；',
                    '每触发一次，此小丑永久获得{C:mult}+5{}倍率',
                    '{C:inactive}（当前为{C:mult}+#1#{C:inactive}倍率）',
                },
            },
            j_scary_face = {
                name = '恐怖面孔',
                text = {
                    '你打出的人头牌不再返回牌组',
                    '{C:inactive}（直到此小丑被售出或摧毁）',
                },
            },
            j_even_steven = {
                name = '偶数史蒂文',
                text = {
                    '点数为{C:attention}偶数{}的计分牌每张给予',
                    '{X:mult,C:white}X1.1{}倍率',
                    '{C:inactive}（10、8、6、4、2）',
                },
            },
            j_odd_todd = {
                name = '奇数托德',
                text = {
                    '点数为{C:attention}奇数{}的计分牌每张给予',
                    '{X:chips,C:white}X1.5{}筹码',
                    '{C:inactive}（A、9、7、5、3）',
                },
            },
            j_scholar = {
                name = '学者',
                text = {
                    '打出的{C:attention}A{}牌在计分时给予',
                    '{X:mult,C:white}X1.5{}倍率与{X:chips,C:white}X1.5{}筹码',
                },
            },
            j_supernova = {
                name = '超新星',
                text = {
                    '将{C:attention}牌型{}在本赛局内被打出过的次数',
                    '添加至{C:mult}倍率{}，并额外获得其{C:chips}#1#倍{}的筹码',
                    '{C:inactive}（上一手牌型：{C:attention}#4#{C:inactive}，',
                    '{C:inactive}{C:mult}+#2#{C:inactive}倍率、{C:chips}+#3#{C:inactive}筹码）',
                },
            },
            j_ride_the_bus = {
                name = '搭乘巴士',
                text = {
                    '连续打出没有计分{C:attention}人头牌{}的牌时，',
                    '此小丑获得{C:mult}+#1#{}倍率；打出人头牌时重置',
                    '{C:inactive}（当前为{C:mult}+#2#{C:inactive}倍率）',
                },
            },
            j_space = {
                name = '太空小丑',
                text = {
                    '{C:green}#1#/#2#{}几率升级',
                    '打出的{C:attention}牌型{}',
                },
            },
            j_egg = {
                name = '鸡蛋',
                text = {
                    '在回合结束时，此牌的{C:attention}售价{}增加{C:money}$#1#{}',
                    '{C:inactive}（起始售价提高{C:money}$3{C:inactive}）',
                },
            },
            j_burglar = {
                name = '窃贼',
                text = {
                    '在选择{C:attention}盲注{}时，获得{C:blue}+#1#{}次出牌',
                    '并将{C:red}弃牌{}次数归零',
                },
            },
            j_runner = {
                name = '跑步选手',
                text = {
                    '每打出一次{C:attention}顺子{}，',
                    '此小丑的筹码乘以{X:chips,C:white}X#2#{}',
                    '{C:inactive}（当前为{X:chips,C:white}X#1#{C:inactive}）',
                },
            },
            j_ice_cream = {
                name = '冰淇淋',
                text = {
                    '{C:chips}+#1#{}筹码',
                    '每打出一手牌失去{C:chips}#2#{}筹码，归零时融化',
                    '{C:inactive}（起始售价降低{C:money}$1{C:inactive}）',
                },
            },
            j_splash = {
                name = '飞溅',
                text = {
                    '打出的所有牌都计入计分',
                    '你可以打出任意张数的手牌',
                },
            },
            j_blue_joker = {
                name = '蓝色小丑',
                text = {
                    '牌组中每张牌给予',
                    '{C:chips}+#1#{}筹码',
                    '{C:inactive}（当前为{C:chips}+#2#{C:inactive}筹码）',
                },
            },
            j_hiker = {
                name = '徒步者',
                text = {
                    '计分的每张牌永久获得',
                    '{C:chips}+#1#{}筹码',
                },
            },
            j_green_joker = {
                name = '绿色小丑',
                text = {
                    '每打出一手牌，此小丑获得{C:mult}+#1#{}倍率',
                    '每弃一次牌，此小丑获得{C:mult}+#2#{}倍率',
                    '{C:inactive}（当前为{C:mult}+#3#{C:inactive}倍率）',
                },
            },
            j_superposition = {
                name = '叠加态',
                text = {
                    '如果打出的牌中包含一张{C:attention}A{}，',
                    '以及一张{C:attention}K{}或{C:attention}2{}，',
                    '生成一张{C:tarot}塔罗牌{}',
                    '{C:inactive}（必须有空位）',
                },
            },
            j_todo_list = {
                name = '待办清单',
                text = {
                    '打出你{C:attention}最少使用{}的牌型时，',
                    '获得{C:money}$#1#{}',
                    '{C:inactive}（当前为：{C:attention}#2#{C:inactive}）',
                },
            },
            j_cavendish = {
                name = '卡文迪什',
                text = {
                    '{X:mult,C:white}X3{}倍率',
                    '此小丑不会在回合结束时自毁',
                },
            },
            j_card_sharp = {
                name = '老千小丑',
                text = {
                    '若打出的牌型与本回合{C:attention}上次打出的牌型{}相同，',
                    '获得{X:mult,C:white}X#2#{}倍率，每重复一次+1；',
                    '否则重置为{X:mult,C:white}X1{}',
                    '{C:inactive}（当前为{X:mult,C:white}X#2#{C:inactive}，',
                    '{C:inactive}上次牌型：{C:attention}#1#{C:inactive}）',
                },
            },
            j_red_card = {
                name = '红牌',
                text = {
                    '每跳过任一{C:attention}补充包{}，',
                    '此小丑获得{C:mult}+#1#{}倍率',
                    '{C:inactive}（当前为{C:mult}+#2#{C:inactive}倍率）',
                },
            },
            j_madness = {
                name = '疯狂',
                text = {
                    '在选择{C:attention}小盲注{}或{C:attention}大盲注{}时，',
                    '此小丑获得{X:mult,C:white}X#1#{}倍率，',
                    '并摧毁一张随机{C:attention}小丑牌{}',
                    '{C:inactive}（当前为{X:mult,C:white}X#2#{C:inactive}倍率）',
                },
            },
            j_square = {
                name = '方形小丑',
                text = {
                    '打出正好{C:attention}4{}张牌时，',
                    '此小丑获得{C:chips}+#2#{}筹码',
                    '{C:inactive}（当前为{C:chips}+#1#{C:inactive}筹码）',
                },
            },
            j_seance = {
                name = '通灵',
                text = {
                    '打出要求的牌型时生成一张',
                    '{C:spectral}幻灵牌{}；要求的牌型每回合改变',
                    '{C:inactive}（当前为{C:attention}#1#{C:inactive}，必须有空位）',
                },
            },
            j_vampire = {
                name = '吸血鬼',
                text = {
                    '你打出的{C:attention}所有{}增强牌都会变成普通牌；',
                    '每张使此小丑永久获得{X:mult,C:white}+X0.1{}倍率',
                    '{C:inactive}（当前为{X:mult,C:white}X#1#{C:inactive}倍率）',
                },
            },
            j_vagabond = {
                name = '流浪者',
                text = {
                    '若你在出牌时资金不超过{C:money}$4{}，',
                    '生成一张{C:dark_edition}负片{}版{C:tarot}塔罗牌{}',
                    '{C:inactive}（必须有空位）',
                },
            },
            j_baron = {
                name = '男爵',
                text = {
                    '手牌中的每张{C:attention}K{}视为{C:attention}钢铁牌{}，',
                    '并额外触发一次',
                    '{C:inactive}（手牌中与打出时都生效）',
                },
            },
            j_obelisk = {
                name = '方尖石塔',
                text = {
                    '每打出一手不是你{C:attention}最常用牌型{}的牌，',
                    '此小丑获得{X:mult,C:white}X#1#{}倍率；',
                    '打出最常用牌型则重置',
                    '{C:inactive}（当前为{X:mult,C:white}X#2#{C:inactive}倍率）',
                },
            },
            j_midas_mask = {
                name = '迈达斯面具',
                text = {
                    '你打出的所有{C:attention}人头牌{}',
                    '都会在打出时变为{C:attention}黄金牌{}',
                },
            },
            j_photograph = {
                name = '照片',
                text = {
                    '每手牌中第一张计分的{C:attention}人头牌{}',
                    '给予{X:mult,C:white}X2{}倍率',
                },
            },
            j_turtle_bean = {
                name = '黑龟豆',
                text = {
                    '携带此小丑击败{C:attention}Boss盲注{}时，',
                    '获得{C:attention}+1{}手牌上限',
                    '{C:inactive}（当前额外{C:attention}+#1#{C:inactive}手牌上限）',
                },
            },
            j_erosion = {
                name = '侵蚀',
                text = {
                    '起始牌组中每少一张牌，',
                    '获得{X:mult,C:white}X#2#{}倍率',
                    '{C:inactive}（当前为{X:mult,C:white}X#1#{C:inactive}倍率）',
                },
            },
            j_stone = {
                name = '石头小丑',
                text = {
                    '牌组中每有一张{C:attention}石头牌{}，',
                    '筹码倍率增加{X:chips,C:white}X#2#{}',
                    '{C:inactive}（当前为{X:chips,C:white}X#1#{C:inactive}）',
                },
            },
            j_bull = {
                name = '斗牛',
                text = {
                    '每有{C:money}$1{}，获得{C:chips}+#1#{}筹码',
                    '{C:inactive}（当前为{C:chips}+#2#{C:inactive}筹码）',
                },
            },
            j_smiley = {
                name = '微笑表情',
                text = {
                    '每张计分的{C:attention}人头牌{}使此小丑',
                    '永久获得{C:mult}+1{}倍率',
                    '{C:inactive}（当前为{C:mult}+#1#{C:inactive}倍率）',
                },
            },
            j_throwback = {
                name = '回溯',
                text = {
                    '本赛局内每跳过一个{C:attention}盲注{}，',
                    '你的{C:mult}倍率{}的指数增加{C:attention}0.25{}',
                    '{C:inactive}（当前为^{C:attention}#2#{C:inactive}）',
                },
            },
            j_hanging_chad = {
                name = '未断选票',
                text = {
                    '打出的第一张计分牌',
                    '额外触发{C:attention}3{}次',
                },
            },
            j_flower_pot = {
                name = '花盆',
                text = {
                    '计分牌中每有一种不同{C:attention}花色{}，',
                    '获得{X:mult,C:white}X1{}倍率',
                    '{C:inactive}（2种花色X2、3种X3、4种X4）',
                },
            },
            j_idol = {
                name = '偶像',
                text = {
                    '打出与本回合{C:attention}第一张计分牌{}点数、',
                    '花色都相同的牌时，给予',
                    '{X:mult,C:white}X3{}倍率',
                },
            },
            j_wee = {
                name = '小小丑',
                text = {
                    '每张计分的{C:attention}2{}使此小丑',
                    '获得{C:chips}+#2#{}筹码',
                    '{C:inactive}（当前为{C:chips}+#1#{C:inactive}筹码）',
                },
            },
            j_hit_the_road = {
                name = '上路吧杰克',
                text = {
                    '每弃掉一张{C:attention}J{}，此小丑获得',
                    '{X:mult,C:white}+X0.25{}倍率',
                    '{C:inactive}（当前为{X:mult,C:white}X#1#{C:inactive}）',
                    '击败{C:attention}Boss盲注{}后重置',
                },
            },
            j_invisible = {
                name = '隐形小丑',
                text = {
                    '每经过{C:attention}#1#{}回合，生成你',
                    '{C:attention}最左侧{}小丑的{C:dark_edition}负片{}复制',
                    '{C:inactive}（当前为{C:attention}#2#{C:inactive}/#1#）',
                },
            },
            j_drivers_license = {
                name = '驾驶执照',
                text = {
                    '完整牌组中每有一张{C:attention}增强牌{}，',
                    '获得{X:mult,C:white}X0.125{}倍率',
                    '{C:inactive}（当前为{X:mult,C:white}X#1#{C:inactive}倍率）',
                },
            },
            j_cartomancer = {
                name = '卡牌术士',
                text = {
                    '在选择{C:attention}盲注{}时生成一张',
                    '{C:dark_edition}负片{}版{C:tarot}塔罗牌{}',
                    '{C:inactive}（必须有空位）',
                },
            },
            j_burnt = {
                name = '烧焦小丑',
                text = {
                    '升级你弃掉的牌型，',
                    '每种牌型每回合限一次',
                },
            },
            j_chicot = {
                name = '希科',
                text = {
                    '所有{C:attention}Boss盲注{}的',
                    '筹码需求减半',
                },
            },
        },
    },
}
