# NOTE: "head" and "rest" (aliased from "sexp_type" and "sexp_body") method calls on Sexp objects are simliar to Lisp's functions "car" and "cdr"

class GraphGenerator
  attr_reader :graph

  def initialize graph
    
  end

  def analyze_sexp sexp
    sexp.find_nodes(:class).each do |class_node|
      class_name = get_class_name class_node
      parent_name = get_parent_name class_node
      depends_on = Array.new
      class_node.each_of_type(:call) do |call_node|
        call_node.sexp_body.each_of_type(:const) do |dependency_node|
          dependency_name = dependency_node.rest.head.to_s
          depends_on << dependency_name
        end
      end
      puts "Class: #{class_name}"
      puts "\tGeneralizes: #{parent_name}"
      puts "\tDepends On: #{depends_on.to_s}"
      puts
    end
  end

private

  # precondition: node's type is :class
  def get_class_name node
    node.rest.head.to_s
  end

  # precondition: node's type is :class
  def get_parent_name node
    parent = nil
    parent_node = node.rest.rest.head
    if parent_node != nil # class has a parent
      parent = parent_node.rest.head.to_s
    end
    parent
  end
end
