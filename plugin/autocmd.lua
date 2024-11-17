local new_terminal = vim.api.nvim_create_augroup("newterminal", { clear = true })
vim.api.nvim_create_autocmd({ "TermOpen" },
{
    group = new_terminal,
    callback = function()
        vim.wo.number = false
        vim.wo.relativenumber = false
    end,
    desc = "Turn off numbers and relative numbers when opening new terminals."
})

local close_terminal = vim.api.nvim_create_augroup("closeterminal", { clear = true })
vim.api.nvim_create_autocmd({ "TermClose" },
{
    group = close_terminal,
    callback = function(args)
        vim.api.nvim_buf_delete(args.buf, {})
    end,
    desc = "Delete the terminal's buffer after terminal closes."
})

local changed_mode = vim.api.nvim_create_augroup("modechange", { clear = true })
vim.api.nvim_create_autocmd({ "ModeChanged" },
{
    group = changed_mode,
    callback = function()
        -- I have not tested whether this is the case, but I think that
        -- this returns an empty string if xset is not found
        -- (in which case Caps Lock will not get turned off).
        -- This will require more work if you use a non-X11 distro.
        local handle = io.popen("xset -q | awk '/00: Caps Lock:/{print $4}'", "r")
        local caps_state = handle:read("*l")
        handle:close()
        if caps_state == "on" then
            vim.cmd("silent! execute ':!xdotool key Caps_Lock'")
        end
    end,
    desc = [[
    Turn off Caps Lock whenever the mode changes.
    I rarely use this since I've remapped my Caps Lock
    key, but it's good to keep around.
    ]]
})
