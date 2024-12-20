-- tiger_spelling.lua
-- encoding: utf-8
-- CC-BY-4.0

-- 作者：ace-who
-- https://github.com/Ace-Who/rime-xuma/blob/master/schema/lua/ace/xuma_spelling.lua

-- 用于生成词语拆分

function map(table, func)
  local t = {}
  for k, v in pairs(table) do
    t[k] = func(v)
  end
  return t
end

function utf8chars(str)
  local chars = {}
  for pos, code in utf8.codes(str) do
    chars[#chars + 1] = utf8.char(code)
  end
  return chars
end

-- rime.lua

local rime = {}
package.loaded[...] = rime
rime.encoder = {}

function rime.encoder.parse_formula(formula)
  if type(formula) ~= 'string' or formula:gsub('%u%l', '') ~= '' then return end
  local rule = {}
  local A, a, U, u, Z, z = ('AaUuZz'):byte(1, -1)
  for m in formula:gmatch('%u%l') do
    local upper, lower = m:byte(1, 2)
    local char_idx = upper < U and upper - A + 1 or upper - Z - 1
    local code_idx = lower < u and lower - a + 1 or lower - z - 1
    rule[#rule + 1] = { char_idx, code_idx }
  end
  return rule
end

function rime.encoder.load_settings(setting)
  -- 注意到公式同则规则同，可通过 f2r 在 rt 中作引用定义，以节省资源。
  local ft, f2r, rt = {}, {}, {}
  for _, t in ipairs(setting) do
    if t.length_equal then
      ft[t.length_equal] = t.formula
    elseif t.length_in_range then
      local min, max = table.unpack(t.length_in_range)
      for l = min, max do
        ft[l] = t.formula
      end
    end
  end
  -- setting 中的 length 不一定连续且一般不包括 1，所以不能用 ipairs()。
  for k, f in pairs(ft) do
    local rule = rime.encoder.parse_formula(f)
    if not rule then return end
    if not f2r[f] then f2r[f] = rule end
    rt[k] = f2r[f]
  end
  return rt
end

function rime.switch_option(name, context)
  context:set_option(name, not context:get_option(name))
end

-- Cycle options of a switcher. When #options == 1, toggle the only option.
-- Otherwise unset the first set option and unset the next, or the previous if
-- 'reverse' is true. When no set option is present, try the key
-- 'options.save', then 'options.default', then 1.
function rime.cycle_options(options, env, reverse)
  local context = env.engine.context
  if #options == 0 then return 0 end
  if #options == 1 then
    rime.switch_option(options[1], context)
    return 1
  end
  local state
  for k, v in ipairs(options) do
    if context:get_option(v) then
      context:set_option(v, false)
      state = (reverse and (k - 1) or (k + 1)) % #options
      if state == 0 then state = #options end
      break
    end
  end
  local k = state or options.save or options.default or 1
  context:set_option(options[k], true)
  return k
end

-- Set an option in 'options' if no one is set yet.
function rime.init_options(options, context)
  for k, v in ipairs(options) do
    if context:get_option(v) then return end
  end
  local k = state or options.save or options.default or 1
  context:set_option(options[k], true)
end

-- Generate a processor that cycle a group of options with a key.
-- For now only works when composing.
function rime.make_option_cycler(
  options,
  cycle_key_config_path,
  switch_key_config_path,
  reverse
)
  local processor, cycle_key, switch_key = {}
  processor.init = function(env)
    local config = env.engine.schema.config
    cycle_key = config:get_string(cycle_key_config_path)
    switch_key = config:get_string(switch_key_config_path)
  end
  processor.func = function(key, env)
    local context = env.engine.context
    if context:is_composing() and key:repr() == cycle_key then
      local state = rime.cycle_options(options, env, reverse)
      if state > 1 then options.save = state end
      return 1
    elseif context:is_composing() and key:repr() == switch_key then
      -- 选项状态可能在切换方案时被重置，因此需检测更新。但是不能在 filter.init
      -- 中检测，因为得到的似乎是重置之前的状态，说明组件初始化先于状态重置。为
      -- 经济计，仅在手动切换开关时检测。
      -- https://github.com/rime/librime/issues/449
      -- Todo: 对于较新的 librime-lua，尝试利用 option_update_notifier 更新
      -- options.save
      for k, v in ipairs(options) do
        if context:get_option(v) then
          if k > 1 then options.save = k end
        end
      end
      local k = options.save or options.default
      -- Consider the 1st options as OFF state.
      if context:get_option(options[1]) then
        context:set_option(options[1], false)
        context:set_option(options[k], true)
      else
        context:set_option(options[k], false)
        context:set_option(options[1], true)
      end
      return 1
    end
    return 2 -- kNoop
  end
  return processor
end

-- start of tiger_spelling.lua

local config = {}
config.encode_rules = {
  { length_equal = 2,          formula = 'AaAbBaBb' },
  { length_equal = 3,          formula = 'AaBaCaCb' },
  { length_in_range = { 4, 10 }, formula = 'AaBaCaZa' }
}
-- 注意借用编码规则有局限性：取码索引不一定对应取根索引，尤其是从末尾倒数时。
local spelling_rules = rime.encoder.load_settings(config.encode_rules)
-- options 要与方案保持一致
local options = {
  'tiger_spelling.off',
  'tiger_spelling.lv1',
  'tiger_spelling.lv2',
  'tiger_spelling.lv3',
  'tiger_spelling.lv4'
}
options.default = 1

local processor = rime.make_option_cycler(options,
  'tiger_spelling/lua/cycle_key',
  'tiger_spelling/lua/switch_key')

local function xform(s)
  -- input format: "[spelling,code_code...,pinyin_pinyin...]"
  -- output format: "〔 spelling · code code ... · pinyin pinyin ... 〕"
  return s == '' and s or s:gsub('%[', '〔')
      :gsub('%]', '〕')
      :gsub('{', '<')
      :gsub('}', '>')
      :gsub('_', ' ')
      :gsub(',', ' · ')
      :gsub(' ·  ·  · ', ' · ')
      :gsub(' ·  · ', ' · ')
      :gsub('〔〕', '')
      :gsub('〔 · ', "〔")
end


local function parse_spll(str)
  local radicals = {}
  for seg in str:gsub('%b{}', ' %0 '):gmatch('%S+') do
    if seg:find('^{.+}$') then
      table.insert(radicals, seg)
    else
      for pos, code in utf8.codes(seg) do
        table.insert(radicals, utf8.char(code))
      end
    end
  end
  return radicals
end

local function parse_raw_tricomment(str)
  return str:gsub(',.*', ''):gsub('^%[', '')
end

local function parse_raw_code_comment(str)
  return str:gsub('%[.-,(.-),.*%]', '[%1]'):gsub(',.*', ''):gsub('^%[', '')
end

local function spell_phrase(s, spll_rvdb)
  local chars = utf8chars(s)
  local rule = spelling_rules[#chars]
  if not rule then return end
  local radicals = {}
  for i, coord in ipairs(rule) do
    local char_idx = coord[1] > 0 and coord[1] or #chars + 1 + coord[1]
    local raw = spll_rvdb:lookup(chars[char_idx])
    -- 若任一取码单字没有注解数据，则不对词组作注。
    if raw == '' then return end
    local char_radicals = parse_spll(parse_raw_tricomment(raw))
    local code_idx = coord[2] > 0 and coord[2] or #char_radicals + 1 + coord[2]
    radicals[i] = char_radicals[code_idx] or '◇'
  end
  return table.concat(radicals)
end

local function code_phrase(s, spll_rvdb)
  local chars = utf8chars(s)
  local rule = spelling_rules[#chars]
  if not rule then return end
  local radicals = {}
  for i, coord in ipairs(rule) do
    local char_idx = coord[1] > 0 and coord[1] or #chars + 1 + coord[1]
    local raw = spll_rvdb:lookup(chars[char_idx])
    -- 若任一取码单字没有注解数据，则不对词组作注。
    if raw == '' then return end
    local char_radicals = parse_spll(parse_raw_code_comment(raw))
    local code_idx = coord[2] > 0 and coord[2] or #char_radicals + 1 + coord[2]
    radicals[i] = char_radicals[code_idx] or '◇'
  end
  return table.concat(radicals)
end

local function get_tricomment(cand, env)
  local text = cand.text
  if utf8.len(text) == 1 then
    local raw_spelling = env.spll_rvdb:lookup(text)
    if raw_spelling == '' then return end
    return env.engine.context:get_option('tiger_spelling.lv1')
        and xform(raw_spelling:gsub('%[(.-),.*%]', '[%1]'))
        or env.engine.context:get_option('tiger_spelling.lv2')
        and xform(raw_spelling:gsub('%[(.-,.-),.*%]', '[%1]'))
        or env.engine.context:get_option('tiger_spelling.lv3')
        and xform(raw_spelling:gsub('%[(.-,.-,.-),.*%]', '[%1]'))
        or xform(raw_spelling) -- tiger_spelling.lv3 is on
  elseif utf8.len(text) > 1 then
    local spelling = spell_phrase(text, env.spll_rvdb)
    if not spelling then return end
    spelling = spelling:gsub('{(.-)}', '<%1>')
    if env.engine.context:get_option('tiger_spelling.lv1') then
      return ('〔%s〕'):format(spelling)
    end
    local code = env.code_rvdb:lookup(text)
    local code = code_phrase(text, env.spll_rvdb)
    if code ~= '' then -- 按长度排列多个编码。
      local codes = {}
      for m in code:gmatch('%S+') do codes[#codes + 1] = m end
      table.sort(codes, function(i, j) return i:len() < j:len() end)
      return ('〔%s · %s〕'):format(spelling, table.concat(codes, ' '))
    else -- 以括号类型区分非本词典之固有词
      return ('〈 %s 〉'):format(spelling)
      -- Todo: 如果要为此类词组添加编码注释，其中的单字存在一字多码的情况，需先
      -- 通过比较来确定全码，再提取词组编码。
    end
  end
end


local function filter(input, env)
  if env.engine.context:get_option('tiger_spelling.off') then
    for cand in input:iter() do yield(cand) end
    return
  end
  for cand in input:iter() do
    --[[
    用户有时需要通过拼音反查简化字并显示三重注解，但 luna_pinyin 的简化字排序不
    合理且靠后。用户可开启 simplification 来解决，但是 simplifier 会强制覆盖注
    释，为了避免三重注解被覆盖，只能生成一个简单类型候选来代替原候选。
    Todo: 测试在 <simplifier>/tips: none 的条件下，用 cand.text 和
    cand:get_genuine().text 分别读到什么值。若分别读到转换前后的候选，则可以仅
    修改 comment 而不用生成简单类型候选来代替原始候选。这样做的问题是关闭
    tiger_spelling 时就不显示 tips 了。
    --]]
    if cand.type == 'simplified' then
      local comment = (get_tricomment(cand, env) or '') .. cand.comment
      cand = Candidate("simp_rvlk", cand.start, cand._end, cand.text, comment)
    else
      local add_comment = cand.type == 'punct'
          and env.code_rvdb:lookup(cand.text)
          or cand.type ~= 'sentence'
          and get_tricomment(cand, env)
      if add_comment and add_comment ~= '' then
        -- 混输和反查中的非 completion 类型，原注释为空或主词典的编码。
        -- 为免重复冗长，直接以新增注释替换之。前提是后者非空。
        cand.comment = cand.type ~= 'completion'
            and env.is_mixtyping
            and add_comment
            or add_comment .. cand.comment
      end
    end
    yield(cand)
  end
end


local function init(env)
  local config = env.engine.schema.config
  local spll_rvdb = config:get_string('schema_name/spelling')
  local code_rvdb = config:get_string('schema_name/code')
  local abc_extags_size = config:get_list_size('abc_segmentor/extra_tags')
  env.spll_rvdb = ReverseDb('build/' .. spll_rvdb .. '.reverse.bin')
  env.code_rvdb = ReverseDb('build/' .. code_rvdb .. '.reverse.bin')
  env.is_mixtyping = abc_extags_size > 0
  rime.init_options(options, env.engine.context)
end


return { filter = { init = init, func = filter }, processor = processor }
