# SentinelMissings.jl


This small package is an attempt to deal with data where missing values are
represented through a so-called sentinel value.
For example, you have an array

```julia
x = [0.1,0.2,-9999.0]
```

where the `-9999.0` represents missing data. We can reinterpret this array without copying:

````
julia> xs = as_sentinel(x,-9999.0)
3-element reinterpret(SentinelMissings.SentinelMissing{Float64,-9999.0}, ::Array{Float64,1}):
     0.1
     0.2
 missing
````

all operations will promote the `SentinelMissing` type to a `Union{T,Missing}` through
Julias type promotion system.

````
julia> xs .- 0.1
3-element Array{Union{Missing, Float64},1}:
 0.0
 0.1
  missing
````

Although conversion to a `SentinelMissing` is defined as well:

````
julia> xs[2]=missing;x
3-element Array{Float64,1}:
     0.1
 -9999.0
 -9999.0
````
