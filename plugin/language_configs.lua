-- AUTOCOMPLETE CONFIGURATION
local cmp = require('cmp')
cmp.setup({
    sources = cmp.config.sources(
    {
        { name = 'nvim_lsp', },
        { name = 'cmp_r', },
        { name = 'luasnip', },
    },
    {
        { name = "buffer" },
    }),
    mapping = cmp.mapping.preset.insert({
        ["<C-k>"] = cmp.mapping.scroll_docs(-1),
        ["<C-j>"] = cmp.mapping.scroll_docs(1),
        ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert, }),
        ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert, }),
        ["<Tab>"] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<S-Tab>"] = nil,
    }),
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
})
cmp.setup.cmdline('/',
{
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})
cmp.setup.cmdline(':',
{
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources(
    {
        { name = 'path' }
    },
    {
        { name = 'cmdline' }
    })
})
cmp.setup.filetype({ 'lisp' }, {
    sources = {
        { name = 'nvlime' },
    }
})


-- LSP CONFIGURATION
--
--
-- LISP
-- load ciel upon starting a new session. mostly for the nicer documentation
-- (this boots sbcl and loads the ciel core image instead of the ciel binary).
vim.cmd[[
    function! NvlimeBuildServerCommandFor_ciel(nvlime_loader, nvlime_eval)
        return ["/usr/bin/sbcl",
        \ "--core", "/home/ck/quicklisp/local-projects/CIEL/ciel-core",
        \ "--load", "/home/ck/quicklisp/setup.lisp",
        \ "--load", a:nvlime_loader,
        \ "--eval", a:nvlime_eval]
    endfunction
]]
vim.g.nvlime_config = {
    leader = "<LocalLeader>",
    implementation = "ciel",
    autodoc = {
        enabled = true,
        max_level = 5,
        max_lines = 50
    },
    floating_window = {
        border = "single",
        scroll_step = 3
    },
    cmp = { enabled = true },
    arglist = { enabled = true }
}

-- Lua
-- make the lua LSP work more nicely with neovim (config taken from help page)
vim.lsp.config("lua_ls", {
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if
        path ~= vim.fn.stdpath('config')
        and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
      then
        return
      end
    end
    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        -- Tell the language server which version of Lua you're using (most
        -- likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Tell the language server how to find Lua modules same way as Neovim
        -- (see `:h lua-module-load`)
        path = {
          'lua/?.lua',
          'lua/?/init.lua',
        },
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          -- For LSP Settings Type Annotations: https://github.com/neovim/nvim-lspconfig#lsp-settings-type-annotations
          vim.api.nvim_get_runtime_file("lua/lspconfig", false)[1],
        },
      },
    })
  end,
  settings = {
    Lua = {},
  },
})

-- R
local r = require("r")
vim.g.rout_follow_colorscheme = true
r.setup({
    R_args = { "--quiet", "--no-restore", "--no-save" },
    external_term = "", -- this can be changed to open using tmux, among other choices
    rconsole_width = 15, -- making this small enough to force the console to open in a vertical split
    debug = false,
    disable_cmds = { "RInsertAssign", "RInsertPipe" },
    hook = {
        on_filetype = function()
            vim.keymap.set("n", "<C-\\>", "<Plug>RDSendLine", { buffer = true })
            vim.keymap.set("n", "<LocalLeader>:", ":RSend ", { buffer = true })
            vim.keymap.set("v", "<LocalLeader>l", "<Plug>RDSendSelection", { buffer = true })
            vim.keymap.set("n", "<LocalLeader>l", -- send the current line
                           function()
                               local lin = vim.api.nvim_get_current_line()
                               -- cmd is the module's function to send text to the terminal
                               require("r.send").cmd(lin)
                           end,
                           { buffer = true })
        end
    }
})

-- when you need to get more LSPs set up, this link should help you
-- https://www.andersevenrud.net/neovim.github.io/lsp/configurations/
vim.lsp.enable("awk_ls")
vim.lsp.enable("basedpyright")
vim.lsp.enable("bashls")
vim.lsp.enable("lua_ls")
vim.lsp.enable("r_language_server")
vim.lsp.enable("sqlls")
vim.lsp.enable("vimls")
