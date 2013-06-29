# Contract:
# Classes that include UmlBuilder must implement the following methods:
# * build_entity(vertex)
# * build_relation(vertex, edge, vertex)
module UmlBuilder

  def initialize config={}
    @config = config
    @exclude = config['exclude'] || []
  end

  def build_uml graph
    content = ''
    content << build_header if self.respond_to? :build_header
    graph.each do |vertex|
      content << build_entity(vertex) unless @exclude.include? vertex.name
    end

    graph.each do |vertex|
      vertex.each do |edge, set|
        unless @exclude.include? vertex.name
          set.each do |o_vertex|
            content << build_relation(vertex, edge.type, o_vertex) unless @exclude.include? o_vertex.name
          end
        end
      end
    end
    content << build_footer if self.respond_to? :build_footer
    content
  end
end
