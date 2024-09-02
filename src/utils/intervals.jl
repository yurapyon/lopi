# todo could probably use ranges for this somehow?
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
        i::Interval{T},
        value;
        open_left = false,
        open_right = false
    ) where T
    a = @something i.a begin
        open_left = false
        typemin(T)
    end
    b = @something i.b begin
        open_right = false
        typemax(T)
    end
    above = open_left ? a < value : a <= value
    below = open_right ? value < b : value <= b
    above && below
end

function interpolation(i::Interval{T}, value) where T
    a = @something i.a return zero(T)
    b = @something i.b return zero(T)
    (value - a) / length(i)
end
