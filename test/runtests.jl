# flaschenpostMILPTest Tests

using Test
using flaschenpostMILP
using JuMP
using HiGHS

@testset "flaschenpostMILPTest Tests" begin
    @testset "Basic Tests" begin
        @test true
        @test 1 + 1 == 2
    end

    @testset "More Tests" begin
        @test main() == 0
    end
end
