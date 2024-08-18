module Scene

using LinearAlgebra
using StaticArrays
using Geometry

struct Transform
    position::Vec3
    rotation::Quat
    scale::Vec3
end

function Matrix(t::Transform)

end

struct Tag
    id::String
    name::String
end

#=
struct Scene
    tag::Tag
    # root::
end
=#

mutable struct Node
    # tag::Tag
    parent::Union{Node, Nothing}
    children::Vector{Node}
end

function setparent!(child, parent)
    if child.parent != nothing
        delete!(child.parent.children, child)
    end
    child.parent = parent
    push!(parent.children, child)
end

struct Spatial
    node::Node
    is_active::Bool
    transform::Transform
end

end
