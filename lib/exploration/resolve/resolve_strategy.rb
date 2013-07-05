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

  # For all incoming edges, for all +vertices+, change the refernce from that vertex to the merged vertex. For example, if Foo depends on Bar, and Bar was merged into Merged then Foo should now reference Merged.
  #
  # postcondition: all incoming edges that reference a vertex in +vertices+ will now reference +merged+.
  def rereference_incoming_edges! merged, *vertices
    to_add = []
    vertices.each do |vertex|
      vertex.each_incoming do |edge, set|
        set.each do |incoming|
          incoming.remove_edge edge, vertex
          to_add << [incoming, edge, merged]
        end
      end
    end
    to_add.each do |incoming, edge, merged|
      incoming.add_edge edge, merged
    end
  end
end
