require_relative '../../lib/graph/vertex'
require_relative '../../lib/uml/dot_builder'

describe DotBuilder do

  it { respond_to? :build_entity }
  it { respond_to? :build_relation }

  describe ".build_entity" do
    
    def get_module_as_dot id, name, namespace=''
      get_entity_as_dot id, name, namespace, '...'
    end

    def get_class_as_dot id, name, namespace=''
      get_entity_as_dot id, name, namespace, '...|...'
    end

    def get_entity_as_dot id, name, namespace, content
      "#{id}[label = \"{#{namespace + name}|"+ content + "}\"]"
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
  end
end
