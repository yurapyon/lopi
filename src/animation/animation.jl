struct Keyframe{T}
    index::Int
    value::T
end

struct Animation{T}
    keyframes::Vector{Keyframe{T}}
end
