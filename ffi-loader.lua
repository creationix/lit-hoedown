local pathJoin = require('luvi').path.join
local bundle = require('luvi').bundle
local uv = require('uv')
local ffi = require('ffi')

return function (base, headerName)
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
    entries = {}
    local req = uv.fs_scandir(dir)
    while req do
      local entry = uv.fs_scandir_next(req)
      if not entry then break end
      entries[#entries + 1] = entry.name
    end
  end

  assert(entries and entries[1], "Missing shared library in : " .. dir)

  local headerPath = pathJoin(base, headerName)
  local libPath = pathJoin(dir, entries[1])
  if isBundle then
    ffi.cdef(bundle.readfile(headerPath))
    return bundle.action(libPath, function (path)
      -- Load module
      return ffi.load(path)
    end)
  end
  local fd = assert(uv.fs_open(headerPath, "r", 420))
  local stat, data, err
  stat, err = uv.fs_fstat(fd)
  if stat then
    data, err = uv.fs_read(fd, stat.size, 0)
  end
  uv.fs_close(fd)
  assert(data, err)
  ffi.cdef(data)
  return ffi.load(libPath)
end
