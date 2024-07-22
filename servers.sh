# you'll have to ensure that the language servers
# are installed for the LSPs to work.

sudo npm -i -g awk-language-server
sudo npm -i -g bashls
sudo npm -i -g pyright
# julia -e 'using Pkg; Pkg.add("LanguageServer"); Pkg.add("SymbolServer")'
npm i -g sql-language-server
sudo npm install -g vim-language-server

R -e "install.packages('languageserver')" # R needs this package to be installed

# need to do some manual work for lua:
# need dependency ninja
# need C++17 compiler
start="$PWD"
sudo apt install ninja-build
git clone https://github.com/LuaLS/lua-language-server "$HOME/repos/forks_and_clones/"
cd "$HOME/repos/forks_and_clones/lua-language-server"
./make.sh
cd "$start"
# you'll need to point your computer to the binary created by the above install
# (add the installation location to $PATH)
