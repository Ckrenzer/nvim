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

-- pass the terminal info in as the argument.
repl.view_bottom_of_repl = function(opts)
    -- this function exits silently if no/invalid arguments
    -- were passed. this facilitates its usage in contexts outside
    -- of this module (i.e., if you were to use vim-slime to send
    -- text to a terminal opened by R.nvim, this function could
    -- fail if vim-slime does not pass in the terminal info,
    -- which you currently have not done).
    pcall(function(options)
        -- hard coding to only support a the single repl in this module for now !!!!!!!!!!!!!
        -- <<in other words, the arguments are currently ignored>>
        terminal_info = repl.repl_info[1]
        last_line = vim.api.nvim_buf_line_count(terminal_info.buffer)
        vim.api.nvim_win_set_cursor(terminal_info.window, {last_line, 0})
    end,
    opts)
end

-- Send text to an open REPL
repl.send_keys = function(opts, wait_ms)
    -- hard coding to only support a single repl for now !!!!!!!!!!!!!
    terminal_info = repl.repl_info[1]
    text = opts.args .. "\n"
    vim.api.nvim_chan_send(terminal_info.channel_id, text)
    -- pause for a set amount of time.
    -- useful for handling with side effects produced by REPL
    -- (Ex. call this function in a plugin, have a REPL produce
    -- output, and then read the results into a split window).
    vim.wait(wait_ms or 0)
    -- move the cursor to the bottom
    repl.view_bottom_of_repl(terminal_info)
end


return repl
