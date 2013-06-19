class Sexp < Array

  # Yields each child of self to the given block. A child is any Sexp that is an immediate descendant of self.
  def each_child &block
    # REFACTOR i don't like this switch statement
    type = self.head
    if type == :class
      children = rest.rest.rest
    elsif type == :module
      children = rest.rest
    else
      raise "Unsupported type for each_child method: #{type}"
    end

    child = children.first
    while child != nil
      block.call child
      children = children.rest
      child = children.first
    end
  end
end
