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
    
    def get_module_as_dot id, name, namespace=''
      get_entity_as_dot id, name, namespace, '...'
    end

    def get_class_as_dot id, name, namespace=''
      get_entity_as_dot id, name, namespace, '...|...'
    end

    def get_entity_as_dot id, name, namespace, content
      "#{id}[label = \"{#{namespace + name}|"+ content + "}\"]\n"
    end

    it "builds module entity" do
      name = 'ModuleNode'
      v = Graph::Vertex.new 'ModuleNode', :module
      expect(subject.build_entity(v)).to eq get_module_as_dot(1, name)
    end

    it "builds class entity" do
      name = 'ClassNode'
      v = Graph::Vertex.new 'ClassNode', :class
      expect(subject.build_entity(v)).to eq get_class_as_dot(1, name)
    end

    it "builds multiples entities" do
      m_name = 'ModuleNode'
      c_name = 'ClassNode'
      m = Graph::Vertex.new m_name, :module
      c = Graph::Vertex.new c_name, :class

      expect(subject.build_entity(m)).to eq get_module_as_dot(1, m_name)
      expect(subject.build_entity(c)).to eq get_class_as_dot(2, c_name)
    end

    it "builds module with namespace" do
      name = 'ModuleNode'
      namespace = 'Ns'
      v = Graph::Vertex.new name, :module
      v.namespace = Graph::Namespace.new [namespace]
      expect(subject.build_entity(v)).to eq get_module_as_dot(1, name, namespace + '::')
    end

    it "builds class with namespace" do
      name = 'ClassNode'
      namespace = 'Ns'
      v = Graph::Vertex.new name, :class
      v.namespace = Graph::Namespace.new [namespace]
      expect(subject.build_entity(v)).to eq get_class_as_dot(1, name, namespace + '::')
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

    it "builds relationship for generalization between classes" do
      foo = Graph::Vertex.new 'Foo', :class
      bar = Graph::Vertex.new 'Bar', :class
      subject.build_entity foo
      subject.build_entity bar
      expect(subject.build_relation(foo, :generalization, bar)).to eq get_generalization_as_dot(1, 2)
    end

    it "builds relationship for implementation between class and module" do
      foo = Graph::Vertex.new 'Foo', :module
      bar = Graph::Vertex.new 'Bar', :class
      subject.build_entity bar
      subject.build_entity foo
      expect(subject.build_relation(bar, :implements, foo)).to eq get_implements_as_dot(1, 2)
    end

    it "builds relationship for aggregation between classes" do
      foo = Graph::Vertex.new 'Foo', :class
      bar = Graph::Vertex.new 'Bar', :class
      subject.build_entity foo
      subject.build_entity bar
      expect(subject.build_relation(foo, :aggregation, bar)).to eq get_aggregation_as_dot(1, 2)
    end

    it "builds relationship for dependency between classes" do
      foo = Graph::Vertex.new 'Foo', :class
      bar = Graph::Vertex.new 'Bar', :class
      subject.build_entity foo
      subject.build_entity bar
      expect(subject.build_relation(foo, :dependency, bar)).to eq get_dependency_as_dot(1, 2)
    end

    it "builds relationship for dependency between a class and a module" do
      foo = Graph::Vertex.new 'Foo', :class
      bar = Graph::Vertex.new 'Bar', :module
      subject.build_entity foo
      subject.build_entity bar
      expect(subject.build_relation(foo, :dependency, bar)).to eq get_dependency_as_dot(1, 2)
    end

    it "builds relationship for dependency between modules" do
      foo = Graph::Vertex.new 'Foo', :module
      bar = Graph::Vertex.new 'Bar', :module
      subject.build_entity foo
      subject.build_entity bar
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
