struct Keyframe
    frame_at::Int
    index::Int
end

const Animation = Vector{Keyframe}

mutable struct Animator
    frame_at::Int
    last_interval::Interval{Int}
    animation::Animation

    function Animator(animation)
        ret = new(1, Interval{Int}(nothing, nothing), animation)
        updateinterval!(ret)
        ret
    end
end

function updateinterval!(animator)
    temp = Keyframe(animator.frame_at, 0)
    animator.last_interval = Interval(
        animator.animation, temp;
        by = kf -> kf.frame_at
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

function interpolation(amtor::Animator)
    interpolation(amtor.last_interval, amtor.frame_at)
end
