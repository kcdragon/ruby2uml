require_relative 'entity'
require_relative 'explorable'

module Exploration
  class ClassEntity < Entity
    # REFACTOR extract to superclass
    def each sexp, context=nil, &block
      module_name = (context != nil && context[:name]) || ''
      if sexp.first == :class
        yield_class sexp, module_name, &block
      else
        sexp.each_sexp do |sub_sexp|
          if sub_sexp.head == :class
            class_node = sub_sexp
            yield_class class_node, module_name, &block
          end
        end
      end
    end

    # REFACTOR extract to superclass
    def yield_class sexp, module_name, &block
      name = ''
      name = module_name + '::' if module_name.length > 0
      name += get_class_name(sexp)
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
