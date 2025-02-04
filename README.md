# xframes-lua

`luajit src/main.lua`

## Instructions

### Install Lua

#### Windows

You may want to use [winget](https://learn.microsoft.com/en-us/windows/package-manager/winget/)

`winget install luajit`

### Set LUA_PATH

Open a PowerShell terminal then run (replace <USER> with your username):

`[System.Environment]::SetEnvironmentVariable("LUA_PATH", "C:/Users/<USER>/scoop/apps/luarocks/current/rocks/share/lua/5.4/?.lua;C:/Users/<USER>/scoop/apps/luarocks/current/rocks/share/lua/5.4/?/init.lua", [System.EnvironmentVariableTarget]::Machine)`

#### Linux

The `luajit2` and `luarocks` packages should be available on Ubuntu.

### Install dependencies

- `luarocks install dkjson`
- `luarocks install array`
- `luarocks install luv` (read below if you are on Windows)

#### Linux

You likely need to run these as `sudo`.

#### Windows

Installing `luv` requires a x64 VS 2022 developer prompt.

## Screenshots

Windows 11

![image](https://github.com/user-attachments/assets/2d91db8e-57ba-4b94-86ad-a9972b589209)

Raspberry Pi 5

![image](https://github.com/user-attachments/assets/8dfc3a12-b550-46dd-bc20-90f856cb46c8)
