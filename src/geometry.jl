module Geometry

using LinearAlgebra
using StaticArrays

const Vec2 = SVector{2, T} where {T<:Real}
const Vec3 = SVector{3, T} where {T<:Real}
const Quat = SVector{4, T} where {T<:Real}

const Mat4 = SMatrix{4, 4, T} where {T<:Real}

abstract type Mat4Type end

struct Translation <: Mat4Type end
struct Rotation <: Mat4Type end
struct Scaling <: Mat4Type end

function Mat4(::Translation, v::Vec3)
    Mat4([
        1 0 0 v.x
        0 1 0 v.y
        0 0 1 v.z
        0 0 0   1
    ])
end

function Mat4(::Rotation, q::Quat)
    # todo verify this works
    Mat4([
        q.x -q.y -q.z -q.w
        q.y  q.x -q.w  q.z
        q.z  q.w  q.x -q.y
        q.w -q.z  q.y  q.x
    ])
end

function Mat4(::Scaling, v::Vec3)
    Mat4([
        v.x   0   0 0
          0 v.y   0 0
          0   0 v.z 0
          0   0   0 1
    ])
end

function Mat4(translation::Vec3, rotation::Quat, scale::Vec3)
    # TODO
end

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
