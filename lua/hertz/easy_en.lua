-- easy_en.lua
-- encoding: utf-8
-- CC-BY-4.0

local is_split_sentence
local wordninja_split
local dict = {}
local max_word_len = 0
local length_bonus = 4

local function capture(cmd)
   local f = assert(io.popen(cmd, 'r'))
   local s = assert(f:read('*a'))
   f:close()
   return s
end

-- 添加日志函数
-- local function -- log_info(message)
--     local f = io.open("/tmp/rime_debug.txt", "a")
--     if f then
--         f:write(os.date("%Y-%m-%d %H:%M:%S") .. " " .. tostring(message) .. "\n")
--         f:close()
--     end
-- end

-- 加载词典
local function load_dict()
    -- log_info("开始加载词典")
    
    -- 获取 Rime 用户目录
    local user_dir = rime_api.get_user_data_dir()
    local shared_dir = rime_api.get_shared_data_dir()
    
    -- 定义词典文件路径
    local dict_paths = {
        user_dir .. "/dicts/en_base.dict.yaml",
        user_dir .. "/dicts/en_custom.dict.yaml",
        shared_dir .. "/dicts/en_base.dict.yaml",
        shared_dir .. "/dicts/en_custom.dict.yaml"
    }
    
    local loaded = false
    -- 遍历所有可能的词典路径
    for _, dict_path in ipairs(dict_paths) do
        local dict_file = io.open(dict_path, "r")
        if dict_file then
            -- 跳过yaml头部（直到找到...行）
            local in_header = true
            for line in dict_file:lines() do
                if in_header then
                    if line:match("^%.%.%.$") then
                        in_header = false
                    end
                else
                    local word = line:match("^([^%s]+)")
                    if word and word:match("^[%a]+$") then
                        dict[word:lower()] = true
                        max_word_len = math.max(max_word_len, #word)
                    end
                end
            end
            dict_file:close()
            loaded = true
        end
    end
    
    return loaded
end

-- 动态规划分词
local function split_sentence(text)
    -- log_info("开始分词: " .. text)
    if #text == 0 then return text end
    
    text = text:lower()
    local n = #text
    local dp = {} -- dp[i]表示到位置i的最佳分词得分
    local prev = {} -- 记录最佳分词点
    
    -- 初始化
    for i = 0, n do
        dp[i] = -math.huge
        prev[i] = 0
    end
    dp[0] = 0
    
    -- 动态规划填表
    for i = 1, n do
        -- 尝试以位置i结尾的所有可能单词
        for j = math.max(1, i - max_word_len), i do
            local word = text:sub(j, i)
            if dict[word] then
                local score = dp[j-1] + (#word * #word) + (length_bonus * (#word - 1))
                if score > dp[i] then
                    dp[i] = score
                    prev[i] = j
                end
            end
        end
        
        -- 如果没有找到匹配的单词，允许单个字母
        if dp[i] == -math.huge then
            dp[i] = dp[i-1] - 1
            prev[i] = i
        end
    end
    
    -- 回溯构建结果
    local result = {}
    local pos = n
    while pos > 0 do
        local start = prev[pos]
        table.insert(result, 1, text:sub(start, pos))
        pos = start - 1
    end
    
    local final_result = table.concat(result, " ")
    -- log_info("分词结果: " .. final_result)
    return final_result
end

local function init(env)
    -- log_info("初始化开始")
    is_split_sentence = env.engine.schema.config:get_bool('easy_en/split_sentence')
    -- log_info("is_split_sentence: " .. tostring(is_split_sentence))
    
    if not is_split_sentence then
        wordninja_split = function(sentence)
            return sentence
        end
        -- log_info("分词功能未启用")
        return
    end
    
    -- 加载词典
    if not load_dict() then
        wordninja_split = function(sentence)
            return sentence
        end
        -- log_info("词典加载失败")
        return
    end
    
    wordninja_split = split_sentence
    -- log_info("初始化完成")
end

local function enhance_filter(input, env)
    for cand in input:iter() do
        -- 检查是否需要分词：
        -- 1. 输入完全由英文字母组成
        -- 2. 来源是英文输入方案或带有英文标记
        local need_split = false
        if cand.text:match("^[%a%s]+$") then  -- 首先确保是纯英文输入
            if (cand.type == "table" and env.engine.context:get_option("ascii_mode")) or  -- 在英文模式下
               (cand.comment and cand.comment:find("☯")) then  -- 或带有英文标记
                need_split = true
            end
        end
        
        -- 对需要分词的情况进行处理
        if need_split and is_split_sentence then
            local sentence = wordninja_split(cand.text)
            local lower_sentence = string.lower(sentence)
            
            if (not (lower_sentence == sentence)) then
                yield(Candidate("sentence", cand.start, cand._end, lower_sentence .. " ", "💡"))
            end
            
            yield(Candidate("sentence", cand.start, cand._end, sentence .. " ", "💡"))
        else
            -- 其他情况保持原样
            yield(cand)
        end
    end
end

return { enhance_filter = { init = init, func = enhance_filter} }
