-- Depending on the day, you may want this to say "neovim" or "tmux".
-- It decides where to send selected text using the vim-slime plugin.
vim.g.slime_target = "neovim"
-- Moving the cursor back to where you started is pretty tedious
vim.g.slime_preserve_cursorpos = 0
vim.api.nvim_set_keymap("n",
                        "<C-\\>",
                        "<Plug>SlimeLineSend",
                        {
                            noremap = false,
                            desc = "Keep cursor where it was at time of sending."
                        })
