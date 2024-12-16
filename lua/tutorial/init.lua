local M = {}

--[[
functions we need :
vim.keymap.set(...) -> create new keymaps
vim.api.nvim_get_keymap
--]]

local find_mappings = function(maps, lhs)
    for _, value in ipairs(maps) do
        if value.lhs == lhs then
            return value
        end
    end
end

M._stack = {}

M.setup = function(opts)
    print("Options :", opts)
end

M.push = function(name, mode, mappings)
    local maps = vim.api.nvim_get_keymap(mode)
    local existing_maps = {}
    for lhs, rhs in pairs(mappings) do
        local existing = find_mappings(maps, lhs)
        if existing then
            existing_maps[lhs] = existing
        end
    end
    M._stack[name] = {
        mode = mode,
        existing = existing_maps,
        mappings = mappings,
    }

    for lhs, rhs in pairs(mappings) do
        vim.keymap.set(mode, lhs, rhs)
    end
end

M.pop = function(name)
    local state = M._stack[name]
    M._stack[name] = nil

    for lhs, rhs in pairs(state.mappings) do
        if state.existing[lhs] then
            -- Handle case where this existed
            vim.keymap.del(state.mode, lhs)
        else
            -- Handle case where this did not
        end
    end
end

M.push("debug_mode", "n", {
    [" st"] = "echo 'Hello'",
    [" sz"] = "echo 'Goodbye'",
    [" ps"] = "echo 'Goodbye'",
})

M._clear = function()
    M._stack = {}
end
--[[
local tuto = require("tutorial", 'n', {
    ["<leader>st"] = "echo 'Hello'",
    ["<leader>sz"] = "echo 'Goodbye'",
})

tuto.push("debug_mode", ")
tuto.pop("debug_mode")
--]]

return M
