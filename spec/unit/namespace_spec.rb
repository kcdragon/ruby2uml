require_relative '../../lib/graph/namespace'

describe Graph::Namespace do
  before :all do
    @namespace = Graph::Namespace.new ['B', 'C']
  end

  subject { @namespace }

  context "namespace is included by other namespace" do
    before :all do
      @other = Graph::Namespace.new ['A', 'B', 'C']
    end

    it "is included by" do
      expect(subject.is_included_by?(@other)).to be_true
    end
    
    it "does not include" do
      expect(subject.does_include?(@other)).to be_false
    end

    it "is not the same" do
      expect(subject.eql?(@other)).to be_false
    end
  end

  context "namespace does include other namespace" do
    before :all do
      @other = Graph::Namespace.new ['C']
    end

    it "is not included by" do
      expect(subject.is_included_by?(@other)).to be_false
    end
    
    it "does include" do
      expect(subject.does_include?(@other)).to be_true
    end

    it "is not the same" do
      expect(subject.eql?(@other)).to be_false
    end
  end

  context "namespace includes and is included by (i.e. same as) other namespace" do
    before :all do
      @other = Graph::Namespace.new ['B', 'C']
    end

    it "is included by" do
      expect(subject.is_included_by?(@other)).to be_true
    end
    
    it "does include" do
      expect(subject.does_include?(@other)).to be_true
    end

    it "is the same" do
      expect(subject.eql?(@other)).to be_true
    end
  end
end
