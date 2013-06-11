require_relative 'entity'
require_relative 'explorable'

module Exploration
  class ClassEntity < Entity
    def each sexp, context=nil, &block
      module_name = ''
      if sexp.first == :class
        yield_class sexp, module_name, &block
      else
        sexp.find_nodes(:class).each do |class_node|
          yield_class class_node, module_name, &block
        end
      end
    end

    def yield_class sexp, module_name, &block
      name = module_name + get_class_name(sexp)
      type = :class
      context = { name: name, type: :class }
      block.call name, type
      @explorers.each do |rel|
        rel.each sexp, context, &block
      end
    end

    def get_class_name sexp
      sexp.rest.head.to_s
    end
  end
end
