module Mesh

struct Vertex
    position::Vector
end

struct Edge
    a::Vertex
    b::Vertex
end

struct Tri
    a::Vertex
    b::Vertex
    c::Vertex
end

end
