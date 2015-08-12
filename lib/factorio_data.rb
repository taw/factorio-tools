require "ruby-lua"
require "pathname"

class FactorioData
  def initialize(path)
    @lua = Language::Lua.new()
    @path = Pathname(path)
  end

end
