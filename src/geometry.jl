module Geometry

using LinearAlgebra
using StaticArrays

const Vec2 = SVector{2, T} where {T<:Real}
const Vec3 = SVector{3, T} where {T<:Real}
const Quat = SVector{4, T} where {T<:Real}

struct Transform
    position::Vec3
    rotation::Quat
    scale::Vec3
end

function Transform()
    Transform(
        Vec3(zeros()),
        # is this right?
        Quat([1,0,0,0]),
        Vec3(ones()),
    )
end

const Mat4 = SMatrix{4, 4, T} where {T<:Real}

abstract type Mat4Type end

struct TranslationSingleton <: Mat4Type end
const Translation = TranslationSingleton()

struct RotationSingleton <: Mat4Type end
const Rotation = RotationSingleton()

struct ScalingSingleton <: Mat4Type end
const Scaling = ScalingSingleton()

function Mat4(::TranslationSingleton, v::Vec3)
    Mat4([
        1 0 0 v.x
        0 1 0 v.y
        0 0 1 v.z
        0 0 0   1
    ])
end

function Mat4(::RotationSingleton, q::Quat)
    # TODO verify this works
    Mat4([
        q.x -q.y -q.z -q.w
        q.y  q.x -q.w  q.z
        q.z  q.w  q.x -q.y
        q.w -q.z  q.y  q.x
    ])
end

function Mat4(::ScalingSingleton, v::Vec3)
    Mat4([
        v.x   0   0 0
          0 v.y   0 0
          0   0 v.z 0
          0   0   0 1
    ])
end

function Mat4(translation::Vec3, rotation::Quat, scaling::Vec3)
    # TODO this can be optimized
    T = Mat4(Translation, translation)
    R = Mat4(Rotation, rotation)
    S = Mat4(Scaling, scaling)
    R * S * T
end

@inline Mat4(t::Transform) = Mat4(t.position, t.rotation, t.scale)

struct Circle
    center::Vec2
    radius::Real
end

struct LineSegment{T<:StaticVector}
    a::T
    b::T
end

struct Triangle{T<:StaticVector}
    a::T
    b::T
    c::T
end

# ===

sqrdist(a, b) = sum((a - b) .^ 2)
scalarproj(a, b) = (a ⋅ b) / (b ⋅ b)
projections(a, b) = let sp = scalarproj(a, b); sp, b * sp end
normal(a, b, c) = (b - a) × (c - a)
normal(tri) = normal(tri.a, tri.b, tri.c)
centroid(tri) = (tri.a + tri.b + tri.c) / 3

# ===

contains(circle::Circle, point::Vec2) = sqrdist(circle.center, point) <= circle.radius^2

function contains(tri::Triangle, point::Vec2)
    na = normal(tri.a, tri.b, point)
    nb = normal(tri.b, tri.c, point)
    nc = normal(tri.c, tri.a, point)
    has_positive = na > 0 || nb > 0 || nc > 0
    has_negative = na < 0 || nb < 0 || nc < 0
    !(has_positive && has_negative)
end

function intersects(line_segment::LineSegment, circle::Circle)
    if (contains(circle, line_segment.a) || contains(circle, line_segment.b))
        return true
    end

    line_vector = line_segment.b - line_segment.a
    circle_vector = circle.center - line_segment.a
    sp, vp = projections(circle_vector, line_vector)
    0 <= sp <= 1 && contains(circle, vp)
end
@inline intersects(c::Circle, ls::LineSegment) = intersects(ls, c)

end
