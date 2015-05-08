local names = {
  ["Linux-arm"] = "libhoedown.so",
  ["Linux-x64"] = "libhoedown.so",
  ["OSX-x64"] = "libhoedown.dylib",
}

local ffi = require('ffi')
ffi.cdef(module:load("hoedown.h"))

local arch = ffi.os .. "-" .. ffi.arch
return module:action(arch .. "/" .. names[arch], function (path)
  return ffi.load(path)
end)
