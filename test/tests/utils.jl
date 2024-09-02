@testset "intervals" begin
    a = [1, 2, 4]
    @test Interval(a, 1) == Interval(Some(1), Some(2))
    @test Interval(a, 3) == Interval(Some(2), Some(4))
    @test Interval(a, 0) == Interval(nothing, Some(1))
    @test Interval(a, 5) == Interval(Some(4), nothing)
    @test length(Interval(a, 1)) == 1
    @test length(Interval(a, 0)) == nothing
    @test interpolation(Interval(a, 3), 3) ≈ 0.5
    @test interpolation(Interval(a, 0), 1) ≈ 0
    @test contains(Interval(a, 0), -1)
    @test contains(Interval(a, 5), 6)
    @test contains(Interval(a, 3), 2)
end
