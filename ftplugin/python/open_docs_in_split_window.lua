produce_documentation_and_open_in_split_window = function(opts)
    -- write the python documentation to a temp file
    local file_name = "/tmp/python_help_documentation_file_for_nvim_split_window.txt"
    os.remove(file_name)
    local repl = require("repl.repl")
    repl.send_keys({args = "write_help_documentation_to_file(" .. opts.args .. ")"}, 125)
    -- read in this temp file
    local lines = {}
    local file_handler = io.open(file_name, "r")
    if not file_handler then
        vim.notify("Could not open the python documentation file.", vim.log.levels.ERROR)
        return
    end
    for line in file_handler:lines() do
        table.insert(lines, line)
    end
    file_handler.close()
    -- write the file's contents to a buffer
    local buf = vim.api.nvim_create_buf(true, false)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    -- set buffer options to prevent editing or saving
    vim.bo[buf].buftype = "nofile"
    vim.bo[buf].bufhidden = "delete" -- delete the buffer when it is no longer displayed in a window
    vim.bo[buf].swapfile = false
    vim.bo[buf].modifiable = false
    vim.bo[buf].readonly = true
    -- open it in a split window
    vim.cmd("split")
    vim.api.nvim_set_current_buf(buf)
end
vim.api.nvim_create_user_command("REPLOpenDocs",
produce_documentation_and_open_in_split_window,
{
    nargs = "*",
    desc = "open the python documentation for the input object in a split window."
})
vim.api.nvim_set_keymap("n", "<LocalLeader>h", ":REPLOpenDocs ", { noremap = true })
