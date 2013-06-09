require_relative 'class_entity'
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
      class_entity.register_relationship agg
      class_entity.register_relationship dep
      class_entity.register_relationship par

      return class_entity
    end
  end
end
