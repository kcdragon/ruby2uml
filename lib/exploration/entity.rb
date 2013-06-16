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

    # Explore each Sexp with type +type+ (ex. :class, :module).
    def each_type sexp, type, context=nil, &block
      if context != nil
        sexp.each_child do |sub_sexp|
          if sub_sexp.head == type
            entity_node = sub_sexp
            yield_entity entity_node, context, type, &block
          end
        end
      end
      if context == nil
        if sexp.first == type # if top-level sexp matches type, then just explore that
          yield_entity sexp, context, type, &block
        else
          sexp.each_child do |sub_sexp|
            if sub_sexp.head == type
              entity_node = sub_sexp
              yield_entity entity_node, context, type, &block
            end
          end
        end
      end
    end

  private

    # Yields an individual Sexp and all of its Relations.
    def yield_entity sexp, context, type, &block
      name = get_entity_name(sexp)
      namespace = Array.new

      # TODO change this awkward logic
      if context != nil
        if context.has_key? :namespace
          namespace = context[:namespace].dup
          namespace << context[:name] if context.has_key? :name
        else
          namespace << context[:name] if context.has_key? :name
        end
      end
      new_context = { name: name, namespace: namespace, type: type }
      block.call new_context
      @explorers.each do |rel|
        rel.each sexp, new_context, &block
      end
    end

    def get_entity_name sexp
      sexp.rest.head.to_s
    end
  end
end
