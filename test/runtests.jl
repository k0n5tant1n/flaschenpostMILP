# flaschenpostMILPTest Tests

using Test
using flaschenpostMILP
using JuMP
using HiGHS
import MathOptInterface as MOI

include("test_data.jl")
include("graphs/tikz.jl")


@testset "One location feasible tests" begin
    @testset "Objective Value Tests" begin
        model = build_model(ONE_LOCATION_FEASIBLE)
        set_silent(model)
        set_optimizer(model, () -> HiGHS.Optimizer())
        optimize!(model)
        export_tikz("./graphs/OneLocationFeasible.tex", ONE_LOCATION_FEASIBLE, model[:A], model[:t])
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
    export_tikz("./graphs/TwoLocationFeasible.tex", TWO_LOCATION_FEASIBLE, model[:A], model[:t])
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


@testset "GeoCoordinate tests" begin
    my_home = GeoCoordinate(52.5400, 13.1587)
    @test my_home.latitude ≈ 52.5400
    @test my_home.longitude ≈ 13.1587
end