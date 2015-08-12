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
    setup_lua!
  end

  def load!
    load_lua!(@path + "data/base/data.lua")
  end

  def load_lua!(path)
    with_lua_trampoline(self) do
      @lua.eval(path.read)
    end
  end

  def lua_require(path)
    load_lua! resolve_require_path(path)
    require 'pry'; binding.pry
  end

  def resolve_require_path(req)
    search_path = %W[factorio/data/core/lualib]
    subpath = req.split(".").join("/") + ".lua"
    search_path.each do |dir|
      candidate = Pathname(dir) + subpath
      return candidate if candidate.exist?
    end
    raise "Can't find #{req} in lua search path"
  end

  private

  def setup_lua!
    @lua = Language::Lua.new()
    @lua.eval <<-LUA
      function require(path)
        ruby("lua_trampoline", "lua_require", path)
      end
    LUA
  end
end
