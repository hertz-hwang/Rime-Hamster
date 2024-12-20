-- inline_candidate_filter.lua
-- encoding: utf-8
-- CC-BY-4.0

-- 加载自定义拆分表
local spelling_table = require("tiger.spelling_table")

local function filter(input)
    for cand in input:iter() do
        local text = cand:get_genuine().text
        local spellings = {}
        
        -- 遍历词组中的每个字
        for char in text:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
            -- 从拆分表中获取每个字的拆分，如果没有则使用字本身
            local spelling = spelling_table[char] or char
            table.insert(spellings, spelling)
        end
        
        -- 用空格连接所有拆分
        cand:get_genuine().preedit = table.concat(spellings, " ")
        yield(cand)
    end
end

return filter