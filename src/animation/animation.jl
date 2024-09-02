struct Keyframe{T}
    index::Int
    value::T
end

const Animation{T} = Vector{Keyframe{T}}

mutable struct Animator{T}
    frame_at::Int
    last_interval::Interval{Int}
    animation::Animation{T}

    function Animator{T}(animation) where T
        ret = new(0, Interval(0, 0), animation)
        updateinterval!(ret)
        ret
    end
end

function updateinterval!(animator)
    animator.last_interval = Interval(
        (keyframe) -> animator.frame_at - keyframe.index,
        animator.animation
    )
end

function jumpto!(animator, frame_number)
    animator.frame_at = frame_number
    frame_at_is_valid = contains(
        animator.last_interval,
        animator.frame_at;
        open_right = true
    )
    if !frame_at_is_valid
        updateinterval!(animator)
    end
end

advance1!(animator) = jumpto!(animator, animator.frame_at + 1)

function interpolated(animator, interpolate)
    anim = animator.animation
    clamped = clamp(animator.last_interval, 1, length(anim))
    i = interpolation(clamped, animator.frame_at)
    interpolate(anim[clamped.a], anim[clamped.b], i)
end
