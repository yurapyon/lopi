const Maybe{T} = Union{Some{T}, Nothing}

"""
    bsearch(compare_fn, array)
compare_fn should return the difference between the target value and the test value.  
  negative if test value is too high.  
  positive if test value is too low.  
returns the index of a value that is equal to or greater than the search value.  
"""
function bsearch(compare, arr)
    search_start = 1
    search_end = length(arr) + 1
    search_at = 1

    while search_start < search_end
        search_at = Int(floor((search_start + search_end) / 2))
        direction = compare(arr[search_at])
        if direction == 0
            return search_at
        elseif direction < 0
            search_end = search_at
        else
            search_start = search_at + 1
        end
    end

    search_start
end

struct Interval
    a::Int
    b::Int
    bounded_left::Bool
    bounded_right::Bool
end

"
returns a closed interval of the array
"
function Interval(compare, arr)
    index = bsearch(compare, arr)
    found_exactly = index <= length(arr) && compare(arr[index]) == 0

    if found_exactly
        a = index
        bounded_left = true
        b = index + 1
        bounded_right = b <= length(arr)
    else
        if index == 1
            a = index
            bounded_left = false
            b = index
            bounded_right = true
        else
            a = index - 1
            bounded_left = true
            b = index
            bounded_right = b <= length(arr)
        end
    end

    Interval(a, b, bounded_left, bounded_right)
end
