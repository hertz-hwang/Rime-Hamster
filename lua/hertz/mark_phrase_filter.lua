local function filter(input, env)
    for cand in input:iter() do
        -- 检查是否既不是 table 类型也不是 phrase 类型
        if (cand.type ~= "table" and cand.type ~= "phrase") then
            -- 在注释后添加虎头Emoji
            cand.comment = (cand.comment or "") .. "⚡[🐯]"
        end
        yield(cand)
    end
end

return filter