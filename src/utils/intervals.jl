# an interval
# a value of nothing for a or b means it goes to -∞ or +∞
struct Interval{T<:Real}
    a::Maybe{T}
    b::Maybe{T}
end

function Interval(v::Vector, x; by=identity, lt=isless)
    index = searchsortedfirst(v, x; by=by, lt=lt)
    found_exactly = index <= length(v) && !lt(by(x), by(v[index]))
    if found_exactly
        a = index
        b = index + 1
    else
        a = index - 1
        b = index
    end
    left = a == 0 ? nothing : Some(by(v[a]))
    right = b > length(v) ? nothing : Some(by(v[b]))
    Interval(left, right)
end

function Base.length(i::Interval)
    a = @something i.a return nothing
    b = @something i.b return nothing
    b - a
end

function Base.contains(
        i::Interval{T}, value;
        open_left = false, open_right = false
    ) where T

    if isnothing(i.a)
        above = true
    else
        a = something(i.a)
        above = open_left ? a < value : a <= value
    end

    if isnothing(i.b)
        below = true
    else
        b = something(i.b)
        below = open_right ? value < b : value <= b
    end

    above && below
end

function interpolation(i::Interval{T}, value) where T
    a = @something i.a return one(T)
    b = @something i.b return zero(T)
    (value - a) / length(i)
end
