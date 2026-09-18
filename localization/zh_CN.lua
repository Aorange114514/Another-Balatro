return {
    descriptions = {
        Joker = {
            j_joker = {
                name = '小丑',
                text = {
                    '{C:mult}+#1#{} 倍率',
                    '此小丑始终为{C:dark_edition}负片{}效果',
                    '（{C:attention}+1{}小丑栏位）',
                },
            },
            j_half = {
                name = '半张小丑',
                text = {
                    '若计分的牌不超过',
                    '{C:attention}#2#{}张，获得{C:mult}+#1#{}倍率',
                },
            },
            j_stencil = {
                name = '模具小丑',
                text = {
                    '每个空的小丑栏位提供：',
                    '{C:chips}+10{}筹码与',
                    '{X:mult,C:white}X1.5{}倍率',
                    '{C:inactive}（当前{C:attention}#1#{C:inactive}个空位）',
                },
            },
            j_ceremonial = {
                name = '仪式匕首',
                text = {
                    '选择盲注时，吞噬右侧的小丑，',
                    '获得其售价{C:mult}3倍{}的倍率',
                    '{C:inactive}（当前{C:mult}+#1#{C:inactive}倍率）',
                },
            },
            j_banner = {
                name = '旗帜',
                text = {
                    '每个剩余弃牌次数使筹码倍率',
                    '额外获得{C:chips}X1{}',
                    '{C:inactive}（总计 X(1+剩余弃牌数)）',
                },
            },
            j_marble = {
                name = '大理石小丑',
                text = {
                    '每个盲注的第一张计分牌',
                    '变为{C:attention}石头牌{}',
                },
            },
            j_loyalty_card = {
                name = '积分卡',
                text = {
                    '给予{X:mult,C:white}X#1#{}倍率',
                    '每次出牌后获得{X:mult,C:white}X0.5{}倍率，',
                    '当超过X4时重置为X0.5',
                    '{C:inactive}（当前{X:mult,C:white}X#1#{C:inactive}）',
                },
            },
            j_8_ball = {
                name = '八号球',
                text = {
                    '每张计分的{C:attention}8{}有',
                    '{C:green}1/2{}几率生成一张',
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
                    '计分的{C:attention}A{}、2、3、5、8',
                    '每张给予{C:mult}+#1#{}倍率，',
                    '并额外获得{C:chips}+20{}筹码',
                },
            },
            j_steel_joker = {
                name = '钢铁小丑',
                text = {
                    '{C:attention}钢铁牌{}会重新触发一次',
                    '每当钢铁牌触发时，',
                    '此小丑先获得{C:mult}+5{}倍率',
                },
            },
            j_scary_face = {
                name = '恐怖面孔',
                text = {
                    '你打出的人头牌',
                    '不会再返回牌组',
                },
            },
            j_even_steven = {
                name = '偶数史蒂文',
                text = {
                    '点数为偶数的计分牌',
                    '（2、4、6、8、10）每张给予',
                    '{X:mult,C:white}X1.1{}倍率',
                },
            },
            j_odd_todd = {
                name = '奇数托德',
                text = {
                    '打出的点数为{C:attention}奇数{}的牌',
                    '在计分时给予{C:chips}X1.5{}筹码',
                    '{C:inactive}（A、9、7、5、3）',
                },
            },
            j_scholar = {
                name = '学者',
                text = {
                    '打出的{C:attention}A{}牌在计分时给予',
                    '{X:mult,C:white}X1.5{}倍率和',
                    '{C:chips}X1.5{}筹码',
                },
            },
            j_supernova = {
                name = '超新星',
                text = {
                    '每打出一次该牌型获得{C:mult}+1{}倍率，',
                    '并额外获得该打出次数',
                    '{C:chips}2倍{}的筹码',
                },
            },
            j_ride_the_bus = {
                name = '搭乘巴士',
                text = {
                    '连续打出没有计分{C:attention}人头牌{}的牌时，',
                    '此小丑获得{C:mult}+2{}倍率；',
                    '{C:inactive}（当前{C:mult}+#2#{C:inactive}倍率）',
                    '打出人头牌时重置',
                },
            },
            j_space = {
                name = '太空小丑',
                text = {
                    '{C:green}1/2{}几率升级你打出的',
                    '{C:attention}牌型{}',
                },
            },
            j_egg = {
                name = '鸡蛋',
                text = {
                    '每回合结束时售价提高{C:money}$3{}',
                    '初始售价额外提高{C:money}$3{}',
                },
            },
            j_burglar = {
                name = '窃贼',
                text = {
                    '选择盲注时，获得{C:blue}+5{}次出牌',
                    '并将{C:red}弃牌{}次数归零',
                },
            },
            j_runner = {
                name = '跑步选手',
                text = {
                    '打出{C:attention}顺子{}牌型后，此小丑的',
                    '筹码倍率提升{C:chips}X#2#{}',
                    '{C:inactive}（当前{C:chips}X#1#{C:inactive}）',
                },
            },
            j_ice_cream = {
                name = '冰淇淋',
                text = {
                    '{C:chips}+100{}筹码',
                    '每打一手牌{C:chips}-5{}筹码，归零时融化',
                    '初始售价{C:money}-$1{}',
                },
            },
            j_splash = {
                name = '飞溅',
                text = {
                    '打出的所有牌都计入计分',
                    '你可以打出任意张手牌',
                },
            },
            j_blue_joker = {
                name = '蓝色小丑',
                text = {
                    '牌组中每张牌给予',
                    '{C:chips}+#1#{}筹码',
                    '{C:inactive}（当前{C:chips}+#2#{C:inactive}筹码）',
                },
            },
            j_hiker = {
                name = '徒步者',
                text = {
                    '计分的每张牌会永久',
                    '获得{C:chips}+15{}筹码',
                },
            },
            j_green_joker = {
                name = '绿色小丑',
                text = {
                    '每打一手牌：{C:mult}+#1#{}倍率',
                    '每弃一次牌：{C:mult}+#2#{}倍率',
                    '{C:inactive}（当前{C:mult}+#3#{C:inactive}倍率）',
                },
            },
            j_superposition = {
                name = '叠加态',
                text = {
                    '如果打出的牌中包含一张{C:attention}A{}',
                    '与一张{C:attention}K{}或{C:attention}2{}，',
                    '生成一张{C:tarot}塔罗牌{}',
                },
            },
            j_todo_list = {
                name = '待办清单',
                text = {
                    '打出你{C:attention}最少使用的{}牌型时',
                    '获得{C:money}$#1#{}：',
                    '{C:attention}#2#{}',
                },
            },
            j_cavendish = {
                name = '卡文迪什',
                text = {
                    '{X:mult,C:white}X3{}倍率',
                    '此小丑不会自毁',
                },
            },
            j_card_sharp = {
                name = '老千小丑',
                text = {
                    '若打出的牌型与本回合',
                    '上次打出的牌型相同，则获得',
                    '{X:mult,C:white}X1{}倍率（每重复一次+1）；',
                    '否则重置为X1',
                    '{C:inactive}（本回合上次打出的牌型：{C:attention}#1#{C:inactive}）',
                },
            },
            j_red_card = {
                name = '红牌',
                text = {
                    '每跳过{C:attention}补充包{}，',
                    '此小丑获得{C:mult}+6{}倍率',
                },
            },
            j_madness = {
                name = '疯狂',
                text = {
                    '选择盲注时，摧毁一个随机小丑',
                    '并获得{X:mult,C:white}X1{}倍率',
                },
            },
            j_square = {
                name = '方形小丑',
                text = {
                    '打出{C:attention}4张{}手牌时，',
                    '此小丑获得{C:chips}+6{}筹码',
                },
            },
            j_seance = {
                name = '通灵',
                text = {
                    '打出要求的牌型时，',
                    '生成一张{C:spectral}幻灵牌{}',
                    '要求牌型每回合改变',
                    '{C:inactive}（当前：{C:attention}#1#{C:inactive}）',
                },
            },
            j_vampire = {
                name = '吸血鬼',
                text = {
                    '你打出的{C:attention}所有{}增强牌',
                    '都会变成普通牌；每张使此小丑',
                    '获得{X:mult,C:white}+X0.1{}倍率',
                },
            },
            j_vagabond = {
                name = '流浪者',
                text = {
                    '当你只有{C:money}$4{}或更少时，',
                    '生成一张{C:dark_edition}负片{}版',
                    '{C:tarot}塔罗牌{}',
                },
            },
            j_baron = {
                name = '男爵',
                text = {
                    '手牌中的每张{C:attention}K{}',
                    '视为{C:attention}钢铁牌{}，',
                    '并会额外触发一次',
                    '（手牌中与打出时都生效）',
                },
            },
            j_obelisk = {
                name = '方尖石塔',
                text = {
                    '每打出一手不是',
                    '你最常用牌型的牌，获得',
                    '{X:mult,C:white}X0.25{}倍率；',
                    '失败则重置',
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
                    '本回合打出过头牌后，',
                    '每手第一张计分的人头牌给予',
                    '{X:mult,C:white}X2{}倍率',
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
                    '初始为{X:mult,C:white}X1{}倍率；',
                    '起始牌组中每少一张牌，',
                    '额外获得{X:mult,C:white}X0.2{}倍率',
                },
            },
            j_stone = {
                name = '石头小丑',
                text = {
                    '牌组中每有一张{C:attention}石头牌{}，',
                    '筹码倍率额外获得{C:chips}X0.1{}',
                    '{C:inactive}（初始为{C:chips}X1{}）',
                },
            },
            j_bull = {
                name = '斗牛',
                text = {
                    '每有{C:money}$1{}给予',
                    '{C:chips}+#1#{}筹码',
                    '{C:inactive}（当前{C:chips}+#2#{C:inactive}筹码）',
                },
            },
            j_smiley = {
                name = '微笑表情',
                text = {
                    '每张计分的人头牌使此小丑',
                    '获得{C:mult}+1{}倍率',
                    '{C:inactive}（当前{C:mult}+#1#{C:inactive}倍率）',
                },
            },
            j_throwback = {
                name = '回溯',
                text = {
                    '每跳过1个盲注，你的{C:mult}倍率{}',
                    '指数增加{C:attention}0.25{}',
                    '{C:inactive}（当前^{C:attention}#2#{C:inactive}）',
                },
            },
            j_hanging_chad = {
                name = '未断选票',
                text = {
                    '第一张计分牌会重新触发',
                    '{C:attention}3{}次',
                },
            },
            j_flower_pot = {
                name = '花盆',
                text = {
                    '计分牌中每有一种不同花色，',
                    '获得{C:mult}X1{}倍率',
                    '{C:inactive}（2种花色X2、3种X3、4种X4）',
                },
            },
            j_idol = {
                name = '偶像',
                text = {
                    '打出与本回合第一张',
                    '计分牌相同的牌时，给予',
                    '{X:mult,C:white}X3{}倍率',
                },
            },
            j_wee = {
                name = '小小丑',
                text = {
                    '每张计分的{C:attention}2{}使',
                    '此小丑获得{C:chips}+10{}筹码',
                },
            },
            j_hit_the_road = {
                name = '上路吧杰克',
                text = {
                    '每弃掉一张{C:attention}J{}，此小丑获得',
                    '{X:mult,C:white}+X0.25{}倍率',
                    '{C:inactive}（当前{X:mult,C:white}X#1#{C:inactive}）',
                    '击败Boss盲注后重置',
                },
            },
            j_invisible = {
                name = '隐形小丑',
                text = {
                    '每经过{C:attention}#1#{}回合，生成你',
                    '{C:attention}最左侧{}小丑的',
                    '{C:dark_edition}负片{}复制',
                    '{C:inactive}（当前{C:attention}#2#{C:inactive}/#1#）',
                },
            },
            j_drivers_license = {
                name = '驾驶执照',
                text = {
                    '完整牌组中每有一张{C:attention}增强牌{}，',
                    '获得{X:mult,C:white}X0.125{}倍率',
                    '{C:inactive}（当前{X:mult,C:white}X#1#{C:inactive}倍率）',
                },
            },
            j_cartomancer = {
                name = '卡牌术士',
                text = {
                    '选择盲注时生成一张',
                    '{C:dark_edition}负片{}版{C:tarot}塔罗牌{}',
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
                    'BOSS盲注所需筹码',
                    '减半',
                },
            },
        },
    },
}
