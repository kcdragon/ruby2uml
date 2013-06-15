require_relative '../../lib/exploration/resolve/simple_resolve_strategy'
require_relative '../../lib/graph/digraph'

describe Exploration::SimpleResolveStrategy do
  before :each do
    @graph = Graph::Digraph.new
    @ef = Graph::EdgeFactory.instance
  end
  subject { @graph }
  
  it { respond_to :resolve }

  it "should resolve a name with and without a module" do
    
  end
end
