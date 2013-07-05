require 'spec_helper'
require 'exploration/dependency_relation'
require_relative 'sexp_helper'

describe DependencyRelation do
  include SexpHelper
  
  context "when there is a dependency" do
    it "dependency does not have a namespace" do
      program = "class Foo; def hello; puts Hello.hi; end; end"
      expect { |b| subject.each(get_sexp(program), { name: 'Foo', type: :class, namespace: [] }, &b) }.to yield_with_args({ name: 'Foo', type: :class, namespace: [] },
                                                                                                                          :dependency,
                                                                                                                          { name: 'Hello', type: :class, namespace: [] })
    end

    it "dependency has a namespace" do
      program = "class Foo; def hello; puts Bar::Hello.hi; end; end"
      expect { |b| subject.each(get_sexp(program), { name: 'Foo', type: :class, namespace: [] }, &b) }.to yield_with_args({ name: 'Foo', type: :class, namespace: [] },
                                                                                                                          :dependency,
                                                                                                                          { name: 'Hello', type: :class, namespace: ['Bar']})
    end
  end
  
  context "when there is not a dependency" do
    it "does not have a dependency" do
      program = "class Foo; def hello; puts 'hello'; end; end"
      expect { |b| subject.each(get_sexp(program), { name: 'Foo', type: :class, namespace: [] }, &b) }.not_to yield_control
    end
  end
end
