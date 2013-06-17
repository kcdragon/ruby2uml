module Exploration

  # Contract: All classes that inherit ResolveStrategy must implement +is_same?(v1, v2)+.
  #
  # == ResolveStrategy.is_same(v1, v2)
  # [arguments] - +v1+ a Vertex object
  #             - +v2+ a Vertex object
  #
  class ResolveStrategy

    # precondition: vertices contains more the one Vertex
    # postcondition: the namespace of the merged vertex will be the namespace among vertices that is the longest
    def merge_vertices *vertices
      merged = vertices[0].dup
      (1...vertices.length).each do |i|
        v = vertices[i]
        merged.namespace = v.namespace if v.namespace.count > merged.namespace.count
        merged.paths.concat v.paths

        v.each do |edge, set|
          set.each do |o|
            merged.add_edge edge, o
          end
        end
      end
      merged
    end
  end
end
