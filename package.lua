return {
  name = "creationix/hoedown",
  version = "1.1.1",
  homepage = "https://github.com/creationix/lit-hoedown",
  description = "FFI bindings to the hoedown markdown library",
  tags = {"ffi", "markdown", "codec"},
  author = { name = "Tim Caswell" },
  license = "MIT",
  files = {
    "*.lua",
    "*.h",
    "!hoedown",
    "!hoedown-sample",
    "$OS-$ARCH/*",
  }
}
