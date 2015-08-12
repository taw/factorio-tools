require "ruby-lua"
require "pathname"

# This is dumb...
def lua_trampoline(*args)
  $__lua_env__.send(*args)
end

# Perl style local vars, oh yeah!
def with_lua_trampoline(obj)
  prev = $__lua_env__
  $__lua_env__ = obj
  yield
ensure
  $__lua_env__ = prev
end

class FactorioData
  def initialize(path)
    @path = Pathname(path)
    @data = []
    setup_lua!
  end

  def load!
    @lua.eval("require 'data'")
  end

  def load_lua!(path)
    with_lua_trampoline(self) do
      @lua.eval(path.read)
    end
  end

  def data
    @lua.var("data")["raw"]
  end

  private

  def lua_path
    [
      "?",
      "?.lua",
      "#{@path.readlink + 'data/base/?' }",
      "#{@path.readlink + 'data/base/?.lua' }",
      "#{@path.readlink + 'data/core/lualib/?' }",
      "#{@path.readlink + 'data/core/lualib/?.lua' }",
    ].join(";")
  end

  def setup_lua!
    @lua = Language::Lua.new()
    @lua.eval("package.path = package.path .. '%s'" % lua_path)
    @lua.eval("require 'dataloader'")
  end
end
