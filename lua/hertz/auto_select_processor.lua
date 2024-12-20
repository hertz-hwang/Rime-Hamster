-- auto_select_processor.lua
-- encoding: utf-8
-- CC-BY-4.0

-- 分割字符串的辅助函数
-- @param str 要分割的字符串
-- @param delimiter 分隔符
-- @return 分割后的数组
function split(str,delimiter)
  local dLen = string.len(delimiter)
  local newDeli = ''
  -- 将分隔符转换为正则表达式格式
  for i=1,dLen,1 do
      newDeli = newDeli .. "["..string.sub(delimiter,i,i).."]"
  end

  local locaStart,locaEnd = string.find(str,newDeli)
  local arr = {}
  local n = 1
  -- 循环查找分隔符并分割字符串
  while locaStart ~= nil
  do
      if locaStart>0 then
          arr[n] = string.sub(str,1,locaStart-1)
          n = n + 1
      end

      str = string.sub(str,locaEnd+1,string.len(str))
      locaStart,locaEnd = string.find(str,newDeli)
  end
  if str ~= nil then
      arr[n] = str
  end
  return arr
end

-- 检查最后一个字符是否为空格(_)
function last_code_is_space(script_text) 
  if (string.sub(script_text,-1) == '_') then
    return true
  else
    return false
  end
end

-- 检查最后一个字符是否为分号(;)
function last_code_is_semicolon(script_text) 
  if (string.sub(script_text,-1) == ';') then
    return true
  else
    return false
  end
end

-- 检查最后一个字符是否为上屏键(空格或分号)
function last_code_is_commitkey(script_text) 
  if (last_code_is_semicolon(script_text) or last_code_is_space(script_text)) then
    return true
  else
    return false
  end
end

-- 主要的自动选择处理函数
local function auto_select(key, env)
  local engine = env.engine
  local context = engine.context
  local config = engine.schema.config
  local len = #env.engine.context.input
  -- 获取配置项：自动上屏码长
  local auto_code = tonumber(config:get_string('speller/auto_code')) or 4
  -- 获取配置项：是否启用自动选择词组
  local auto_select_phrase = config:get_string('speller/auto_select_phrase') or 'false'
  
  -- 定义上屏键
  local commit_key = 'space' 
  local commit_key_code = '_' 
  local commit_key_semicolon = 'semicolon'
  local commit_key_semicolon_code = ';'
  local commit_key_apostrophe = 'apostrophe'
  local commit_key_flag = false
  
  -- 获取输入方案的字母表
  local alphabet = config:get_string('speller/alphabet')
  local found_match_flag = false -- 标记是否找到匹配的字母

  -- 检查输入的键是否在字母表中
  for i = 1, #alphabet do
    if key:repr() == string.sub(alphabet, i, i) then
      found_match_flag = true
      break
    end
  end

  -- 如果输入的不是字母表中的字符，接受该按键
  if (not found_match_flag) then
    return 2 -- kAccepted
  end

  -- 检查是否按下了上屏键
  if (key:repr() == commit_key or key:repr() == commit_key_semicolon or key:repr() == commit_key_apostrophe) then
    commit_key_flag = true
  end

  -- 自动选择词组的处理逻辑
  if(auto_select_phrase == 'true') then
    -- 处理单字符输入
    if (len <= 1 and commit_key_flag) then
      -- 根据不同的上屏键添加相应的符号
      if (key:repr() == commit_key_semicolon) then
        context:push_input(';')   
      end
      if (key:repr() == commit_key_apostrophe) then
        context:push_input("'")  
      end
      if (key:repr() == commit_key) then
        context:push_input(" ")  
      end
      local commit_text = context:get_commit_text()
      engine:commit_text(commit_text)
      context:clear()
      return 1 -- kAccepted
    end

    -- 处理多字符输入
    if (len > 1 and commit_key_flag) then
      if (key:repr() == commit_key_semicolon) then
        context:push_input(';')   
      end
      if (key:repr() == commit_key_apostrophe) then
        context:push_input("'")  
      end
      if (context:has_menu() == false)then     --如果没有对应的词汇就去掉空格直到有一个对应的词为止
        context:pop_input(1) 
      end
      local commit_text = context:get_commit_text()
      engine:commit_text(commit_text)
      context:clear()
      return 1 -- kAccepted
    end
  end

  -- 顶功码上屏处理逻辑
  local script_text = context:get_script_text()    -- 获取带分词的编码
  split_text = {}                                  -- 初始化编码数组
  split_text = split(script_text, " ")             -- 以空格分割编码

  if (auto_code ~= 0 and len >= auto_code ) then
    -- 处理5码以上的输入
    if (len >= 5) then
      context:pop_input(1)
      local script_text1 = context:get_script_text()
      split_text1 = {}                                  --命名编码数组
      split_text1 = split(script_text1, " ")             --以空格分割编码，放入命名好的数组内

      context:pop_input(1)
      local script_text2 = context:get_script_text()
      split_text2 = {}                                  --命名编码数组
      split_text2 = split(script_text2, " ")             --以空格分割编码，放入命名好的数组内
      
      context:pop_input(1)
      local script_text3 = context:get_script_text()
      split_text3 = {}                                  --命名编码数组
      split_text3 = split(script_text3, " ")             --以空格分割编码，放入命名好的数组内

      context:pop_input(1)
      local script_text4 = context:get_script_text()
      split_text4 = {}                                  --命名编码数组
      split_text4 = split(script_text4, " ")             --以空格分割编码，放入命名好的数组内
      local position = 4

      
      local spilt_position = #split_text4
      for i=1, #split_text4-1 do
        if (#split_text[i] ~= #split_text1[i] or #split_text1[i] ~= #split_text2[i] or #split_text2[i] ~= #split_text3[i] or #split_text3[i] ~= #split_text4[i]) then
          spilt_position = i
          break
        else
          position = #split_text[i] + position
        end
      end

      context:pop_input(len-position)

      local commit_text = context:get_commit_text()
      engine:commit_text(commit_text)
      context:clear()
      for i=spilt_position,#split_text do
        context:push_input(split_text[i]) 
      end
      return 2
    end
  end

  -- 处理连按两次上屏键的情况
  if (commit_key_flag) then
    if (last_code_is_commitkey(script_text)) then
      local commit_text = context:get_commit_text()
      engine:commit_text(commit_text)
      context:clear()
      return 1
    end
  end

  return 2 -- kNoop (不做任何操作)
end

return auto_select