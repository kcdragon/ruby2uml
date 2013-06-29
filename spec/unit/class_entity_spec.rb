require_relative '../../lib/exploration/class_entity'
require_relative '../../lib/exploration/dependency_relation'
require_relative '../../lib/sexp_factory'
require_relative 'sexp_helper'

describe Exploration::ClassEntity do
  include SexpHelper
  
  context "ruby program" do
    it "has a dependency" do
      program = "class Foo; def hello; puts Hello.hi; end; end"

      subject.add_explorer Exploration::DependencyRelation.new
      expect do |b|
        subject.each(get_sexp(program), nil, &b)
      end.to yield_successive_args(
                                   { name: 'Foo', type: :class, namespace: [] },
                                   [{ name: 'Foo', type: :class, namespace: [] }, :dependency, { name: 'Hello', type: :class, namespace: [] }])
    end

    it "does not have a dependency" do
      program = "class Foo; def hello; puts 'hello'; end; end"
      expect { |b| subject.each(get_sexp(program), nil, &b) }.to yield_with_args({ name: 'Foo', type: :class, namespace: [] })
    end

    it "does not explore classes nested inside module" do
      program = "module Bar; class Foo; end; end"
      expect { |b| subject.each(get_sexp(program), nil, &b) }.to_not yield_control
    end
  end
end
