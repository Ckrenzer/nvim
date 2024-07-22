require("nvim-treesitter.configs").setup({
    -- A list of parser names, or "all"
    -- (the listed parsers should always be installed)
    ensure_installed = {
        "awk",
        "c",
        "commonlisp",
        "julia",
        "lua",
        "markdown",
        "python",
        "r",
        "rnoweb",
        "vim",
    },
    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,
    -- Automatically install missing parsers when entering buffer
    auto_install = true,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    lazy = false,
})

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
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
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

-- when you need to get more LSPs set up, this link should help you
-- https://www.andersevenrud.net/neovim.github.io/lsp/configurations/
local lsp = require("lspconfig")
lsp.awk_ls.setup{}
lsp.bashls.setup{}
lsp.pyright.setup{}
lsp.lua_ls.setup{}
lsp.r_language_server.setup{}
lsp.sqlls.setup{}
lsp.vimls.setup{}

local r = require("r")
vim.g.rout_follow_colorscheme = true
r.setup({
    R_args = { "--quiet", "--no-restore", "--no-save" },
    external_term = false, -- this can be changed to open using tmux, among other choices
    rconsole_width = 15, -- making this small enough to force the console to open in a vertical split
    pipe_keymap = "<M-m>", -- probably won't use this, remapping b/c insert mode mappings are bothersome when localleader is <Space>
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
