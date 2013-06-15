module Exploration

  # Contract: All classes that inherit ResolveStrategy must implement +resolve(graph)+.
  #
  # == ResolveStrategy#resolve(graph)
  # [arguments] - +graph+ a Digraph object
  #
  class ResolveStrategy

    # precondition: vertices contains more the one Vertex
    # postcondition: the namespace of the merged vertex will be the namespace among vertices that is the longest
    def merge_vertices *vertices
      merged = vertices[0]
      (1...vertices.length).each do |i|
        v = vertices[i]
        merged.namespace = v.namespace if v.namespace.length > merged.namespace.length
        merged.paths.concat v.paths

        v.each do |edge, set|
          set.each do |o|
            merged.add_edge edge, o
          end
        end
      end
    end
  end
end
