local ffi = require('ffi')
local bundle = require('luvi').bundle

local pathJoin = require('luvi').path.join

-- Get path
local base = module.dir:gsub("^bundle:", "")
local dir = pathJoin(base, ffi.os .. "-" .. ffi.arch)
local entries = bundle.readdir(dir)
assert(entries and entries[1], "Missing shared library in : " .. dir)
ffi.cdef(bundle.readfile(pathJoin(base, "hoedown.h")))
return bundle.action(pathJoin(dir, entries[1]), function (path)
  -- Load module
  return ffi.load(path)
end)
