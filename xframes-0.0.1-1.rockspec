package = "xframes"
version = "0.0.1-1"
dependencies = { "dkjson" }

source = {
  url = "https://github.com/xframes-project/xframes-lua"
}

description = {
  summary = "A basic Lua program for XFrames",
  detailed = "",
  license = "MIT"
}

build = {
  type = "builtin",
  modules = {
    ["myproject"] = "src/main.lua"
  }
}
