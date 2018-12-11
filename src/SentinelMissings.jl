module SentinelMissings
struct SentinelMissing{T,SV} <: Number
    x::T
end
Base.promote_rule(::Type{SentinelMissing{SM,SV}},::Union{T,Missing}) where {SM, SV, T}=Union{promote_type(SM,T),Missing}
Base.promote_rule(::Type{SentinelMissing{SM,SV}},::Type{T}) where {SM,SV,T} = Union{promote_type(SM,T),Missing}
Base.convert(::Type{Union{T,Missing}},sm::SentinelMissing) where {T}  = sm.x==senval(sm) ? missing : convert(T,sm[])
Base.getindex(x::SentinelMissing)=x.x==senval(x) ? missing : x.x
Base.convert(::Type{Any}, sm::SentinelMissing) = sm[]
function Base.convert(::Type{<:T}, x) where T<:SentinelMissing
  sv = senval(T)
  et = eltype(T)
  SentinelMissing{et,sv}(ismissing(x) ? sv : convert(et,x))
end
Base.convert(::Type{<:T}, x::T) where T<:SentinelMissing = x
senval(::SentinelMissing{<:Any,SV}) where SV = SV
senval(::Type{<:SentinelMissing{<:Any,SV}}) where SV = SV
Base.eltype(::Type{<:SentinelMissing{T}}) where T = T
Base.show(io::IO,x::SentinelMissing)=print(io,x[])
Base.similar(x::AbstractArray{<:SentinelMissing{T,SV}}) where {T,SV} = zeros(Union{T,Missing},size(x))
Base.similar(x::AbstractArray{<:SentinelMissing{T,SV}},dims::Tuple{Vararg{Int64,N}}) where {T,SV,N} = zeros(Union{T,Missing},dims)

"""
    as_sentinel(x, v)

Reinterprets a Number Array or a Number `x` so that values in x that equal v will be treated as missing.
This is done by reinterpreting the array as a `SentinelMissing` without copying the data.
"""
as_sentinel(x::AbstractArray{T},v) where T<:Number = reinterpret(SentinelMissing{T,convert(T,v)},x)
as_sentinel(x::T,v) where T<:Number = SentinelMissing{T,convert{T,v}}(x)
export as_sentinel
end
