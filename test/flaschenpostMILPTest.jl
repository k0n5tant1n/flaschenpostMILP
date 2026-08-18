# flaschenpostMILPTest Tests

using Test
using flaschenpostMILP

@testset "flaschenpostMILPTest Tests" begin
    @testset "Basic Tests" begin
        @test true
        @test 1 + 1 == 2
    end

    @testset "More Tests" begin
        @test main() == 1
    end
end
