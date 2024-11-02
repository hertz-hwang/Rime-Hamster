local function filter(input)
    for cand in input:iter() do
        cand:get_genuine().preedit = cand.text
        yield(cand)
    end
end
return filter