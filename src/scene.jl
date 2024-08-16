struct Tag
    id::String
    name::String
end

struct Scene
    tag::Tag
    # root::
end

struct Node
    tag::Tag
    parent::Node
    children::Vector{Node}
end

struct Spatial
    node::Node
    is_active::Bool
end

struct Transform
    position::Vector
    rotation::Vector
    scale::Vector
end
