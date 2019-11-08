[![Build Status](https://travis-ci.org/meggart/SentinelMissings.jl.svg?branch=master)](https://travis-ci.org/meggart/SentinelMissings.jl)

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

### Mmap-example

This is an example how to use SentinelMissings with Mmap:

````julia
x = [1 2 3;
  4 5 6;
  -1 -1 10]
open("./mmap.bin","w") do f
    write(f,x)
end
using Mmap
xm = open("./mmap.bin","r+") do f
    Mmap.mmap(f, Matrix{Int}, (3,3))
end
xs = as_sentinel(xm,-1)
````
````
3×3 reinterpret(SentinelMissings.SentinelMissing{Int64,-1}, ::Array{Int64,2}):
       1        2   3
       4        5   6
 missing  missing  10
````

You can do some operations:

````julia
any(ismissing,xs,dims=1)
````
````
1×3 Array{Bool,2}:
 true  true  true
````

Still there is no copy, the array is just reinterpreted, so that `xs` and `xm` point to the same file:

````julia
xs[:,3] = missing
xs
````
````
3×3 reinterpret(SentinelMissings.SentinelMissing{Int64,-1}, ::Array{Int64,2}):
       1        2  missing
       4        5  missing
 missing  missing  missing
````

````julia
xm
````
````
3×3 Array{Int64,2}:
  1   2  -1
  4   5  -1
 -1  -1  -1
````
