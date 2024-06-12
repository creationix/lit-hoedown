local names = {
  ["Linux-arm"] = "libhoedown.so",
  ["Linux-x64"] = "libhoedown.so",
  ["OSX-x64"] = "libhoedown.dylib",
  ["OSX-arm64"] = "libhoedown.dylib",
  ["Windows-x64"] = "hoedown.dll",
}

local ffi = require('ffi')
ffi.cdef(module:load("hoedown.h"))

local arch = ffi.os .. "-" .. ffi.arch
return module:action(arch .. "/" .. assert(names[arch], "Unsupported architecture"), function(path)
  return ffi.load(path)
end)
