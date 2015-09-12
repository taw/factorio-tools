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
  # Not really best idea to run this, but then what are we going to do?
  attr_reader :lua

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
    cleanup_data(@lua.var("data")["raw"])
  end

  def cleanup_data(arg)
    return arg unless arg.is_a?(Hash)
    expected_keys = (1..arg.keys.size).map{|i| i*1.0}
    if arg.keys === expected_keys
      expected_keys.map{|k| cleanup_data(arg[k])}
    else
      Hash[arg.keys.map{|k| [k, cleanup_data(arg[k])] }]
    end
  end

  private

  def lua_path
    [
      "?",
      "?.lua",
      "#{@path.realpath + 'data/base/?' }",
      "#{@path.realpath + 'data/base/?.lua' }",
      "#{@path.realpath + 'data/core/lualib/?' }",
      "#{@path.realpath + 'data/core/lualib/?.lua' }",
    ].join(";")
  end

  def setup_lua!
    @lua = Language::Lua.new()
    @lua.eval("package.path = package.path .. '%s'" % lua_path)
    @lua.eval("require 'dataloader'")
  end
end
