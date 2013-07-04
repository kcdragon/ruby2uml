require_relative '../../lib/graph/edge'
require_relative '../../lib/graph/vertex'
require_relative '../../lib/uml/dot_builder'

describe DotBuilder do

  it { respond_to? :build_entity }
  it { respond_to? :build_relation }
  it { respond_to? :build_header }
  it { respond_to? :build_footer }

  subject(:dot_builder) do
    config = { 'delimiter' => '::' }
    dot_config = {
      "size" => "\"5,5\"",
      "node" => {
        "shape" => "record",
        "style" => "filled",
        "fillcolor" => "gray95"
      }
    }
    DotBuilder.new(config, dot_config)
  end

  describe ".build_entity" do
    
    def get_module_as_dot id, name, namespace='', *methods
      content = methods.empty? ? '...' : methods.join('\n').chomp('\n')
      get_entity_as_dot id, name, namespace, content
    end

    def get_class_as_dot id, name, namespace='', *methods
      content = methods.empty? ? '...' : methods.join('\n').chomp('\n')
      get_entity_as_dot id, name, namespace, '...|' + content
    end

    def get_entity_as_dot id, name, namespace, content
      "#{id}[label = \"{#{namespace + name}|"+ content + "}\"]\n"
    end

    let(:module_node) { Vertex.new 'ModuleNode', :module }
    let(:class_node) { Vertex.new 'ClassNode', :class }

    it "builds module entity" do
      expect(subject.build_entity(module_node)).to eq get_module_as_dot(1, module_node.name)
    end

    it "builds class entity" do
      expect(subject.build_entity(class_node)).to eq get_class_as_dot(1, class_node.name)
    end

    it "builds multiples entities" do
      expect(subject.build_entity(module_node)).to eq get_module_as_dot(1, module_node.name)
      expect(subject.build_entity(class_node)).to eq get_class_as_dot(2, class_node.name)
    end

    it "builds module with namespace" do
      namespace = 'Ns'
      module_node.namespace = Namespace.new [namespace]
      expect(subject.build_entity(module_node)).to eq get_module_as_dot(1, module_node.name, namespace + '::')
    end

    it "builds class with namespace" do
      namespace = 'Ns'
      class_node.namespace = Namespace.new [namespace]
      expect(subject.build_entity(class_node)).to eq get_class_as_dot(1, class_node.name, namespace + '::')
    end

    it "builds module with one method" do
      module_node.add_edge Edge.new(:defines), Vertex.new('get_foo', :method)
      expect(subject.build_entity(module_node)).to eq get_module_as_dot(1, module_node.name, '', 'get_foo')
    end

    it "builds module with multiple methods" do
      module_node.add_edge Edge.new(:defines), Vertex.new('get_foo', :method)
      module_node.add_edge Edge.new(:defines), Vertex.new('get_baz', :method)
      expect(subject.build_entity(module_node)).to eq get_module_as_dot(1, module_node.name, '', 'get_foo', 'get_baz')
    end

    it "builds class with one method" do
      class_node.add_edge Edge.new(:defines), Vertex.new('get_foo', :method)
      expect(subject.build_entity(class_node)).to eq get_class_as_dot(1, class_node.name, '', 'get_foo')
    end

    it "builds class with mutliple methods" do
      class_node.add_edge Edge.new(:defines), Vertex.new('get_foo', :method)
      class_node.add_edge Edge.new(:defines), Vertex.new('get_baz', :method)
      expect(subject.build_entity(class_node)).to eq get_class_as_dot(1, class_node.name, '', 'get_foo', 'get_baz')
    end
  end

  describe ".build_relation" do
    def get_relation_as_dot one, two, options
      "#{one}->#{two}[" + options + "]\n"
    end

    def get_generalization_as_dot child, parent
      get_relation_as_dot(parent, child, "arrowtail=empty, dir=back")
    end
    
    def get_implements_as_dot impl, type
      get_relation_as_dot(type, impl, "arrowtail=empty, dir=back, style=dashed")
    end

    def get_aggregation_as_dot aggregator, aggregate
      get_relation_as_dot(aggregator, aggregate, "arrowtail=odiamond, constraint=false, dir=back")
    end

    def get_dependency_as_dot vertex, depends_on
      get_relation_as_dot(vertex, depends_on, "dir=forward, style=dashed")
    end

    let(:foo) { foo = Vertex.new 'Foo', :class }
    let(:bar) { foo = Vertex.new 'Bar', :class }

    def build_entities
      subject.build_entity foo
      subject.build_entity bar
    end

    it "builds relationship for generalization between classes" do
      build_entities
      expect(subject.build_relation(foo, :generalization, bar)).to eq get_generalization_as_dot(1, 2)
    end

    it "builds relationship for implementation between class and module" do
      foo.type = :module
      build_entities
      expect(subject.build_relation(foo, :implements, bar)).to eq get_implements_as_dot(1, 2)
    end

    it "builds relationship for aggregation between classes" do
      build_entities
      expect(subject.build_relation(foo, :aggregation, bar)).to eq get_aggregation_as_dot(1, 2)
    end

    it "builds relationship for dependency between classes" do
      build_entities
      expect(subject.build_relation(foo, :dependency, bar)).to eq get_dependency_as_dot(1, 2)
    end

    it "builds relationship for dependency between a class and a module" do
      bar.type = :module
      build_entities
      expect(subject.build_relation(foo, :dependency, bar)).to eq get_dependency_as_dot(1, 2)
    end

    it "builds relationship for dependency between modules" do
      foo.type = :module
      bar.type = :module
      build_entities
      expect(subject.build_relation(foo, :dependency, bar)).to eq get_dependency_as_dot(1, 2)
    end
  end

  describe ".build_header" do
    it "builds header for dot" do
      expect(dot_builder.build_header).to eq("digraph hierarchy {\n" +
                                             "size=\"5,5\"\n" +
                                             "node[shape=record, style=filled, fillcolor=gray95]\n")
    end
  end

  describe ".build_footer" do
    it "builds footer for dot" do
      expect(subject.build_footer).to eq "}"
    end
  end
end
