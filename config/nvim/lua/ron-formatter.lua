local M = {}

local MAX_LINE = 100
local INDENT = "    "

local function tokenize(text)
    local tokens = {}
    local i = 1
    local len = #text
    local line = 1
    while i <= len do
        local c = text:sub(i, i)
        if c == '\n' then
            line = line + 1
            i = i + 1
        elseif c:match('%s') then
            i = i + 1
        elseif c == '/' and text:sub(i + 1, i + 1) == '/' then
            local j = i
            while j <= len and text:sub(j, j) ~= '\n' do j = j + 1 end
            table.insert(tokens, { t = 'c', v = text:sub(i, j - 1), line = line })
            i = j
        elseif c == '"' then
            local j = i + 1
            while j <= len do
                if text:sub(j, j) == '\\' then
                    j = j + 2
                elseif text:sub(j, j) == '"' then
                    break
                else
                    j = j + 1
                end
            end
            table.insert(tokens, { t = 's', v = text:sub(i, j), line = line })
            i = j + 1
        elseif c:match('[%d]') or (c == '-' and i < len and text:sub(i + 1, i + 1):match('[%d]')) then
            local j = i + 1
            while j <= len and text:sub(j, j):match('[%d%.eE_]') do j = j + 1 end
            table.insert(tokens, { t = 'n', v = text:sub(i, j - 1), line = line })
            i = j
        elseif c:match('[%a_]') then
            local j = i + 1
            while j <= len and text:sub(j, j):match('[%w_]') do j = j + 1 end
            table.insert(tokens, { t = 'i', v = text:sub(i, j - 1), line = line })
            i = j
        elseif c:match('[{}%[%]():,]') then
            table.insert(tokens, { t = 'p', v = c, line = line })
            i = i + 1
        else
            i = i + 1
        end
    end
    return tokens
end

local pos
local function peek(tokens) return tokens[pos] end
local function advance(tokens)
    local t = tokens[pos]; pos = pos + 1; return t
end

local parse_value

local function collect_leading_comments(tokens)
    local comments = {}
    while peek(tokens) and peek(tokens).t == 'c' do
        table.insert(comments, advance(tokens).v)
    end
    return comments
end

local function parse_entries(tokens, close)
    local entries = {}
    while peek(tokens) and peek(tokens).v ~= close do
        local leading = collect_leading_comments(tokens)
        if peek(tokens) and peek(tokens).v == close then
            if #entries > 0 then entries[#entries].dangling = leading end
            break
        end

        local first = parse_value(tokens)
        local entry
        if peek(tokens) and peek(tokens).v == ':' then
            advance(tokens)
            local val = parse_value(tokens)
            entry = { k = first, v = val, leading = leading }
        else
            entry = { v = first, leading = leading }
        end

        local value_line = tokens[pos - 1] and tokens[pos - 1].line
        if peek(tokens) and peek(tokens).v == ',' then
            local comma_line = peek(tokens).line
            advance(tokens)
            if peek(tokens) and peek(tokens).t == 'c' and peek(tokens).line == comma_line then
                entry.trailing = advance(tokens).v
            end
        elseif peek(tokens) and peek(tokens).t == 'c' and value_line and peek(tokens).line == value_line then
            entry.trailing = advance(tokens).v
        end

        table.insert(entries, entry)
    end
    if peek(tokens) and peek(tokens).v == close then advance(tokens) end
    return entries
end

parse_value = function(tokens)
    local tok = peek(tokens)
    if not tok then return { t = 'a', v = '' } end

    if tok.v == '{' then
        advance(tokens)
        return { t = 'map', entries = parse_entries(tokens, '}') }
    elseif tok.v == '(' then
        advance(tokens)
        return { t = 'tup', name = nil, entries = parse_entries(tokens, ')') }
    elseif tok.v == '[' then
        advance(tokens)
        return { t = 'list', entries = parse_entries(tokens, ']') }
    elseif tok.t == 'i' then
        advance(tokens)
        if peek(tokens) and peek(tokens).v == '(' then
            advance(tokens)
            return { t = 'tup', name = tok.v, entries = parse_entries(tokens, ')') }
        end
        return { t = 'a', v = tok.v }
    else
        advance(tokens)
        return { t = 'a', v = tok.v }
    end
end

local function render_inline(node)
    if node.t == 'a' then return node.v end

    local parts = {}
    for _, e in ipairs(node.entries) do
        if e.k then
            table.insert(parts, render_inline(e.k) .. ": " .. render_inline(e.v))
        else
            table.insert(parts, render_inline(e.v))
        end
    end
    local inner = table.concat(parts, ", ")

    if node.t == 'map' then
        return "{ " .. inner .. " }"
    elseif node.t == 'tup' then
        return (node.name or "") .. "(" .. inner .. ")"
    elseif node.t == 'list' then
        return "[" .. inner .. "]"
    end
    return ""
end

local function has_comments(node)
    for _, e in ipairs(node.entries or {}) do
        if (e.leading and #e.leading > 0) or e.trailing or (e.dangling and #e.dangling > 0) then
            return true
        end
    end
    return false
end

local function render(node, depth)
    if node.t == 'a' then return node.v end

    local inline = render_inline(node)
    if not has_comments(node) and depth * 4 + #inline <= MAX_LINE and not (node.t == 'map' and depth == 0) then
        return inline
    end

    local ind = string.rep(INDENT, depth + 1)
    local ind_close = string.rep(INDENT, depth)

    local open, close
    if node.t == 'map' then
        open, close = "{", "}"
    elseif node.t == 'tup' then
        open, close = (node.name or "") .. "(", ")"
    elseif node.t == 'list' then
        open, close = "[", "]"
    end

    local lines = { open }
    for _, e in ipairs(node.entries) do
        if e.leading then
            for _, c in ipairs(e.leading) do table.insert(lines, ind .. c) end
        end

        local line
        if e.k then
            local key = render_inline(e.k)
            local val = render(e.v, depth + 1)
            line = ind .. key .. ": " .. val .. ","
        else
            line = ind .. render(e.v, depth + 1) .. ","
        end
        if e.trailing then line = line .. " " .. e.trailing end
        table.insert(lines, line)

        if e.dangling then
            for _, c in ipairs(e.dangling) do table.insert(lines, ind .. c) end
        end
    end
    table.insert(lines, ind_close .. close)
    return table.concat(lines, "\n")
end

function M.format(text)
    local tokens = tokenize(text)
    if #tokens == 0 then return text end
    pos = 1
    local header = collect_leading_comments(tokens)
    local tree = parse_value(tokens)
    local footer = collect_leading_comments(tokens)

    local parts = {}
    for _, c in ipairs(header) do table.insert(parts, c) end
    table.insert(parts, render(tree, 0))
    for _, c in ipairs(footer) do table.insert(parts, c) end
    return table.concat(parts, "\n") .. "\n"
end

function M.format_buffer()
    local buf = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    local text = table.concat(lines, "\n")
    local ok, result = pcall(M.format, text)
    if ok and result then
        local new_lines = vim.split(result, "\n", { trimempty = false })
        if new_lines[#new_lines] == "" then table.remove(new_lines) end
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, new_lines)
    else
        print("RON format error: " .. tostring(result))
    end
end

return M
