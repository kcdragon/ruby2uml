require_relative '../../lib/graph/edge'
require_relative '../../lib/graph/edge_factory'

describe Graph::EdgeFactory do
  it "should contain aggregation" do
    subject.get_edge(:aggregation).should_not be_nil
    subject.get_edge(:aggregation).should eql(Graph::AggregationEdge.new)
    subject.get_edge(:aggregation).should_not eql(Graph::CompositionEdge.new)
  end

  it "should contain composition" do
    subject.get_edge(:composition).should_not be_nil
    subject.get_edge(:composition).should eql(Graph::CompositionEdge.new)
  end

  it "should contain implements" do
    subject.get_edge(:implements).should_not be_nil
    subject.get_edge(:implements).should eql(Graph::ImplementsEdge.new)
  end

  it "should contain generalization" do
    subject.get_edge(:generalization).should_not be_nil
    subject.get_edge(:generalization).should eql(Graph::GeneralizationEdge.new)
  end

  it "should contain dependency" do
    subject.get_edge(:dependency).should_not be_nil
    subject.get_edge(:dependency).should eql(Graph::DependencyEdge.new)
  end
end
