module ParticipationData

using Cascadia
using DataFrames
using Gumbo
using SQLite
using XLSX

export liqd,
        mwp

include("liqd.jl")
include("mwp.jl")

end # module ParticipationData
