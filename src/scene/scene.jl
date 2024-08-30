module Scene

mutable struct Node
    parent::Maybe{Node}
    children::Vector{Node}
end

function setparent!(child, parent)
    if isnothing(child.parent)
        delete!(child.parent.children, child)
    end
    child.parent = Some(parent)
    push!(parent.children, child)
end

struct Tag
    id::String
    name::String
end

struct Scene
    tag::Tag
    root::SceneNode
    nodes::Vector{SceneNode}
end

struct SceneNode
    tag::Tag
    node::Node
    spatial::Spatial
end

struct Spatial
    is_active::Bool
    transform::Transform
end

end
