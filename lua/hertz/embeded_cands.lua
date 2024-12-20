-- embeded_cands.lua
-- encoding: utf-8
-- CC-BY-4.0

-- 作者：王牌餅乾
-- https://github.com/lost-melody/
-- 转载请保留作者名
-- Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International
---------------------------------------

local data = {
    dk = "口",
    ff = "福",
    kv = "汽",
    rj = "巾",
    id = "部",
    kd = "台",
    oa = "电",
    wj = "家",
    wl = "宽",
    lw = "带",
    jd = "斗",
    fl = "开",
    lj = "花",
    ["in"] = "主",
    ja = "们",
    du = "无",
    ud = "售",
    eh = "平",
    lb = "耍",
    je = "他",
    vi = "已",
    vk = "导",
    dv = "喘",
    jv = "仍",
    gx = "境",
    ek = "每",
    fh = "忘",
    wv = "它",
    rk = "对",
    ke = "杂",
    lx = "夕",
    cd = "否",
    gy = "羊",
    hd = "总",
    sj = "认",
    hr = "曾",
    ka = "活",
    ["if"] = "组",
    fu = "百",
    nr = "友",
    ia = "盘",
    qn = "牛",
    ck = "尿",
    ip = "继",
    kl = "满",
    cp = "克",
    zm = "麻",
    xk = "应",
    yw = "爱",
    lf = "方",
    gl = "够",
    uk = "热",
    zp = "钊",
    yd = "点",
    hk = "公",
    pe = "儿",
    ku = "过",
    kt = "通",
    ns = "十",
    lr = "菲",
    od = "知",
    st = "诉",
    qu = "进",
    dd = "器",
    ld = "名",
    kg = "法",
    ys = "四",
    fb = "互",
    ot = "题",
    tm = "向",
    jw = "作",
    og = "影",
    il = "立",
    nf = "感",
    pj = "料",
    ub = "白",
    gw = "韦",
    hs = "务",
    ls = "生",
    xm = "色",
    hg = "谷",
    cq = "眉",
    jk = "付",
    gh = "志",
    pc = "长",
    ih = "收",
    cy = "业",
    em = "木",
    tz = "阿",
    ej = "见",
    to = "费",
    iv = "予",
    ut = "拥",
    vr = "股",
    za = "魔",
    oe = "朵",
    wi = "很",
    ne = "现",
    vy = "月",
    dm = "民",
    ug = "工",
    fw = "亡",
    es = "格",
    zl = "错",
    hx = "心",
    fp = "万",
    wm = "头",
    jt = "任",
    ve = "肝",
    mc = "独",
    ng = "存",
    hc = "怀",
    pq = "趣",
    ll = "多",
    mo = "犹",
    fo = "更",
    uq = "看",
    ig = "艮",
    yc = "车",
    rs = "劝",
    kf = "滑",
    wf = "写",
    we = "次",
    rl = "簇",
    tq = "裹",
    xh = "意",
    fd = "事",
    tj = "斤",
    pf = "师",
    vs = "山",
    it = "矛",
    dr = "嗯",
    uj = "拾",
    sm = "出",
    ua = "打",
    dy = "由",
    js = "信",
    xn = "鸟",
    pa = "精",
    nx = "辛",
    tn = "随",
    qy = "卧",
    vu = "这",
    ac = "闽",
    eg = "干",
    eq = "欠",
    dh = "只",
    nl = "弄",
    ui = "拉",
    wg = "凉",
    so = "训",
    rp = "皮",
    jz = "何",
    cz = "翅",
    sk = "该",
    gg = "高",
    zf = "钱",
    ue = "集",
    jc = "做",
    nc = "环",
    fm = "天",
    sc = "谈",
    jp = "代",
    lg = "警",
    ji = "位",
    jb = "会",
    jg = "个",
    mz = "犯",
    ea = "杨",
    jf = "使",
    ds = "别",
    fr = "骰",
    uo = "提",
    cm = "炉",
    vf = "票",
    aj = "闪",
    la = "世",
    sp = "试",
    ty = "用",
    ah = "敌",
    zb = "离",
    iw = "预",
    pw = "逃",
    bu = "建",
    jr = "仅",
    zs = "身",
    xl = "鹿",
    wn = "德",
    as = "舌",
    tk = "么",
    sd = "加",
    jm = "传",
    oh = "败",
    he = "条",
    gn = "块",
    fe = "视",
    pu = "足",
    tf = "弗",
    cu = "还",
    ch = "火",
    gz = "堪",
    uw = "项",
    am = "门",
    ib = "义",
    gf = "款",
    iu = "维",
    vq = "气",
    wd = "况",
    rm = "因",
    ha = "情",
    km = "母",
    pp = "划",
    mi = "太",
    xo = "负",
    op = "则",
    cl = "展",
    cv = "尾",
    lv = "散",
    go = "亮",
    dn = "吗",
    rh = "悲",
    jo = "但",
    tl = "龙",
    aa = "书",
    ci = "支",
    qx = "饭",
    ho = "首",
    oi = "自",
    lq = "千",
    vo = "疑",
    fn = "于",
    fk = "求",
    sq = "讲",
    fj = "骱",
    qd = "告",
    oy = "尤",
    sa = "话",
    zy = "销",
    md = "启",
    ox = "暗",
    te = "欣",
    eb = "柳",
    gv = "死",
    kp = "刻",
    yz = "醉",
    ao = "间",
    lu = "雅",
    ps = "鼠",
    yl = "罗",
    kz = "河",
    ab = "交",
    jx = "你",
    gs = "士",
    va = "肠",
    af = "丰",
    zd = "豆",
    li = "药",
    tg = "革",
    fg = "社",
    bh = "好",
    cf = "飞",
    ju = "入",
    yk = "酸",
    vv = "比",
    yr = "轻",
    rd = "回",
    ap = "片",
    nh = "黄",
    qh = "思",
    sw = "语",
    jj = "从",
    ly = "牙",
    ei = "根",
    ik = "永",
    vm = "然",
    hb = "八",
    kx = "派",
    kw = "学",
    ar = "疗",
    ou = "巡",
    al = "六",
    hy = "处",
    ki = "注",
    ro = "帽",
    fc = "辰",
    ic = "册",
    zo = "躲",
    co = "贵",
    qm = "目",
    bj = "蠡",
    en = "午",
    rv = "笔",
    mr = "破",
    jn = "全",
    jl = "仑",
    yp = "轼",
    qg = "特",
    is = "络",
    mg = "光",
    xi = "久",
    kc = "寸",
    vl = "认",
    td = "袖",
    xj = "科",
    hl = "并",
    xc = "厂",
    hf = "夫",
    hh = "卷",
    rw = "瓦",
    ur = "排",
    nz = "璃",
    ca = "灯",
    bx = "弥",
    wy = "页",
    sv = "此",
    pm = "米",
    ad = "丁",
    ti = "衣",
    vh = "改",
    ix = "颜",
    hw = "冬",
    zh = "其",
    wk = "官",
    bp = "张",
    nw = "王",
    zx = "习",
    mx = "确",
    et = "窗",
    yq = "曲",
    qs = "食",
    bw = "弱",
    ii = "良",
    uf = "段",
    io = "舟",
    uz = "报",
    nb = "区",
    ze = "某",
    us = "手",
    up = "找",
    wa = "乍",
    fx = "鹘",
    df = "号",
    rt = "第",
    oz = "短",
    ev = "年",
    wx = "象",
    nt = "才",
    nd = "右",
    hu = "半",
    dg = "吐",
    kr = "没",
    tw = "院",
    cg = "古",
    ry = "又",
    os = "矢",
    ak = "承",
    qe = "耳",
    cn = "炮",
    mw = "硕",
    tc = "蛋",
    ul = "摸",
    pt = "跃",
    da = "味",
    ew = "须",
    rq = "七",
    fs = "示",
    ob = "贝",
    re = "欢",
    zt = "铁",
    qi = "眼",
    wr = "彻",
    ra = "简",
    fy = "下",
    sg = "各",
    ai = "乙",
    sn = "计",
    ri = "之",
    ir = "经",
    wh = "怎",
    wq = "寒",
    gk = "去",
    yg = "瓜",
    bb = "妇",
    tu = "近",
    ct = "属",
    ag = "鬼",
    qb = "聊",
    nq = "真",
    mb = "巴",
    lo = "草",
    lc = "齿",
    au = "那",
    vn = "乃",
    yy = "酉",
    ["or"] = "日",
    zr = "市",
    vw = "文",
    ez = "柯",
    gi = "养",
    bd = "强",
    pn = "越",
    po = "踢",
    de = "吃",
    ya = "爪",
    yo = "醒",
    pi = "弋",
    uh = "攻",
    qw = "瞎",
    se = "许",
    qk = "眸",
    ta = "朱",
    yb = "当",
    ks = "水",
    rn = "国",
    bm = "面",
    yv = "配",
    sr = "发",
    zc = "变",
    xw = "稼",
    pl = "老",
    su = "边",
    kh = "亥",
    kb = "流",
    mh = "户",
    yi = "至",
    iy = "幺",
    yh = "致",
    kk = "治",
    ux = "换",
    iz = "即",
    zu = "摩",
    sh = "办",
    fa = "与",
    qc = "臣",
    uu = "推",
    sz = "谢",
    nv = "有",
    yf = "票",
    mt = "所",
    oc = "川",
    hi = "子",
    ge = "地",
    fi = "禘",
    xx = "危",
    rz = "篱",
    ol = "星",
    bf = "姐",
    mn = "码",
    bi = "娘",
    jh = "份",
    pv = "起",
    bo = "区",
    xg = "广",
    ts = "三",
    ql = "老",
    zn = "针",
    ye = "采",
    hz = "登",
    si = "止",
    xe = "床",
    qj = "井",
    qf = "考",
    ko = "测",
    ma = "专",
    rr = "双",
    ow = "顺",
    hq = "派单",
    zi = "率",
    ni = "玉",
    eu = "追追",
    tp = "翻",
    qo = "者",
    wu = "五",
    vx = "西",
    me = "二",
    lz = "节",
    ae = "闲",
    ij = "给",
    ee = "林",
    ph = "黑",
    cb = "层",
    zq = "翼",
    ga = "场",
    ep = "楼",
    eo = "机",
    ov = "明",
    xf = "后",
    dq = "喂",
    fq = "且",
    gp = "列",
    ml = "两",
    aw = "未",
    ws = "客",
    mk = "夺",
    kn = "汇",
    um = "击",
    qp = "先",
    pk = "踏",
    oj = "几",
    hm = "送",
    wb = "安",
    pz = "走",
    bv = "奶",
    cc = "虫",
    qv = "遇",
    qt = "田",
    av = "北",
    xa = "剩",
    bk = "录",
    el = "穿",
    vj = "以",
    sf = "证",
    na = "成",
    fz = "祺",
    px = "糖",
    oq = "则",
    zw = "锭",
    lk = "落",
    of = "晨",
    iq = "细",
    an = "缺",
    on = "早",
    xy = "音",
    dl = "里",
    yx = "小",
    hj = "恰",
    ax = "版",
    mq = "犬",
    cj = "及",
    bn = "女",
    bl = "耍",
    az = "闹",
    uc = "据",
    ny = "戚",
    lh = "放",
    db = "史",
    dw = "咋",
    ft = "祈",
    ln = "廿",
    dx = "唤",
    ie = "新",
    gm = "美",
    tb = "雪",
    aq = "闻",
    pr = "紧",
    wp = "免",
    ht = "必",
    gb = "坛",
    jq = "件",
    mv = "肩",
    lt = "萨",
    vd = "肿",
    ec = "极",
    tx = "隐",
    cw = "炸",
    no = "朝",
    vg = "脚",
    vp = "刘",
    ym = "转",
    mp = "远",
    ru = "竹",
    im = "商",
    lm = "英",
    rf = "非",
    yu = "连",
    ss = "尚",
    sl = "力",
    bt = "群",
    wz = "凛",
    mm = "央",
    nm = "马",
    mu = "达",
    nj = "验",
    nu = "左",
    oo = "州",
    zk = "射",
    wo = "审",
    ef = "本",
    hn = "快",
    xt = "解",
    th = "失",
    kj = "九",
    xz = "顾",
    uy = "掉",
    wc = "灾",
    gr = "餐",
    di = "叫",
    ms = "石",
    qr = "取",
    vc = "肢",
    gd = "歹",
    ay = "阌",
    cs = "尸",
    vb = "匕",
    cr = "烟",
    zv = "羽",
    xq = "稷",
    kq = "泪",
    rc = "固",
    sx = "鸭",
    hv = "前",
    qq = "齐",
    nk = "雄",
    qa = "睛",
    jy = "倒",
    nn = "巨",
    dp = "兄",
    sy = "言",
    om = "映",
    vz = "服",
    ba = "妹",
    zz = "哥",
    ok = "时",
    ww = "实",
    ["do"] = "员",
    np = "班",
    zg = "甘",
    bg = "弓",
    ce = "炊",
    bc = "姑",
    gj = "句",
    tr = "被",
    at = "帮",
    ed = "窝",
    xv = "岛",
    mf = "同",
    dt = "啊",
    xb = "争",
    un = "皇",
    be = "她",
    mj = "内",
    dj = "哈",
    rx = "鸡",
    tv = "雨",
    sb = "尝",
    my = "酒",
    pg = "戈",
    fv = "望",
    ey = "档",
    rb = "箫",
    lp = "蓝",
    hp = "分",
    wt = "定",
    ex = "穴",
    xp = "利",
    xu = "原",
    gc = "声",
    yt = "少",
    ky = "酒",
    rg = "等",
    pb = "数",
    cx = "焰",
    er = "权",
    by = "云",
    xr = "反",
    pd = "刀",
    bs = "动",
    bz = "迎",
    dc = "虽",
    vt = "胧",
    xd = "种",
    dz = "嘛",
    uv = "指",
    le = "施",
    xs = "束",
    yn = "置",
    zj = "金",
    br = "努",
    gq = "着",
    bq = "留",
    gt = "土",
    gu = "差",
    yj = "轮",
    tt = "袭",
    qz = "眩",
    py = "赴"

}
-- 將要被返回的過濾器對象
local embeded_cands_filter = {}

--[[
# xxx.schema.yaml
switches:
  - name: embeded_cands
    states: [ 普通, 嵌入 ]
    reset: 1
engine:
  filters:
    - lua_filter@*smyh.embeded_cands
key_binder:
  bindings:
    - { when: always, accept: "Control+Shift+E", toggle: embeded_cands }
--]]

-- 候選序號標記
local index_indicators = {"¹", "²", "³", "⁴", "⁵", "⁶", "⁷", "⁸", "⁹", "⁰"}

-- 首選/非首選格式定義
-- Seq: 候選序號; Code: 編碼; 候選: 候選文本; Comment: 候選提示
local first_format = "${候選}${Comment}${Seq}"
local next_format = "${候選}${Comment}${Seq}"
local separator = " "

-- 讀取 schema.yaml 開關設置:
local option_name = "embeded_cands"

-- 從方案配置中讀取字符串
local function parse_conf_str(env, path, default)
    local str = env.engine.schema.config:get_string(env.name_space.."/"..path)
    if not str and default and #default ~= 0 then
        str = default
    end
    return str
end

-- 從方案配置中讀取字符串列表
local function parse_conf_str_list(env, path, default)
    local list = {}
    local conf_list = env.engine.schema.config:get_list(env.name_space.."/"..path)
    if conf_list then
        for i = 0, conf_list.size-1 do
            table.insert(list, conf_list:get_value_at(i).value)
        end
    elseif default then
        list = default
    end
    return list
end

-- 構造開關變更回調函數
local function get_switch_handler(env, op_name)
    local option
    if not env.option then
        option = {}
        env.option = option
    else
        option = env.option
    end
    -- 返回通知回調, 當改變選項值時更新暫存的值
    return function(ctx, name)
        if name == op_name then
            option[name] = ctx:get_option(name)
            if option[name] == nil then
                -- 當選項不存在時默認爲啟用狀態
                option[name] = true
            end
        end
    end
end

local function compile_formatter(format)
    -- "${Stash}[${候選}${Seq}]${Code}${Comment}"
    -- => "%s[%s%s]%s%s"
    -- => {"${Stash}", "${...}", "${...}", ...}
    local pattern = "%$%{[^{}]+%}"
    local verbs = {}
    for s in string.gmatch(format, pattern) do
        table.insert(verbs, s)
    end

    local res = {
        format = string.gsub(format, pattern, "%%s"),
        verbs = verbs,
    }
    local meta = { __index = function() return "" end }

    -- {"${v1}", "${v2}", ...} + {v1: a1, v2: a2, ...} = {a1, a2, ...}
    -- string.format("%s[%s%s]%s%s", a1, a2, ...)
    function res:build(dict)
        setmetatable(dict, meta)
        local args = {}
        for _, pat in ipairs(self.verbs) do
            table.insert(args, dict[pat])
        end
        return string.format(self.format, table.unpack(args))
    end

    return res
end

-- 按命名空間歸類方案配置, 而不是按会話, 以减少内存佔用
local namespaces = {}
function namespaces:init(env)
    -- 讀取配置項
    if not namespaces:config(env) then
        local config = {}
        config.index_indicators = parse_conf_str_list(env, "index_indicators", index_indicators)
        config.first_format = parse_conf_str(env, "first_format", first_format)
        config.next_format = parse_conf_str(env, "next_format", next_format)
        config.separator = parse_conf_str(env, "separator", separator)
        config.option_name = parse_conf_str(env, "option_name")

        config.formatter = {}
        config.formatter.first = compile_formatter(config.first_format)
        config.formatter.next = compile_formatter(config.next_format)
        namespaces:set_config(env, config)
    end
end
function namespaces:set_config(env, config)
    namespaces[env.name_space] = namespaces[env.name_space] or {}
    namespaces[env.name_space].config = config
end
function namespaces:config(env)
    return namespaces[env.name_space] and namespaces[env.name_space].config
end

function embeded_cands_filter.init(env)
    -- 讀取配置項
    local ok = pcall(namespaces.init, namespaces, env)
    if not ok then
        local config = {}
        config.index_indicators = index_indicators
        config.first_format = first_format
        config.next_format = next_format
        config.separator = separator
        config.option_name = parse_conf_str(env, "option_name")

        config.formatter = {}
        config.formatter.first = compile_formatter(config.first_format)
        config.formatter.next = compile_formatter(config.next_format)
        namespaces:set_config(env, config)
    end

    local config = namespaces:config(env)
    -- 是否指定開關
    if config.option_name and #config.option_name ~= 0 then
        -- 構造回調函數
        local handler = get_switch_handler(env, config.option_name)
        -- 初始化爲選項實際值, 如果設置了 reset, 則會再次觸發 handler
        handler(env.engine.context, config.option_name)
        -- 注册通知回調
        env.engine.context.option_update_notifier:connect(handler)
    else
        -- 未指定開關, 默認啓用
        config.option_name = option_name
        env.option = {}
        env.option[config.option_name] = true
    end
end

-- 渲染提示, 因爲提示經常有可能爲空, 抽取爲函數更昜操作
local function render_comment(comment)
    if string.match(comment, "^[ ~]") then
        -- 丟棄以空格和"~"開頭的提示串, 這通常是補全提示
        comment = ""
    elseif string.len(comment) ~= 0 then
        comment = "["..comment.."]"
    end
    return comment
end

-- 渲染單個候選項
local function render_cand(env, seq, code, text, comment)
    local formatter
    if seq == 1 then
        formatter = namespaces:config(env).formatter.first
    else
        formatter = namespaces:config(env).formatter.next
    end
    -- 渲染提示串
    comment = render_comment(comment)
    -- 渲染提示串
    comment = render_comment(comment)
    local cand = formatter:build({
        ["${Seq}"] = namespaces:config(env).index_indicators[seq],
        ["${Code}"] = code,
        ["${候選}"] = text,
        ["${Comment}"] = comment,
    })
    return cand
end

-- 過濾器
function embeded_cands_filter.func(input, env)
    if not env.option[namespaces:config(env).option_name] then
        for cand in input:iter() do
            yield(cand)
        end
        return
    end

    -- 要顯示的候選數量
    local page_size = env.engine.schema.page_size
    -- 暫存當前頁候選, 然后批次送出
    local page_cands, page_rendered = {}, {}
    -- 暫存索引, 首選和預編輯文本
    local index, first_cand, preedit = 0, nil, ""

    local function refresh_preedit()
        if first_cand then
            first_cand.preedit = table.concat(page_rendered, namespaces:config(env).separator)
            -- 將暫存的一頁候選批次送出
            for _, c in ipairs(page_cands) do
                yield(c)
            end
        end
        -- 清空暫存
        first_cand, preedit = nil, ""
        page_cands, page_rendered = {}, {}
    end

    local hash = {}
    local rank = 1
    -- 迭代器
    local iter, obj = input:iter()
    -- 迭代由翻譯器輸入的候選列表
    local next = iter(obj)
    while next do
        -- 頁索引自增, 滿足 1 <= index <= page_size
        index = index + 1

        -- 當前遍歷候選項
        local cand = Candidate(next.type, next.start, next._end, next.text, next.comment)
        cand.quality = next.quality
        cand.preedit = next.preedit

        -- 去除重複項
        if (not hash[cand.text]) then
            hash[cand.text] = true

            if not first_cand then
                -- 把首選捉出來
                first_cand = cand
                local l = cand.preedit:len()
                if l == 3 then
                    preedit = render_cand(env, 10, cand.preedit, data[cand.preedit:sub(1, 2)], cand.comment)
                elseif l == 4 then
                    preedit = preedit .. render_cand(env, 10, cand.preedit, data[cand.preedit:sub(1, 2)] .. data[cand.preedit:sub(3)], cand.comment)
                end
                preedit = preedit .. render_cand(env, rank, cand.preedit, cand.text, cand.comment)
            else
                rank = rank + 1
                -- 修改首選的預编輯文本, 這会作爲内嵌編碼顯示到輸入處
                preedit = render_cand(env, rank, first_cand.preedit, cand.text, cand.comment)
            end

            -- 存入候選
            table.insert(page_cands, cand)
            table.insert(page_rendered, preedit)
        end
        -- 遍歷完一頁候選後, 刷新預編輯文本
        if index == page_size then
            refresh_preedit()
            rank = 0
        end

        -- 當前候選處理完畢, 查詢下一個
        next = iter(obj)

        -- 如果當前暫存候選不足page_size但没有更多候選, 則需要刷新預編輯並送出
        if not next and index < page_size then
            refresh_preedit()
        end

        -- 下一頁, index歸零
        index = index % page_size
    end
end

function embeded_cands_filter.fini(env)
end

return embeded_cands_filter
