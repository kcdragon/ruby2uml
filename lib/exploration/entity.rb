require_relative 'explorable'

module Exploration
  class Entity
    include Explorable
    
    def initialize
      super
      @explorers = Array.new
    end
    
    def add_explorer exp
      @explorers << exp
    end
  end
end
