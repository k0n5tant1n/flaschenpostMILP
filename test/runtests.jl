# flaschenpostMILPTest Tests

using Test
using flaschenpostMILP
using JuMP
using HiGHS
import MathOptInterface as MOI

include("testData.jl")
include("testGraphs/graphviz.jl")
include("testGraphs/tikz.jl")


@testset "One location feasible tests" begin
    @testset "Objective Value Tests" begin
        model = build_model(ONE_LOCATION_FEASIBLE)
        set_silent(model)
        set_optimizer(model, () -> HiGHS.Optimizer())
        optimize!(model)
        export_graphviz("./testGraphs/OneLocationFeasible.dot", ONE_LOCATION_FEASIBLE, model[:A], model[:t])
        export_tikz("./testGraphs/OneLocationFeasible.tex", ONE_LOCATION_FEASIBLE, model[:A], model[:t])
        @test is_solved_and_feasible(model) == true
        @test objective_value(model) == 10
    end

    @testset "Solution Tests" begin
        model = build_model(ONE_LOCATION_FEASIBLE)
        set_silent(model)
        set_optimizer(model, () -> HiGHS.Optimizer())
        optimize!(model)
        @test is_solved_and_feasible(model) == true
        A = model[:A]
        t = model[:t]
        @test value(A[1,2]) == 1
        @test value(A[2,1]) == 1
        @test value(t[2]) == 3
        @test value(t[1]) == 10
    end
end


@testset "One location infeasible tests" begin
    model = build_model(ONE_LOCATION_INFEASIBLE)
    set_silent(model)
    set_optimizer(model, () -> HiGHS.Optimizer())
    optimize!(model)
    @test is_solved_and_feasible(model) == false
    @test termination_status(model) == MOI.INFEASIBLE
end


@testset "Two location feasible tests" begin
    model = build_model(TWO_LOCATION_FEASIBLE)
    set_silent(model)
    set_optimizer(model, () -> HiGHS.Optimizer())
    optimize!(model)
    export_graphviz("./testGraphs/TwoLocationFeasible.dot", TWO_LOCATION_FEASIBLE, model[:A], model[:t])
    export_tikz("./testGraphs/TwoLocationFeasible.tex", TWO_LOCATION_FEASIBLE, model[:A], model[:t])
    @test is_solved_and_feasible(model) == true
    A = model[:A]
    t = model[:t]
    @test value(A[1,2]) == 1
    @test value(A[2,3]) == 1
    @test value(A[3,1]) == 1
    @test value(t[2]) == 5
    @test value(t[3]) == 13
    @test value(t[1]) == 25
end