local find_map = function(lhs)
    local maps = vim.api.nvim_get_keymap('n')
    for _ ,map in ipairs(maps) do
        if map.lhs == lhs then
            return map
        end
    end
end

describe("tutorial", function()

    before_each(function()
        require"tutorial"._clear()
        -- Please don't have this mapping when we start
        pcall(vim.keymap.del,  "n", "asdfasdf")
    end)

    it("can be required", function()
        require("tutorial")
    end)

    it("Can push a single mapping", function()
        local rhs = "echo 'This is a test'"
        require("tutorial").push("test1", "n", {
            asdf = rhs
        })
        local found = find_map("asdf")
        assert.are.same(rhs, found.rhs)
    end)

    it("Can push multiple mapping", function()
        local rhs = "echo 'This is a test'"
        require("tutorial").push("test1", "n", {
            ["asdf_1"] = rhs .. "1",
            ["asdf_2"] = rhs .. "2",
        })

        local found = find_map("asdf_1")
        assert.are.same(rhs .. "1", found.rhs)

        found = find_map("asdf_2")
        assert.are.same(rhs .. "2", found.rhs)
    end)

    it("Can delete mappings after pop", function()
        local rhs = "echo 'This is a test'"
        require("tutorial").push("test1", "n", {
            asdfasdf = rhs
        })
        local found = find_map("asdfasdf")
        assert.are.same(rhs, found.rhs)

        require"tutorial".pop("test1")
        assert.are.same({}, require"tutorial"._stack)

        local after_pop = find_map("asdfasdf")
        assert.are.same(nil, after_pop)
    end)
end)
