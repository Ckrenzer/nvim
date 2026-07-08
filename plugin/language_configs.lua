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
-- many of the configs were taken from nvim-lspconfig's settings:
-- https://github.com/neovim/nvim-lspconfig/tree/master/lsp

-- AWK
vim.lsp.config("awk_ls", {
    cmd = { "awk-language-server" },
    filetypes = { "awk" },
})

-- BASH
vim.lsp.config("bashls", {
    cmd = { 'bash-language-server', 'start' },
    ---@type lspconfig.settings.bashls
    settings = {
        bashIde = {
            -- Glob pattern for finding and parsing shell script files in the workspace.
            -- Used by the background analysis features across files.
            --
            -- Prevent recursive scanning which will cause issues when opening a file
            -- directly in the home directory (e.g. ~/foo.sh).
            --
            -- Default upstream pattern is "**/*@(.sh|.inc|.bash|.command)".
            globPattern = vim.env.GLOB_PATTERN or '*@(.sh|.inc|.bash|.command)',
        },
    },
    filetypes = { 'bash', 'sh' },
    root_markers = { '.git' },
})

-- LISP
-- lisp doesn't use an LSP, but this is a natural fit for the nvlime setup.
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

-- Python
vim.lsp.config("basedpyright", {
    cmd = { 'basedpyright-langserver', '--stdio' },
    filetypes = { 'python' },
    root_markers = {
        'pyrightconfig.json',
        'pyproject.toml',
        'setup.py',
        'setup.cfg',
        'requirements.txt',
        'Pipfile',
        '.git',
    },
    ---@type lspconfig.settings.basedpyright
    settings = {
        basedpyright = {
            analysis = {
                autoSearchPaths = true,
                diagnosticMode = 'openFilesOnly',
                -- https://docs.basedpyright.com/latest/configuration/language-server-settings/
                -- Explicitly setting `basedpyright.analysis.useLibraryCodeForTypes` is **discouraged** by the official docs.
                -- Because it will override per-project configurations like `pyproject.toml`.
                -- If left unset, its default value is `true`, and it can be correctly overridden by project config files.
            },
        },
    },
    on_attach = function(client, bufnr)
        vim.api.nvim_buf_create_user_command(bufnr,
                                             'LspPyrightOrganizeImports',
                                             function()
                                                 local params = {
                                                     command = 'basedpyright.organizeimports',
                                                     arguments = { vim.uri_from_bufnr(bufnr) },
                                                 }
                                                 -- Using client.request() directly because "basedpyright.organizeimports" is private
                                                 -- (not advertised via capabilities), which client:exec_cmd() refuses to call.
                                                 -- https://github.com/neovim/neovim/blob/c333d64663d3b6e0dd9aa440e433d346af4a3d81/runtime/lua/vim/lsp/client.lua#L1024-L1030
                                                 ---@diagnostic disable-next-line: param-type-mismatch
                                                 client.request('workspace/executeCommand', params, nil, bufnr)
                                             end,
                                             {
                                                 desc = 'Organize Imports',
                                             })
        vim.api.nvim_buf_create_user_command(bufnr,
                                             'LspPyrightSetPythonPath',
                                             -- the 'set_python_path' function
                                              function(command)
                                                  local path = command.args
                                                  local clients = vim.lsp.get_clients {
                                                      bufnr = vim.api.nvim_get_current_buf(),
                                                      name = 'basedpyright',
                                                  }
                                                  for _, client in ipairs(clients) do
                                                      if client.settings then
                                                          ---@diagnostic disable-next-line: param-type-mismatch
                                                          client.settings.python = vim.tbl_deep_extend('force', client.settings.python or {}, { pythonPath = path })
                                                      else
                                                          client.config.settings = vim.tbl_deep_extend('force', client.config.settings, { python = { pythonPath = path } })
                                                      end
                                                      client:notify('workspace/didChangeConfiguration', { settings = nil })
                                                  end
                                              end,
                                             {
                                                 desc = 'Reconfigure basedpyright with the provided python path',
                                                 nargs = 1,
                                                 complete = 'file',
                                             })
    end,
})

-- R
-- R-nvim plugins handle R's LSP already, so it does not go use the same
-- configuration as LSPs of other languages.
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

-- SQL
vim.lsp.config("sqls", {
    cmd = { 'sqls' },
    filetypes = { 'sql', 'mysql' },
    root_markers = { 'config.yml' },
    settings = {},
})

-- VimScript
vim.lsp.config("vimls", {
  cmd = { 'vim-language-server', '--stdio' },
  filetypes = { 'vim' },
  root_markers = { '.git' },
  init_options = {
    isNeovim = true,
    iskeyword = '@,48-57,_,192-255,-#',
    vimruntime = '',
    runtimepath = '',
    diagnostic = { enable = true },
    indexes = {
      runtimepath = true,
      gap = 100,
      count = 3,
      projectRootPatterns = { 'runtime', 'nvim', '.git', 'autoload', 'plugin' },
    },
    suggest = { fromVimruntime = true, fromRuntimepath = true },
  },
})

-- enable the LSPs
vim.lsp.enable("awk_ls")
vim.lsp.enable("bashls")
vim.lsp.enable("lua_ls")
vim.lsp.enable("basedpyright")
vim.lsp.enable("sqls")
vim.lsp.enable("vimls")
