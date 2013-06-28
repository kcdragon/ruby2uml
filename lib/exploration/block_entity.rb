require_relative 'entity'

module Exploration
  class BlockEntity < Entity
    def each sexp, context=nil, &block
      # REFACTOR similar code in entity.rb
      if sexp.first == :block
        sexp.each_child do |sub_sexp|
          @explorers.each do |exp|
            exp.each sub_sexp, context, &block
          end
        end
      end
    end
  end
end
