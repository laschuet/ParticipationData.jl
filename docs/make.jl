using Documenter
using ParticipationData

makedocs(
    modules = [ParticipationData],
    sitename = "ParticipationData.jl",
    pages = [
        "Home" => "index.md",
    ],
)

deploydocs(repo = "github.com/laschuet/ParticipationData.jl.git")
