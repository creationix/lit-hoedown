local ffi = require('ffi')
local fs = require('fs')
local bundle = require('luvi').bundle

local pathJoin = require('luvi').path.join

-- Get path
local base = module.dir
local isBundle = false
if base:match("^bundle:") then
  base = base:gsub("^bundle:", "")
  isBundle = true
end
local dir = pathJoin(base, ffi.os .. "-" .. ffi.arch)
local entries
if isBundle then
  entries = bundle.readdir(dir)
else
  entries = fs.readdirSync(dir)
end
assert(entries and entries[1], "Missing shared library in : " .. dir)

local header
local headerPath = pathJoin(base, "hoedown.h")
if isBundle then
  header = bundle.readfile(headerPath)
else
  header = fs.readFileSync(headerPath)
end

ffi.cdef(header)
return bundle.action(pathJoin(dir, entries[1]), function (path)
  -- Load module
  return ffi.load(path)
end)
