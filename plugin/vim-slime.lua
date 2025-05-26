-- you may want this to say "neovim" or "tmux" depending on the day
vim.g.slime_target = "neovim"
-- moving the cursor back to where you started is pretty tedious
vim.g.slime_preserve_curpos = 1
vim.api.nvim_set_keymap("n",
                        "<localleader>l",
                        "<Plug>SlimeLineSend",
                        {
                            noremap = false,
                            desc = "Keep cursor where it was at time of sending."
                        })
vim.api.nvim_set_keymap("v",
                        "<localleader>l",
                        "<Plug>SlimeRegionSend <Esc> `>0",
                        {
                            noremap = false,
                            desc = [[
                            After sending text to the target, return cursor to
                            the beginning of the line it was on before entering
                            visual mode.
                            ]]
                        })
