require_relative '../../lib/graph/digraph'
require_relative '../../lib/graph/edge'
require_relative '../../lib/graph/namespace'
require_relative '../../lib/graph/vertex'
require_relative '../../lib/uml/uml_builder'

describe UmlBuilder do
  
  it { respond_to? :build_uml }

  describe ".build_uml" do

    let(:graph) do
      c = Vertex.new 'Class', :class, ['M']
      m = Vertex.new 'Module', :module, ['N']
      
      e = Edge.new :dependency
      m.add_edge e, c

      graph = Digraph.new
      graph.add_vertex c
      graph.add_vertex m
      graph
    end

    context "when implementation is not complete" do
      it "fails because build_entity is not implemented" do
        impl = Class.new do
          include UmlBuilder
          def initialize config={}
            super(config)
          end
          def build_relation(vertex, edge, o_vertex); ''; end
        end
        expect { impl.new.build_uml(graph) }.to raise_error
      end

      it "fails because build_relation is ont implemented" do        impl = Class.new do
          include UmlBuilder
          def initialize config={}
            super(config)
          end
          def build_entity(vertex); ''; end
        end
        expect { impl.new.build_uml(graph) }.to raise_error
      end
    end

    context "when implementation is valid" do
      it "succeeds because build_entity and build_relation are implemented" do
        impl = Class.new do
          include UmlBuilder
          def initialize config={}
            super(config)
          end
          def build_entity(vertex); ''; end
          def build_relation(vertex, edge, o_vertex); ''; end
        end
        expect { impl.new.build_uml(graph) }.to_not raise_error
      end

      it "builds all entities" do
        impl = Class.new do
          include UmlBuilder
          def initialize config={}
            super(config)
          end
          def build_entity(vertex)
            vertex.fully_qualified_name('::') + "\n"
          end
          def build_relation(vertex, edge, o_vertex); ''; end
        end

        expect(impl.new.build_uml(graph)).to eq("M::Class\nN::Module\n")
      end

      it "builds all relations" do
        impl = Class.new do
          include UmlBuilder
          def initialize config={}
            super(config)
          end
          def build_entity(vertex); ''; end
          def build_relation(vertex, edge, o_vertex)
            get_name = lambda do |v|
              v.fully_qualified_name '::'
            end
            "#{get_name.call(vertex)}->#{get_name.call(o_vertex)}"
          end
        end

        expect(impl.new.build_uml(graph)).to eq("N::Module->M::Class")
      end

      it "calls build_header when implemented" do
        impl = Class.new do
          include UmlBuilder
          def initialize config={}
            super(config)
          end
          def build_header; ''; end
          def build_entity(vertex); ''; end
          def build_relation(vertex, edge, o_vertex); ''; end
        end
        builder = impl.new
        builder.should_receive(:build_header).and_return('')
        builder.build_uml(graph)
      end

      it "calls build_footer when implemented" do
        impl = Class.new do
          include UmlBuilder
          def initialize config={}
            super(config)
          end
          def build_entity(vertex); ''; end
          def build_relation(vertex, edge, o_vertex); ''; end
          def build_footer; ''; end
        end
        builder = impl.new
        builder.should_receive(:build_footer).and_return('')
        builder.build_uml(graph)
      end
      
      it "excludes entity specified in config" do
        impl = Class.new do
          include UmlBuilder
          def initialize config
            super(config)
          end
          def build_entity(vertex); ''; end
          def build_relation(vertex, edge, o_vertex); ''; end
          def build_footer; ''; end
        end
        builder = impl.new({ 'delimiter' => '::', 'exclude' => ['Array'] })

        g = Digraph.new
        v = Vertex.new 'Array', :class
        g.add_vertex v
        
        builder.should_not_receive(:build_entity)
        builder.build_uml(g)
      end
    end
  end
end
