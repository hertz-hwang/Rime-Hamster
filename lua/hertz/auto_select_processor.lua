-- 使得处理器能够处理上屏
function split(str,delimiter)
  local dLen = string.len(delimiter)
  local newDeli = ''
  for i=1,dLen,1 do
      newDeli = newDeli .. "["..string.sub(delimiter,i,i).."]"
  end

  local locaStart,locaEnd = string.find(str,newDeli)
  local arr = {}
  local n = 1
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

function last_code_is_space(script_text) 
  if (string.sub(script_text,-1) == '_') then
    return true
  else
    return false
  end
end

function last_code_is_semicolon(script_text) 
  if (string.sub(script_text,-1) == ';') then
    return true
  else
    return false
  end
end

function last_code_is_commitkey(script_text) 
  if (last_code_is_semicolon(script_text) or last_code_is_space(script_text)) then
    return true
  else
    return false
  end
end

-- function recoginze_2_split(int1,int2)              --识别2码切分
--   local script_text = context:get_script_text()    --获取带分词的编码
--   split_text = {}                                  --命名编码数组
--   split_text = split(script_text, " ")             --以空格分割编码，放入命名好的数组内
--   if(#split_text>=2 and #split_text[#split_text-1] == int1 and #split_text[#split_text] == int2)then  
--     return true
--   else
--     return false
--   end
-- end

-- function recoginze_3_split(int1,int2,int3)         --识别3码切分
--   local script_text = context:get_script_text()    --获取带分词的编码
--   split_text = {}                                  --命名编码数组
--   split_text = split(script_text, " ")             --以空格分割编码，放入命名好的数组内
--   if(#split_text>=3 and #split_text[#split_text-2] == int1 and #split_text[#split_text-1] == int2 and #split_text[#split_text] == int3)then  
--     return true
--   else
--     return false
--   end
-- end

-- function recoginze_4_split(int1,int2,int3,int4)         --识别4码切分
--   local script_text = context:get_script_text()    --获取带分词的编码
--   split_text = {}                                  --命名编码数组
--   split_text = split(script_text, " ")             --以空格分割编码，放入命名好的数组内
--   if(#split_text>=4 and #split_text[#split_text-3] == int1 and #split_text[#split_text-2] == int2 and #split_text[#split_text-1] == int3 and #split_text[#split_text] == int4)then  
--     return true
--   else
--     return false
--   end
-- end

local function auto_select_phrase(key, env)
  local engine = env.engine
  local context = engine.context
  local config = engine.schema.config
  local len = #env.engine.context.input
  local length_limit = tonumber(config:get_string('speller/length_limit')) or 999          --------------------设定输入上限
  local auto_select_phrase = config:get_string('speller/auto_select_phrase') or 'false'    --------------------是否自动上屏
  local auto_select_simple_code = config:get_string('speller/auto_select_simple_code') or 'true'   ------------前两码是否自动上屏
  local mannal_43_split = config:get_string('speller/mannal_43_split') or 'true'                   ------------是否识别43切分为331
  local auto_43_split = config:get_string('speller/auto_43_split') or 'true'               --------------------手动或自动识别43切分为331
  local auto_code = tonumber(config:get_string('speller/auto_code')) or 4                  --------------------手动或自动识别上屏
  local commit_key = 'space' 
  local commit_key_code = '_' 
  local commit_key_semicolon = 'semicolon'
  local commit_key_semicolon_code = ';'
  local commit_key_apostrophe = 'apostrophe'
  local commit_key_flag = false
  local script_text = context:get_script_text()

  if(length_limit~=nil) then                                         --限定输入的长度上限
    if(len > length_limit)  then
      context:pop_input(1)
    end
  end

  if (key:repr() == commit_key or key:repr() == commit_key_semicolon or key:repr() == commit_key_apostrophe) then                --判断当前输入是否为空格或分号
    if (key:repr() == commit_key_apostrophe) then                --判断当前输入是否为空格或分号
      local commit_text = context:get_commit_text()
      engine:commit_text(commit_text)
      context:clear()
      return 1 -- kAccepted
    end
    commit_key_flag = true
  end

  if(auto_select_phrase == 'true') then                          --------------------------------------简码自动上屏
    if (len ~= 0 and commit_key_flag) then                        -------------------------------------简码自动上屏功能
      local script_text = context:get_script_text()
      split_text = {}
      split_text = split(script_text, " ")                        --以空格分割字符串b，放入表里面

      if(#split_text[#split_text] == 4) then                    --如果末位的长度等于4
        if (key:repr() == commit_key) then                      --那么输入空格
          context:push_input('_')  
        end
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
      else
        local script_text = context:get_script_text()    --获取带分词的编码
        split_text = {}                                  --命名编码数组
        split_text = split(script_text, " ")             --以空格分割编码，放入命名好的数组内
        -- if(#split_text>=1 and #split_text[#split_text] >= 5)then     --x5上屏
        --   if (context:has_menu() == false)then     --如果没有对应的词汇就去掉空格直到有一个对应的词为止
        --     if (key:repr() == commit_key) then                      --那么输入空格
        --       context:push_input('_')  
        --     end
        --     if (key:repr() == commit_key_semicolon) then
        --       context:push_input(';')   
        --     end
        --   end
        --   local commit_text = context:get_commit_text()
        --   engine:commit_text(commit_text)
        --   context:clear()
        --   return 1 -- kAccepted
        -- end
        -- if (key:repr() == commit_key) then                      --那么输入空格
        --   context:push_input('_')  
        -- end
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
  end

  local script_text = context:get_script_text()    --获取带分词的编码
  split_text = {}                                  --命名编码数组
  split_text = split(script_text, " ")             --以空格分割编码，放入命名好的数组内
  -- if (auto_select_phrase == 'true' and #split_text[#split_text] >= 7 and commit_key_flag) then                        -------------------------------------简码自动上屏功能
  --   if (key:repr() == commit_key_semicolon) then
  --     context:push_input(';')   
  --   end
  --   local commit_text = context:get_commit_text()
  --   engine:commit_text(commit_text)
  --   context:clear()
  --   return 1 -- kAccepted
  -- end
  if (auto_code ~= 0 and len >= auto_code ) then                                                  ------------------------------------顶功码上屏
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
        if (split_text[i] ~= split_text1[i] or split_text1[i] ~= split_text2[i] or split_text2[i] ~= split_text3[i] or split_text3[i] ~= split_text4[i]) then

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

    -- if(#split_text>=2 and #split_text[#split_text-1] == 2 and #split_text[#split_text] == 1)then  --x21上屏留3
    --   context:pop_input(#split_text[#split_text-1])
    --   context:pop_input(#split_text[#split_text])
    --   local commit_text = context:get_commit_text()
    --   engine:commit_text(commit_text)
    --   context:clear()
    --   context:push_input(split_text[#split_text-1]) 
    --   context:push_input(split_text[#split_text]) 
    --   return 2 -- kAccepted
    -- elseif(#split_text>=2 and #split_text[#split_text-1] == 3 and #split_text[#split_text] == 1)then  --x11上屏留2
    --   context:pop_input(#split_text[#split_text])
    --   local commit_text = context:get_commit_text()
    --   engine:commit_text(commit_text)
    --   context:clear()
    --   context:push_input(split_text[#split_text]) 
    --   return 2 -- kAccepted
    -- elseif(#split_text>=2 and #split_text[#split_text-1] == 1 and #split_text[#split_text] == 1)then  --x11上屏留2
    --   context:pop_input(#split_text[#split_text-1])
    --   context:pop_input(#split_text[#split_text])
    --   local commit_text = context:get_commit_text()
    --   engine:commit_text(commit_text)
    --   context:clear()
    --   context:push_input(split_text[#split_text-1]) 
    --   context:push_input(split_text[#split_text]) 
    --   return 2 -- kAccepted
    -- elseif(string.sub(split_text[#split_text],-1) == "'")then  --x'上屏
    --   local commit_text = context:get_commit_text()
    --   engine:commit_text(commit_text)
    --   context:clear()
    --   return 2 -- kAccepted
    -- elseif(#split_text>=2 and #split_text[#split_text] >= 7)then     --x7上屏
    --   local commit_text = context:get_commit_text()
    --   engine:commit_text(commit_text)
    --   context:clear()
    --   return 2 -- kAccepted
    -- elseif(#split_text>=2 and #split_text[#split_text] >= 2)then     --x2上屏
    --   context:pop_input(#split_text[#split_text])
    --   local commit_text = context:get_commit_text()
    --   engine:commit_text(commit_text)
    --   context:clear()
    --   context:push_input(split_text[#split_text]) 
    --   return 2 -- kAccepted
    -- else
    --   -- local commit_text = context:get_commit_text()
    --   -- engine:commit_text(commit_text)
    --   -- context:clear()
    --   return 2 -- kAccepted
    -- end
  end

  if(auto_select_phrase ~= 'true') then
    if (mannal_43_split == 'true' and auto_43_split == 'true') then                             --------------------------------------43切
      if(key:repr() == 'BackSpace') then                 --覆写332的删除
        local script_text = context:get_script_text()    --获取带分词的编码
        split_text = {}                                  --命名编码数组
        split_text = split(script_text, " ")             --以空格分割编码，放入命名好的数组内
        if(#split_text>=3) then                          --如果末位的切分片段大于3位
          if(#split_text[#split_text-2] == 3 and #split_text[#split_text-1] == 3 and #split_text[#split_text] == 2) then      --如果末位的切分长度为332
            if (string.sub(script_text,-1) == '_' or string.sub(script_text,-1) == ';') then    --如果末位是空格或分号
              context:pop_input(2)
              return 1 -- kAccepted
            end
          end
        elseif(#split_text>=2 and #split_text[#split_text-1] == 5 and string.sub(split_text[#split_text-1],-1) == "'" and #split_text[#split_text] == 3)then   --去除'引号
          context:pop_input(4)
          context:push_input(split_text[#split_text])
          return 1 -- kAccepted
        end
      end

      if (len >= 7 and key:repr() ~= 'BackSpace') then                                          --如果编码的长度大于等于7
        local script_text = context:get_script_text()    --获取带分词的编码
        split_text = {}                                  --命名编码数组
        split_text = split(script_text, " ")             --以空格分割编码，放入命名好的数组内
        if(#split_text ~= 0) then                        --如果末位的切分片段不是零位
          if(#split_text[#split_text] == 3) then         --如果末位的切分长度为3码
            if(#split_text>=2 and #split_text[#split_text-1] == 4) then                         --如果倒数第二位的切分长度为4码，也就是43切分
              context:push_input('_')
              local script_text = context:get_script_text()    --获取带分词的编码
              split_text = {}                                  --命名编码数组
              split_text = split(script_text, " ")             --以空格分割编码，放入命名好的数组内
              if(#split_text>=3)then
                if (#split_text[#split_text-2] ~= 3 or #split_text[#split_text-1] ~= 3 or #split_text[#split_text] ~= 2) then    --如果末位的切分长度为422
                  context:pop_input(1)
                end
              end
            end
          end
        end
      end
    end

    if (len ~= 0 and commit_key_flag) then              --判断最后切分片段的输入结果

      if(auto_select_simple_code == 'true') then        --2简自动上屏
        if (len == 1 or len ==2) then                   --如果输入的是一简二简字则立刻上屏
          if (key:repr() == commit_key) then  
            context:push_input('_')  
          end
          if (key:repr() == commit_key_semicolon) then
            context:push_input(';')   
          end
          local commit_text = context:get_commit_text()
          engine:commit_text(commit_text)
          context:clear()
          return 1 -- kAccepted
        end
      end

      local script_text = context:get_script_text()    --获取带分词的编码
      split_text = {}                                  --命名编码数组
      split_text = split(script_text, " ")             --以空格分割编码，放入命名好的数组内
      if(#split_text ~= 0) then                        --如果末位的切分片段不是零位
        if(#split_text[#split_text] == 2) then         --如果末位的切分长度为2
          if(#split_text>=3) then
            if(#split_text[#split_text-2] == 3 and #split_text[#split_text-1] == 3) then                         --如果末位的切分长度为332
              if (key:repr() == commit_key_semicolon and last_code_is_semicolon(script_text) ~= true) then       --替换为分号h
                context:pop_input(1)
                return 2 -- kNoop
              end
            elseif(#split_text[#split_text-2] == 4 and #split_text[#split_text-1] == 4)then   --如果末位的切分长度为442
              if (auto_9_code == 'true' and len == 9) then  
                engine:commit_text(commit_text)
                context:clear()
                return 1 -- kAccepted
              end
            end
          end
        elseif(#split_text[#split_text] == 3) then                                          --如果末位的切分长度为3码
          if(#split_text>=2 and #split_text[#split_text-1] == 4 and mannal_43_split == 'true')then       ------------------------------43切是否开启
            return 2 -- kNoop
          else                                                                              --非43分词的情况，3码则直接上屏
            local commit_text = context:get_commit_text()
            if (key:repr() == commit_key) then                                              --输入空格
              context:push_input('_')  
            end
            if (key:repr() == commit_key_semicolon) then                                    --输入分号
              context:push_input(';')   
            end
            local script_text = context:get_script_text()    --获取带分词的编码
            split_text = {}                                  --命名编码数组
            split_text = split(script_text, " ")             --以空格分割编码，放入命名好的数组内
            context:pop_input(1)
            if(#split_text>=3) then
              if(#split_text[#split_text-2] ~= 1 and #split_text[#split_text-1] ~= 1 and #split_text[#split_text] ~= 2) then    --如果末位的切分长度不为112就不回退
                do end
              elseif(#split_text[#split_text-1] ~= 2 and #split_text[#split_text] ~= 2) then   --如果末位的切分长度不为22就不回退
                do end
              else
                engine:commit_text(commit_text)
                context:clear()
                return 1 -- kAccepted
              end
              return 2
            else
              engine:commit_text(commit_text)
              context:clear()
              return 1 -- kAccepted
            end
          end
        elseif( #split_text[#split_text] == 5 )then
          local commit_text = context:get_commit_text()
          engine:commit_text(commit_text)
          context:clear()
          return 1 -- kAccepted
        elseif( #split_text[#split_text] == 6 or #split_text[#split_text] == 7) then         --6,7码词，视情况分词
          if (string.find(split_text[#split_text],'_') == nil) then
            local commit_text = context:get_commit_text()
            engine:commit_text(commit_text)
            context:clear()
            return 1 -- kAccepted
          else                                                                              --如果出现43分词，默认切分成331
            if (key:repr() == commit_key) then                                              --输入空格
              context:push_input('_')  
            end
            if (key:repr() == commit_key_semicolon) then                                    --输入分号
              context:push_input(';')   
            end
            local commit_text = context:get_commit_text()
            engine:commit_text(commit_text)
            context:clear()
            return 1 -- kAccepted
          end
        elseif( #split_text[#split_text] > 7) then                                            --8码以上词，直接上屏
          local commit_text = context:get_commit_text()
          engine:commit_text(commit_text)
          context:clear()
          return 1 -- kAccepted
        end
      end
    end

    -- if(len ~= 0 and context:has_menu() == false) then                                -- 空格识别无重码上屏
    --   local script_text = context:get_script_text()
    --   local last_key = string.sub(script_text,-1)
    --   if(len ~= 0 and context:has_menu() == false) then                              --如果没有对应的词汇就去掉空格直到有一个对应的词为止
    --     if #context:get_commit_text() == 1 then
    --       engine:commit_text(commit_text)
    --       context:clear()
    --       return 1
    --     end
    --     context:pop_input(1)
    --   end
    --   local commit_text = context:get_commit_text()
    --   engine:commit_text(commit_text)
    --   context:clear()
    --   if (last_key ~= '_' and last_key ~= ';')then
    --     context:push_input(last_key)
    --   end
    --   return 1 -- kAccepted
    -- end
    
    -- if (len == 5 and key:repr() ~= commit_key)then                   -- 无重码顶屏功能
    --   local script_text = context:get_script_text()
    --   if (string.find(script_text,'%s') == 5) then
    --     local last_key = string.sub(script_text,-1)
    --     context:pop_input(1)
    --     local commit_text = context:get_commit_text()
    --     engine:commit_text(commit_text)
    --     context:clear()
    --     context:push_input(last_key)
    --     return 1 -- kAccepted
    --   end
    --   return 2 -- kAccepted
    -- end

    if(last_code_is_commitkey(script_text) and key:repr() == commit_key_apostrophe) then
      split_text = {}                                  --命名编码数组
      split_text = split(script_text, " ")             --以空格分割编码，放入命名好的数组内
      if(#split_text>=3 and #split_text[#split_text-2] == 3 and #split_text[#split_text-1] == 3 and #split_text[#split_text] == 2) then                         --如果末位的切分长度为332
        context:pop_input(4)
        context:push_input("'")  
        context:push_input(string.sub(split_text[#split_text-1],2,3)) 
        context:push_input(string.sub(split_text[#split_text],0,1))  
        return 1 -- kAccepted
      else
        context:pop_input(1)
        return 2 -- kAccepted
      end
    end
  end

  if (commit_key_flag) then                                          -- 连按两次空格上屏
    local script_text = context:get_script_text()
    split_text = {}
    split_text = split(script_text, " ")             --以空格分割编码，放入命名好的数组内
    if (last_code_is_commitkey(script_text)) then
      local commit_text = context:get_commit_text()
      engine:commit_text(commit_text)
      context:clear()
      return 1
    end
  end

  return 2 -- kNoop
end

return auto_select_phrase