struct Interval{T}
    a::T
    b::T
end

"
    interval(compare_fn, array)
returns an interval of a sorted array which would contain a value for which compare_fn(value) == 0
"
function Interval(compare::Function, arr)
    index = bsearch(compare, arr)
    found_exactly = index <= length(arr) && compare(arr[index]) == 0
    if found_exactly
        a = index
        b = index + 1
    else
        a = index - 1
        b = index
    end
    Interval(a, b)
end

function Base.length(interval::Interval)
    interval.b - interval.a
end

function Base.contains(interval, value; open_left = false, open_right = false)
    if open_left && open_right
        interval.a < value < interval.b
    elseif open_left
        interval.a < value <= interval.b
    elseif open_right
        interval.a <= value < interval.b
    else
        interval.a <= value <= interval.b
    end
end

interpolation(interval, value) = (value - interval.a) / length(interval)

function Base.Math.clamp(i::Interval, lo, hi)
    Interval(clamp(i.a, lo, hi), clamp(i.b, lo, hi))
end
