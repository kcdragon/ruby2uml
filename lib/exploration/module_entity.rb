require_relative 'entity'
require_relative 'explorable'

module Exploration
  class ModuleEntity < Entity
    def each sexp, context=nil, &block
      parent_module = (context != nil && context[:name]) || ''
      if sexp.first == :module
        yield_module sexp, parent_module, &block
      else
        sexp.find_nodes(:module).each do |module_node|
          yield_module module_node, parent_module, &block
        end
      end
    end

    def yield_module sexp, parent_module, &block
      name = ''
      name = parent_module + '::' if parent_module.length > 0
      name += get_module_name(sexp)
      type = :module
      context = { name: name, type: :module }
      block.call name, type
      @explorers.each do |rel|
        rel.each sexp, context, &block
      end
    end

    def get_module_name sexp
      sexp.rest.head.to_s
    end
  end
end
