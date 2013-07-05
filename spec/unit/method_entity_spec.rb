require 'spec_helper'
require 'exploration/method_entity'
require 'exploration/dependency_relation'
require 'exploration/aggregation_relation'
require_relative 'sexp_helper'

describe MethodEntity do
  include SexpHelper

  let(:foo) { { name: 'Foo', type: :class, namespace: [] } }
  let(:say_hello) { { name: 'say_hello', type: :method } }
  let(:hello) { { name: 'Hello', type: :class, namespace: [] } }

  def get_method_entity relation
    method_entity = MethodEntity.new.tap do |me|
      me.add_explorer relation
    end
  end

  context "dependency" do
    let(:method_entity) { get_method_entity DependencyRelation.new }
    subject { method_entity }
    
    it "has a dependency" do
      program = "class Foo; def say_hello; puts Hello.hi; end; end"
      expect do |b|
        subject.each(get_sexp(program), foo, &b)
      end.to yield_successive_args([foo, :defines, say_hello], [foo, :dependency, hello])
    end

    it "does not have a dependency" do
      program = "class Foo; def say_hello; puts 'hello'; end; end"
      expect { |b| subject.each(get_sexp(program), foo, &b) }.to yield_with_args foo, :defines, say_hello
    end
  end

  context "aggregation" do
    let(:method_entity) { get_method_entity AggregationRelation.new }
    subject { method_entity }

    it "has an aggregation" do
      program = "class Foo; def say_hello; @foo = Hello.hi; end; end"
      expect do |b|
        subject.each(get_sexp(program), foo, &b)
      end.to yield_successive_args([foo, :defines, say_hello], [foo, :aggregation, hello])
    end

    it "does not have an aggregation" do
      program = "class Foo; def say_hello; puts 'hello'; end; end"
      expect { |b| subject.each(get_sexp(program), foo, &b) }.to yield_with_args foo, :defines, say_hello
    end
  end
end
