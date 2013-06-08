class GraphGenerator
  attr_reader :graph

  def initialize graph, explorer, edge_factory
    @graph = graph
    @explorer = explorer
    @edge_factory = edge_factory
  end

  def analyze_sexp sexp
    subject_type, locator, vertex_class = @explorer.get_subject
    if sexp.first == subject_type # if sexp is a single subject, find_node will not pick it up, need to check for this
      analyze_subject sexp, locator, vertex_class
    else
      sexp.find_node(subject_type).each do |subject_node|
        analyze_subject subject_node, locator, vertex_class
      end
    end    
  end

  def analyze_subject subject_node, locator, vertex_class
    subject_name = locator.call(subject_node)
    subject = nil
    # REFACTOR extract method
    if @graph.has_vertex? subject_name
      subject = @graph.get_vertex subject_name
    else
      subject = @graph.add_vertex vertex_class.new(subject_name)
    end
    
    @explorer.each(subject_node) do |name, vertex_class, edge|
      vertex = nil
      # REFACTOR extract method
      if @graph.has_vertex? name
        vertex = @graph.get_vertex name
      else
        vertex = @graph.add_vertex vertex_class.new(name)
      end
      subject.add_edge edge, vertex
    end
  end
end
