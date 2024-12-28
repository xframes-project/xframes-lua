# xframes-lua

`luajit src/main.lua`

## Windows

### Install Lua

You may want to use [scoop](https://scoop.sh/):

- `scoop install lua`
- `scoop install luarocks`
- `scoop install luajit`

### Set LUA_PATH

Open a PowerShell terminal then run (replace <USER> with your username):

`[System.Environment]::SetEnvironmentVariable("LUA_PATH", "C:/Users/<USER>/scoop/apps/luarocks/current/rocks/share/lua/5.4/?.lua;C:/Users/<USER>/scoop/apps/luarocks/current/rocks/share/lua/5.4/?/init.lua", [System.EnvironmentVariableTarget]::Machine)`

## Linux

If you need help, please raise an issue on GitHub
