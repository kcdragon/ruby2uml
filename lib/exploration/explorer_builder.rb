require_relative 'block_entity'
require_relative 'class_entity'
require_relative 'module_entity'
require_relative 'root_entity'
require_relative 'aggregation_relation'
require_relative 'dependency_relation'
#require_relative 'implements_relation'
require_relative 'parent_relation'

module Exploration

  # All build methods must return an object that implements Explorable.
  class ExplorerBuilder
    def self.instance
      @@instance ||= ExplorerBuilder.new
    end
    
    # Builds Explorer for Ruby programs. This explorer picks up:
    #
    # * Classes
    #   * Generalization relationships
    #   * Aggregation relationships
    #   * Dependency relationships
    # * Modules
    #   * Dependency relationships
    def build_ruby_explorer
      agg = AggregationRelation.new
      dep = DependencyRelation.new
      par = ParentRelation.new

      class_entity = ClassEntity.new
      class_entity.add_explorer agg
      class_entity.add_explorer dep
      class_entity.add_explorer par
      module_entity = ModuleEntity.new
      module_entity.add_explorer module_entity
      module_entity.add_explorer class_entity
      module_entity.add_explorer dep

      block_entity = BlockEntity.new
      block_entity.add_explorer module_entity
      block_entity.add_explorer class_entity

      root = RootEntity.new
      root.add_explorer class_entity
      root.add_explorer module_entity
      root.add_explorer block_entity

      return root
    end
  end
end
