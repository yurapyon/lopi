module Geometry

using LinearAlgebra

struct Circle
    center::Vector
    radius::Real
end

struct LineSegment
    a::Vector
    b::Vector
end

struct Triangle
    a::Vector
    b::Vector
    c::Vector
end

# ===

sqrdist(a, b) = sum((a - b) .^ 2)
scalarproj(a, b) = (a ⋅ b) / (b ⋅ b)
ison(a, b) = 0 <= scalarproj(a, b) <= 1
vecproj(a, b) = b * scalarproj(a, b)
cross2d(a, b) = a[1] * b[2] - a[2] * b[1]
normal2d(a, b, c) = cross2d(a - b, a - c)
centroid(tri) = (tri.a + tri.b + tri.c) / 3

# ===

intersects(point::Vector, circle::Circle) = sqrdist(circle.center, point) <= circle.radius^2

function intersects(line_segment::LineSegment, circle::Circle)
    if (intersects(line_segment.a, circle) || intersects(line_segment.b, circle))
        return true
    end

    line_vector = line_segment.b - line_segment.a
    circle_vector = circle.center - line_segment.a
    projection = vecproj(circle_vector, line_vector)
    ison(projection, line_vector) && intersects(projection, circle)
end

function intersects(point::Vector, tri::Triangle)
    na = normal2d(tri.a, tri.b, point)
    nb = normal2d(tri.b, tri.c, point)
    nc = normal2d(tri.c, tri.a, point)
    has_positive = na > 0 || nb > 0 || nc > 0
    has_negative = na < 0 || nb < 0 || nc < 0
    !(has_positive && has_negative)
end

end
