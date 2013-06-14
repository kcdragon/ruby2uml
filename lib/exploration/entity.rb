require_relative 'explorable'

module Exploration
  class Entity < Explorable
    
    def initialize
      @explorers = Array.new
    end
    
    def add_explorer exp
      @explorers << exp
    end
  end
end
