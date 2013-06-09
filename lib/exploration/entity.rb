require_relative 'explorable'

module Exploration
  class Entity
    include Explorable
    
    def initialize
      super
      # REFACTOR change variable name to explorables
      @rels = Array.new
    end
    
    # REFACTOR change method name to add_explorable
    def register_relationship rel
      @rels << rel
    end
  end
end
