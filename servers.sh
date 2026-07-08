# you'll have to ensure that the language servers
# are installed for the LSPs to work.
#
# see `:help lspconfig-all` for the full supported list

# AWK
sudo npm install -g awk-language-server

# BASH
sudo npm install -g bashls

# Lua
sudo pacman -S lua-language-server

# Python
pipx install basedpyright

# R
R -e 'install.packages("languageserver")'

# SQL
yay -S sqls

# Vimscript
sudo npm install -g vim-language-server

# YAML
sudo pacman -S yaml-language-server
