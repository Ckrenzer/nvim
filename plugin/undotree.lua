vim.api.nvim_set_keymap("n",
                        "<Leader>u",
                        "<cmd>UndotreeToggle<cr>",
                        {
                            noremap = true,
                            desc = "open the undo tree window",
                        })
