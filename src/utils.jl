const Maybe{T} = Union{Some{T}, Nothing}

"""
    bsearch(compare_fn, array)
compare should return the difference between the target value and the testValue.  
  negative if testValue is too high.  
  positive if testValue is too low.  
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
            search_start = search_at
            break
        elseif direction < 0
            search_end = search_at - 1
        else
            search_start = search_at + 1
        end
    end

    search_start
end

struct Interval
    a::UInt
    a_inf::Bool
    b::UInt
    b_inf::Bool
end

"
returns a closed interval of the array
"
function Interval(compare, arr)
    index = bsearch(compare, arr)
    found_exactly = index <= length(arr) && compare(arr[index]) == 0

    if found_exactly
        a = index
        a_inf = false
        b = index + 1
        b_inf = b > length(arr)
    else
        if index == 1
            a = index
            a_inf = true
            b = index
            b_inf = false
        else
            a = index - 1
            a_inf = false
            b = index
            b_inf = b > length(arr)
        end
    end

    Some(Interval(a, b, a_inf, b_inf))
end
