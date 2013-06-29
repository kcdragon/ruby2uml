require_relative '../../lib/graph/digraph'
require_relative '../../lib/graph/namespace'
require_relative '../../lib/graph/vertex'

describe Graph::Digraph do
  let(:one) { Graph::Vertex.new 'one', :class }
  let(:two) { Graph::Vertex.new 'two', :class }
  let(:three) { Graph::Vertex.new 'three', :class }

  it { should respond_to :find_vertex }
  it { should respond_to :has_vertex? }
  it { should respond_to :add_vertex }
  it { should respond_to :remove_vertex }

  def add_all_vertices_to_subject
    [one, two, three].each { |v| subject.add_vertex v }
  end

  it "adds a vertex" do
    lambda {
      subject.add_vertex one
    }.should change { subject.has_vertex? 'one' }.from(false).to(true)
  end

  it "removes a vertex" do
    add_all_vertices_to_subject
    lambda {
      subject.remove_vertex two
    }.should change { subject.has_vertex? 'two' }.from(true).to(false)
  end

  it "enumerates the vertices" do
    add_all_vertices_to_subject
    expect { |b| subject.each(&b) }.to yield_successive_args one, two, three
  end

  describe "finds the vertices that match" do
    let(:foo_bar) { Graph::Vertex.new 'Bar', :class, ['Foo'] }
    let(:bar) { Graph::Vertex.new 'Bar', :class }
    let(:hello_world) { Graph::Vertex.new 'World', :class, ['Hello'] }
    let(:baz_with_path) { Graph::Vertex.new('Baz', :class).tap { |me| me.paths = ['path.rb'] } }
    let(:graph) do
      Graph::Digraph.new.tap do |g|
        g.add_vertex foo_bar
        g.add_vertex bar
        g.add_vertex hello_world
        g.add_vertex baz_with_path
      end
    end
    subject { graph }

    context "no vertices match" do
      it "not match when name doesn't exist" do
        expect(subject.find_vertex('Foo')).to be_empty
      end

      it "not match when namespace is incorrect" do
        expect(
               subject.find_vertex('Bar', Graph::Namespace.new(['Hello']))
               ).to be_empty
      end

      it "not match when path is incorrect" do
        expect(
               subject.find_vertex('Bar', Graph::Namespace.new(['Foo']), ['path.rb'])
               ).to be_empty
      end
    end

    context "there are vertices that match" do
      it "matches two with name" do
        expect(subject.find_vertex('Bar')).to match_array [foo_bar, bar]
      end
      
      it "matches one with namespace" do
        expect(
               subject.find_vertex('World', Graph::Namespace.new(['Hello']))
               ).to match_array [hello_world]
      end

      it "matches with path" do
        expect(
               subject.find_vertex('Baz', nil, ['path.rb'])
               ).to match_array [baz_with_path]
      end
    end
  end
end
