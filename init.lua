local Plug = vim.fn["plug#"]
vim.call("plug#begin")
-- syntax highlighting, goto definitions, and friends
Plug("nvim-treesitter/nvim-treesitter")

-- lsp helpers
Plug("neovim/nvim-lspconfig")
Plug("hrsh7th/nvim-cmp")
Plug("hrsh7th/cmp-nvim-lsp")
Plug("hrsh7th/cmp-buffer")
Plug("hrsh7th/cmp-path")
Plug("hrsh7th/cmp-cmdline")
Plug("saadparwaiz1/cmp_luasnip")
Plug("L3MON4D3/LuaSnip")

Plug("R-nvim/R.nvim")
Plug("R-nvim/cmp-r")

-- common lisp
Plug("monkoose/parsley") -- nvlime dependency
Plug("monkoose/nvlime")

-- slime-like utility for vim
Plug("jpalardy/vim-slime")

-- nice and simple utility for closing buffers
Plug("Asheq/close-buffers.vim")

-- sophisitcated undo tree
Plug("mbbill/undotree")

-- (colorschemes)
-- zenbones.nvim has lush.nvim dependencies
Plug("rktjmp/lush.nvim")
Plug("mcchrish/zenbones.nvim")

-- fuzzy finder
-- Use the find command instead. nvim-telescope/telescope.nvim is good,
-- should I ever have a change of heart.

vim.call("plug#end")


vim.o.mouse = ""
vim.g.maplocalleader = " "
vim.g.mapleader = "\\"

vim.cmd("runtime ftplugin/man.vim")
vim.o.termguicolors = true
vim.cmd("colorscheme zenburned")
-- set the color for matching parentheses, braces, etc.
vim.api.nvim_set_hl(0,
                    "MatchParen",
                    {
                        bg = "NONE",
                        fg = "Yellow",
                        bold = true,
                        underline = true,
                        force = true,
                    })
vim.o.splitright = true
vim.o.syntax = "enable"
vim.o.showmode = true
vim.o.showcmd = true
vim.o.wildmenu = true
vim.o.ruler = true
vim.o.wrap = false
vim.o.hlsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.list = true -- show spaces and tabs with hyphens
-- after the 'expandtab' option is set, any new tab characters
-- entered will be converted to spaces
-- (use Crtl+v+<Tab> to insert an actual tab character)
vim.o.expandtab = true
vim.o.tabstop = 4 -- set the number of spaces to insert when pressing the tab key
vim.o.softtabstop = 4 -- set the number of columns the cursor moves when pressing the tab or backspace <BS> key
vim.o.shiftwidth = 4 -- set the number of spaces inserted for indentation (< and > in visual mode)


vim.api.nvim_set_keymap("n", "+", ":vertical resize +10<CR>",
                        {
                            noremap = true,
                            desc = "Increase the size of a vertical pane by 10 columns."
                        })
vim.api.nvim_set_keymap("n", "_", ":vertical resize -10<CR>",
                        {
                            noremap = true,
                            desc = "Decrease the size of a vertical pane by 10 columns."
                        })
vim.api.nvim_set_keymap("t", "<Esc>", "<C-\\><C-n>",
                        {
                            noremap = true,
                            desc = "Use Esc to exit terminal mode."
                        })
vim.api.nvim_set_keymap("n", "<C-j>", "<C-w>j",
                        {
                            noremap = true,
                            desc = "Move cursor down one window."
                        })
vim.api.nvim_set_keymap("n", "<C-k>", "<C-w>k",
                        {
                            noremap = true,
                            desc = "Move cursor up one window."
                        })
vim.api.nvim_set_keymap("n", "<C-h>", "<C-w>h",
                        {
                            noremap = true,
                            desc = "Move cursor left one window."
                        })
vim.api.nvim_set_keymap("n", "<C-l>", "<C-w>l",
                        {
                            noremap = true,
                            desc = "Move cursor right one window."
                        })
vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)


-- diagnostics settings
vim.diagnostic.config({
virtual_text = false,
    underline = false,
})
vim.o.updatetime = 200
vim.api.nvim_create_autocmd({ "CursorHold" }, {
  group = vim.api.nvim_create_augroup("float_diagnostic_cursor", { clear = true }),
  callback = function ()
    vim.diagnostic.open_float(nil, {
        focus = false,
        severity = { min = vim.diagnostic.severity.ERROR },
    })
  end
})
