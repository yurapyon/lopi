@testset "animations" begin
    values = [
        'a',
        'b',
        'c',
        'd',
        'e',
    ]
    anim = [
        Keyframe(1, 1),
        Keyframe(2, 2),
        Keyframe(3, 3),
        Keyframe(6, 4),
        Keyframe(9, 5),
    ]
    amtor = Animator(anim)
    @test amtor.last_interval == Interval(Some(1), Some(2))
    advance1!(amtor)
    @test amtor.last_interval == Interval(Some(2), Some(3))
    advance1!(amtor)
    @test amtor.last_interval == Interval(Some(3), Some(6))
    @test interpolation(amtor) ≈ 0
    advance1!(amtor)
    @test amtor.last_interval == Interval(Some(3), Some(6))
    @test interpolation(amtor) ≈ 1/3
    advance1!(amtor)
    @test amtor.last_interval == Interval(Some(3), Some(6))
    @test interpolation(amtor) ≈ 2/3
end
