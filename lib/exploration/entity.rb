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

  private

    # Explore each Sexp with type +type+ (ex. :class, :module).
    def each_type sexp, type, context=nil, &block
      namespace = (context != nil && context[:name]) || ''
      if sexp.first == type # if top-level sexp matches type, then just explore that
        yield_entity sexp, namespace, type, &block
      else
        sexp.each_sexp do |sub_sexp|
          if sub_sexp.head == type
            entity_node = sub_sexp
            yield_entity entity_node, namespace, type, &block
          end
        end
      end
    end

    # Yields an individual Sexp and all of its Relations.
    def yield_entity sexp, namespace, type, &block
      name = ''
      name = namespace + '::' if namespace.length > 0
      name += get_entity_name(sexp)
      type = :class
      context = { name: name, type: type }
      block.call name, type
      @explorers.each do |rel|
        rel.each sexp, context, &block
      end
    end

    def get_entity_name sexp
      sexp.rest.head.to_s
    end
  end
end
