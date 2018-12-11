using Test
using SentinelMissings

x  = [0.1,0.2,0.3,-9999.0]
xs = as_sentinel(x,-9999.0)
@test eltype(xs)<:SentinelMissings.SentinelMissing
@test isequal.(copy(xs),[0.1,0.2,0.3,missing]) |> all
@test typeof(copy(xs)) == Vector{Union{Missing,Float64}}
@test isequal.(xs[1:3], [0.1,0.2,0.3]) |> all
@test isapprox.((xs .+ 0.1)[1:3], [0.2,0.3,0.4]) |> all
xs[3] = missing
@test x[3] == -9999.0
