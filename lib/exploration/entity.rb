require_relative 'explorer'

class Entity < Explorer
  
  def initialize
    @explorers = Array.new
  end
  
  # exp is an Explorer object
  def add_explorer exp
    @explorers << exp
  end

  protected

  # REFACTOR context should be its own class instead of a hash

  # Explore each Sexp with type +type+ (ex. :class, :module).
  def each_type sexp, type, context=nil, &block
    # if nothing has been explored (i.e. no context) and the top element does not match what we are exploring, skip exploring this sexp
    return if context.nil? && sexp.sexp_type != type

    # if there is no context and top-level sexp matches type, then just explore that
    if context == nil && sexp.first == type
      yield_entity sexp, context, type, &block

      # otherwise, explore the siblings of the sexp
    else
      sexp.each_sexp do |sub_sexp|
        yield_entity sub_sexp, context, type, &block if sub_sexp.sexp_type == type
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
    explore sexp, new_context, &block
  end

  def explore sexp, context, &block
    @explorers.each do |exp|
      exp.each sexp, context, &block
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
