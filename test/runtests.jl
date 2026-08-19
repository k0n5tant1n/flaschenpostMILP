# flaschenpostMILPTest Tests

using Test
using flaschenpostMILP
using JuMP
using HiGHS

@testset "flaschenpostMILPTest Tests" begin
    @testset "Objective Value Tests" begin
        @test main() == 9
    end

    @testset "Solution Tests" begin
        @test main() == 9
    end
end
