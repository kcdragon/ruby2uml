# Contract:
# Classes that include UmlBuilder must implement the following methods:
# * build_entity(vertex)
# * build_relation(vertex, edge, vertex)
module UmlBuilder

  def build_uml graph
    content = ''
    content = build_header if self.respond_to? :build_header
    graph.each do |vertex|
      content << build_entity(vertex)
    end

    graph.each do |vertex|
      vertex.each do |edge, set|
        set.each do |o_vertex|
          content << build_relation(vertex, edge.type, o_vertex)
        end
      end
    end
    content = build_footer if self.respond_to? :build_footer
    content
  end
end
