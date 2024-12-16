## LUA RUNTIME

With most plugin managers, you can simply add a plugin spec to import a plugin 
locally like this:

```lua
return {
    { dir = "~/projects/myplugin.nvim" }
}
```
The important thing in the project structure is : 

1. plugin folder will be executed before entering the neovim UI. 
2. lua folder will hold every function we need to configure our plugin. 

The thing for the moment is that we don't need that much of the plugin folder,
other than to allow a debugging mode to avoir restarting neovim each time we try
to modify our config.

The lua folder is the one that will be added to the Lua runtime. 

## PLUGIN ARCHITECTURE

As mentioned above :

```
myplugin.nvim/
  |
  |--lua/
  |----myplugin/
  |--------init.lua
  |--------util.lua
  |--plugin/
  |--------keymaps.lua
  |--------autocommands.lua
```

With this, we can require "myplugin". It will either look for lua/myplugin.lua
or lua/myplugin/init.lua

`require "myplugin.util"` will now load the file util.lua

the plugin subfolder doesn't need to be added since the package manager will
already try to execute the files in the subfolder. 
(technically speaking, it's mostly the 

## LUA MODULES

In lua, you usually define a local M as a table and add some functions to it,
exposing it's API whenever you require the file once per load.

## NVIM GLOBALS

When developping plugins, it's often useful to understand that printing will 
print the address of a table, unless you try to print an object with vim.inspect

By creating a global function (in "$NVIM_CONFIG/lua/globals.lua" required in 
"$NVIM_CONFIG/init.lua" in my case), we can create something like 

```lua
P = function(v)
    print(vim.inspect(v))
    return v
end
```
And now we can call P(some table).

## LUA LOOP

when iterating over a table, lua will under the hood do something like this :

```lua
while true
    next = table.next()
    if next = nil
        break
    end
end
```

this is accessed through an iterator of lua. If you want to iterate like in an
array, you use ipairs, otherwise use pairs to get the key, value, nil such as :

```vimdocs
pairs({t})                                              *pairs()*
        Returns three values: the |next()| function, the table {t}, and `nil`,
        so that the construction

               `for k,v in pairs(t) do`  `body`  `end`

        will iterate over all key-value pairs of table {t}.
```

and for ipairs: 

```vimdocs
ipairs({t})                                             *ipairs()*
        Returns three values: an |iterator| function, the table {t}, and 0, so
        that the construction

               `for i,v in ipairs(t) do`  `body`  `end`

        will iterate over the pairs (`1,t[1]`), (`2,t[2]`), ..., up to the
        first integer key absent from the table.

```
Here order is guaranteed
