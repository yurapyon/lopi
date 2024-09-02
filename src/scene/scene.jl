using UUIDs

mutable struct Spatial
    parent::Maybe{Spatial}
    children::Vector{Spatial}
    is_active::Bool
    is_active_relative::Bool
    transform::Transform
    world_matrix::Mat4
end

function Spatial()
    Spatial(
        nothing,
        [],
        true,
        true,
        Transform(),
        Mat4(),
    )
end

function setparent!(child, parent)
    if isnothing(child.parent)
        delete!(child.parent.children, child)
    end
    child.parent = Some(parent)
    push!(parent.children, child)
end

function update!(spatial)
    if isnothing(spatial.parent)
        spatial.world_matrix = Mat4(spatial.transform)
        spatial.is_active_relative = spatial.is_active
    else
        parent = something(spatial.parent)
        spatial.world_matrix = parent.world_matrix * Mat4(spatial.transform)
        spatial.is_active_relative = spatial.is_active && parent.is_active
    end
end

function updaterecursive!(spatial)
    queue = []
    current = spatial
    while true
        update!(current)
        append!(queue, current.children)
        if length(queue) == 0
            break
        end
        current = popfirst!(queue)
    end
end

struct Tag
    id::UUID
    name::String
end

Tag(name) = Tag(uuid4(), name)

struct Scene
    tag::Tag
    root::SceneNode
    nodes::Vector{SceneNode}
end

struct SceneNode{T}
    type_id::Int
    tag::Tag
    spatial::Spatial
    data::T
end

@enumx SceneNodeType begin
    Root
    Camera
end

const SceneRoot = SceneNode{Nothing}
function SceneRoot()
    SceneRoot(
        SceneNodeType.Root,
        Tag("root"),
        Spatial(),
        nothing
    )
end

const SceneCamera = SceneNode{Camera.CameraData}
function SceneCamera()
    SceneCamera(
        SceneNodeType.Camera,
        Tag("camera"),
        Spatial(),
        Camera.CameraData()
    )
end
