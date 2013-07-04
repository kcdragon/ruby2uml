require_relative 'uml_builder'

# DotBuilder constructs a String in .dot format from a Digraph to be used with the Graphviz Dot program.
class DotBuilder
  include UmlBuilder

  def node_beginning vertex
    id = @vertex_to_id[vertex]
    name = vertex.fully_qualified_name(@config["delimiter"]).chomp("?").chomp("!") # TODO find a better solution than removing question marks and bangs from methods
    "#{id}[label = \"{#{name}|"
  end

  def node_ending
    "}\"]\n"
  end

  def initialize config={}, dot_config={}
    super(config)
    @dot_config = dot_config

    @id_counter = 0
    @vertex_to_id = Hash.new

    def get_methods vertex
      methods = vertex.get_edge(Edge.new(:defines))
      return '...' if methods.empty?
      methods.to_a.map(&:name).join('\n').chomp('\n') # TODO need to figure out how to add new lines correctly
    end

    @vertex_mappings = Hash.new lambda { |*| '' }
    @vertex_mappings[:module] = lambda do |moduel|
      node_beginning(moduel) +
        get_methods(moduel) +
        node_ending
    end
    @vertex_mappings[:class] = lambda do |klass|
      node_beginning(klass) +
        "...|" + get_methods(klass) +
        node_ending
    end

    @edge_mappings = Hash.new lambda { |*| '' }
    @edge_mappings[:generalization] = lambda do |child, parent|
      return "#{parent}->#{child}[arrowtail=empty, dir=back]"
    end
    @edge_mappings[:implements] = lambda do |impl, type|
      return "#{type}->#{impl}[arrowtail=empty, dir=back, style=dashed]"
    end
    @edge_mappings[:aggregation] = lambda do |aggregator, aggregate|
      return "#{aggregator}->#{aggregate}[arrowtail=odiamond, constraint=false, dir=back]"
    end
    @edge_mappings[:dependency] = lambda do |vertex, depends_on|
      return "#{vertex}->#{depends_on}[dir=forward, style=dashed]"
    end
  end

  def build_header
    header = "digraph hierarchy {\n"
    header << "size=#{@dot_config["size"]}\n" if @dot_config.has_key? "size"
    if @dot_config.has_key? "node"
      header << "node["
      @dot_config["node"].each do |setting_name, setting_value|
        header << "#{setting_name}=#{setting_value}, "
      end
      header.chomp!(", ")
      header << "]\n"
    end
    header
  end

  def build_entity vertex
    @id_counter += 1
    @vertex_to_id[vertex] = @id_counter
    @vertex_mappings[vertex.type].call(vertex)
  end

  def build_relation vertex, edge, o_vertex
    @edge_mappings[edge].call(@vertex_to_id[vertex], @vertex_to_id[o_vertex]) + "\n"
  end

  def build_footer
    "}"
  end
end
