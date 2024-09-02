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

include("intervals.jl")
