module ParticipationData

using Cascadia
using DataFrames
using Gumbo
using SQLite
using XLSX

#=
Common contribution and comment structure

Contribution:
id                    internal, primary key
number                id from data source
author
content
ref
created_at
modified_at
pos_ratings
neg_ratings
assessment_decision
assessment_content

Comment:
id              internal, primary key
number          id from data source
author
content
reply_to
created_at
pos_ratings
neg_ratings
=#

export liqd,
        mwp

include("liqd.jl")
include("mwp.jl")

end # module ParticipationData
