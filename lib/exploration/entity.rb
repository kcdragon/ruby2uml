require_relative '../sexp_ext'
require_relative 'explorable'

module Exploration
  class Entity < Explorable
    
    def initialize
      @explorers = Array.new
    end
    
    # exp is Explorable
    def add_explorer exp
      @explorers << exp
    end

  protected

    # REFACTOR context should be its own class instead of a hash

    # Explore each Sexp with type +type+ (ex. :class, :module).
    def each_type sexp, type, context=nil, &block
      # a nil context implies that nothing has been explored yet

      # if nothing has been explored and the top element does not match what we are exploring, skip exploring this sexp
      return if context.nil? && sexp.first != type
      
      # if there is no context and top-level sexp matches type, then just explore that
      if context == nil && sexp.first == type
        yield_entity sexp, context, type, &block

      # otherwise, explore the children of the sexp
      else
        sexp.each_child do |sub_sexp|
          if sub_sexp.head == type
            entity_node = sub_sexp
            yield_entity entity_node, context, type, &block
          end
        end
      end
    end

  private

    # Yields an individual Sexp and all of its Relations.
    def yield_entity sexp, context, type, &block
      name = get_entity_name sexp
      namespace = get_namespace context
      new_context = { name: name, namespace: namespace, type: type }
      block.call new_context
      @explorers.each do |rel|
        rel.each sexp, new_context, &block
      end
    end

    def get_entity_name sexp
      sexp.rest.head.to_s
    end

    def get_namespace context
      namespace = Array.new
      if context != nil
        namespace = context[:namespace].dup if context.has_key? :namespace
        namespace.push context[:name] if context.has_key? :name
      end
      namespace
    end
  end
end
