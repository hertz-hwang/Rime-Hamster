-- popping.lua
-- encoding: utf-8
-- CC-BY-4.0

-- 顶功处理器
-- 通用（不包含声笔系列码的特殊逻辑）
-- 本处理器能够支持所有的规则顶功模式
-- 根据当前编码和新输入的按键来决定是否将当前编码或其一部分的首选顶上屏

---@class Popping 顶功处理模块
---@field init fun(env: PoppingEnv) 初始化函数
---@field func fun(key_event: KeyEvent, env: PoppingEnv): number 处理按键事件

local rime = require("hertz.lib")

-- 将策略枚举移到顶部并添加说明
---@enum PoppingStrategy
local strategies = {
  pop = "pop",         -- 直接顶屏
  append = "append",   -- 追加编码
  conditional = "conditional" -- 条件顶屏
}

-- 添加更多类型定义
---@class PoppingEnv: Env
---@field speller Processor
---@field popping PoppingConfig[]

---@class PoppingConfig
---@field when string | nil 可选的条件选项
---@field match string 匹配规则
---@field accept string 接受的输入
---@field prefix number | nil 可选的前缀长度
---@field strategy PoppingStrategy | nil 可选的策略类型

local this = {}

-- 提取选项更新处理为独立函数
---@param ctx Context
---@param name string
local function handle_option_update(ctx, name)
  if name == "is_buffered" then
    local is_buffered = ctx:get_option("is_buffered")
    ctx:set_option("_auto_commit", not is_buffered)
  end
end

-- 提取提交通知处理为独立函数
---@param ctx Context
local function handle_commit(ctx)
  if ctx:get_option("temp_buffered") then
    ctx:set_option("temp_buffered", false)
    ctx:set_option("is_buffered", false)
  end
end

---@param env PoppingEnv
function this.init(env)
  env.speller = rime.Processor(env.engine, "", "speller")
  
  -- 连接事件处理器
  env.engine.context.option_update_notifier:connect(handle_option_update)
  env.engine.context.commit_notifier:connect(handle_commit)
  
  -- 加载配置
  local config = env.engine.schema.config
  local popping_config = config:get_list("speller/popping")
  if not popping_config then
    return
  end
  
  env.popping = {}
  for i = 1, popping_config.size do
    local item = popping_config:get_at(i - 1)
    if not item then goto continue end
    
    local value = item:get_map()
    if not value then goto continue end
    
    local popping = this.parse_popping_config(value)
    if popping then
      table.insert(env.popping, popping)
    end
    
    ::continue::
  end
end

-- 提取配置解析为独立函数
---@param value any
---@return PoppingConfig|nil
function this.parse_popping_config(value)
  local popping = {
    when = value:get_value("when") and value:get_value("when"):get_string(),
    match = value:get_value("match"):get_string(),
    accept = value:get_value("accept"):get_string(),
    prefix = value:get_value("prefix") and value:get_value("prefix"):get_int(),
    strategy = value:get_value("strategy") and value:get_value("strategy"):get_string()
  }
  
  if popping.strategy and not strategies[popping.strategy] then
    rime.errorf("无效的顶功策略: %s", popping.strategy)
    return nil
  end
  
  return popping
end

-- 提取按键处理逻辑为独立函数
---@param context Context
---@param input string
---@param incoming string
---@param rule PoppingConfig
---@param is_buffered boolean
---@return boolean
local function process_popping_rule(context, input, incoming, rule, is_buffered)
  if rule.strategy == strategies.append then
    return true
  end
  
  if rule.strategy == strategies.conditional then
    context:push_input(incoming)
    if context:has_menu() then
      context:pop_input(1)
      return true
    end
    context:pop_input(1)
  end
  
  if rule.prefix then
    context:pop_input(input:len() - rule.prefix)
  end
  
  if context:has_menu() then
    context:confirm_current_selection()
    if not is_buffered then
      context:commit()
    end
    if rule.prefix then
      context:push_input(input:sub(rule.prefix + 1))
    end
    return true
  end
  
  if rule.prefix then
    context:push_input(input:sub(rule.prefix + 1))
  end
  
  return false
end

---@param key_event KeyEvent
---@param env PoppingEnv
function this.func(key_event, env)
  -- 检查基本条件
  if not (env.engine.context.composition:back():has_tag("abc") 
     or env.engine.context.composition:back():has_tag("punct")) then
    return rime.process_results.kNoop
  end
  
  if key_event:release() or key_event:alt() or key_event:ctrl() or key_event:caps() then
    return rime.process_results.kNoop
  end
  
  local context = env.engine.context
  local is_buffered = context:get_option("is_buffered")
  
  -- 获取当前输入
  local input = rime.current(context)
  if not input then
    return rime.process_results.kNoop
  end
  
  -- 处理句号键的特殊情况
  if input == "." then
    context:pop_input(1)
    input = rime.current(context)
    if not input then
      return rime.process_results.kNoop
    end
  end
  
  local incoming = utf8.char(key_event.keycode)
  
  -- 处理顶功规则
  for _, rule in ipairs(env.popping) do
    if rule.when and not context:get_option(rule.when) then
      goto continue
    end
    
    if not rime.match(input, rule.match) or not rime.match(incoming, rule.accept) then
      goto continue
    end
    
    if process_popping_rule(context, input, incoming, rule, is_buffered) then
      goto finish
    end
    
    ::continue::
  end
  
  ::finish::
  -- 处理大写字母
  if key_event.keycode >= 65 and key_event.keycode <= 90 then
    key_event = rime.KeyEvent(utf8.char(key_event.keycode + 32))
  end
  
  return env.speller:process_key_event(key_event)
end

return this
