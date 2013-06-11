require_relative 'class_entity'
require_relative 'module_entity'
require_relative 'root_entity'
require_relative 'aggregation_relation'
require_relative 'dependency_relation'
#require_relative 'implements_relation'
require_relative 'parent_relation'

module Exploration
  # All build methods must return an object that implements Explorable
  class ExplorerBuilder
    def self.instance
      @@instance ||= ExplorerBuilder.new
    end
    
    # Build explorer for Ruby programs
    def build_ruby_explorer
      agg = AggregationRelation.new
      dep = DependencyRelation.new
      par = ParentRelation.new

      class_entity = ClassEntity.new
      class_entity.add_explorer agg
      class_entity.add_explorer dep
      class_entity.add_explorer par

      module_entity = ModuleEntity.new
      module_entity.add_explorer class_entity
      module_entity.add_explorer dep

      root = RootEntity.new
      root.add_explorer class_entity
      root.add_explorer module_entity

      return root
    end
  end
end
