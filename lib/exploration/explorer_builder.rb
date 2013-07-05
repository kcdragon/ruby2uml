require_relative 'block_entity'
require_relative 'class_entity'
require_relative 'method_entity'
require_relative 'module_entity'
require_relative 'root_entity'
require_relative 'aggregation_relation'
require_relative 'dependency_relation'
require_relative 'implements_relation'
require_relative 'generalization_relation'

# All build methods must return an object that implements Explorable.
class ExplorerBuilder
  
  # Builds Explorer for Ruby programs. This explorer picks up:
  #
  # * Classes
  #   * Generalization relationships
  #   * Aggregation relationships
  #   * Dependency relationships
  #   * Implementation relationships
  # * Modules
  #   * Dependency relationships
  #   * Implementation relationships
  def build_ruby_explorer
    agg = AggregationRelation.new
    dep = DependencyRelation.new
    par = GeneralizationRelation.new
    imp = ImplementsRelation.new

    class_method_entity = MethodEntity.new
    class_method_entity.add_explorer agg
    class_method_entity.add_explorer dep

    module_method_entity = MethodEntity.new
    module_method_entity.add_explorer dep

    class_entity = ClassEntity.new
    class_entity.add_explorer class_method_entity
    class_entity.add_explorer par
    class_entity.add_explorer imp
    module_entity = ModuleEntity.new
    module_entity.add_explorer module_entity
    module_entity.add_explorer class_entity
    module_entity.add_explorer module_method_entity
    module_entity.add_explorer imp

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
