local ffi = require("ffi")

-- Declare the C function
ffi.cdef[[
    void say_hello();
]]

-- Load the shared library
local hello = ffi.load("hello")

-- Call the C function
hello.say_hello()