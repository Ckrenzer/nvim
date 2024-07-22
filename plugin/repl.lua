-- Create REPLs and send text to them
--
-- Iron.nvim does a better job at this
-- than me, but I better understand the capabilities
-- of configurations when I write them myself.
-- This turned out a lot better than my 2023 attempts in pure VimScript.
--
-- @module repl
local repl = {}

-- terminal job metadata
--  repl: the name of the repl as a string
--  buffer: the repl's buffer ID as returned by vim.api.nvim_create_buf
--  window: the repl's window ID as returned by vim.api.nvim_open_win
--  channel_id: the repl's terminal channel ID as returned by vim.fn.termopen
repl.repl_info = {}


-- Open a REPL
--   create a buffer.
--   create a window to show the buffer.
--   open a repl in the buffer.
--   ???
--   profit.
repl.open = function(opts)
    terminal_buffer = vim.api.nvim_create_buf(true, false)
    current_window = vim.api.nvim_get_current_win()
    terminal_window = vim.api.nvim_open_win(terminal_buffer,
    true, -- makes this the active window
    {
        split = "right",
        win = 0,
    })
    terminal_channel_id = vim.fn.termopen(opts.args)
    -- move back to the original window
    vim.api.nvim_set_current_win(current_window)
    -- record metadata
        -- hard coding to only support a single repl for now !!!!!!!!!!!!!
        --repl.repl_info[#repl.repl_info + 1] = {
    repl.repl_info[1] = {
        repl = opts.fargs[1],
        buffer = terminal_buffer,
        window = terminal_window,
        channel_id = terminal_channel_id,
    }
    -- This does not belong here! figure out a more elegant place for this
    -- parameterization! store the data in repl_info? use an autocommand?
    -- some mix of both? we'll see. but this is simple enough while only
    -- one repl is supported at a time... !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    vim.g.slime_python_ipython = string.match(opts.fargs[1], "ipython") ~= nil
end
-- Send text to an open REPL
repl.send_keys = function(opts)
    -- hard coding to only support a single repl for now !!!!!!!!!!!!!
    terminal_info = repl.repl_info[1]
    text = opts.args .. "\n"
    vim.api.nvim_chan_send(terminal_info.channel_id, text)
    -- move the cursor to the bottom
    last_line = vim.api.nvim_buf_line_count(terminal_info.buffer)
    vim.api.nvim_win_set_cursor(terminal_info.window, {last_line, 0})
end


vim.api.nvim_create_user_command("REPLOpen",
repl.open,
{
    nargs = "*",
    desc = "Open a REPL in a new terminal window.",
})
vim.api.nvim_create_user_command("REPLSendKeys",
repl.send_keys,
{
    nargs = "*",
    desc = "Send text to an open REPL."
})


-- set key bindings around commands
vim.api.nvim_set_keymap("n", "<LocalLeader>jf", ":REPLOpen ", { noremap = true })
vim.api.nvim_set_keymap("n", "<LocalLeader>:", ":REPLSendKeys ", { noremap = true })


return repl
