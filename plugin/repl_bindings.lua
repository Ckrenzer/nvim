-- keybindings for the repl module
local repl = require("repl.repl")

vim.api.nvim_create_user_command("REPLOpen",
repl.open,
{
    nargs = "*",
    desc = "Open a REPL in a new terminal window.",
})
vim.api.nvim_create_user_command("REPLViewBottom",
repl.view_bottom_of_repl,
{
    desc = [[
    Move cursor in the terminal window
    to the bottom so that it tracks new output.
    ]]
})
vim.api.nvim_create_user_command("REPLSendKeys",
repl.send_keys,
{
    nargs = "*",
    desc = "Send text to an open REPL."
})


-- set key bindings around commands
vim.api.nvim_set_keymap("n", "<LocalLeader>jf", ":REPLOpen ", { noremap = true })
vim.api.nvim_set_keymap("n", "<LocalLeader>d", ":REPLViewBottom<Cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<LocalLeader>:", ":REPLSendKeys ", { noremap = true })
