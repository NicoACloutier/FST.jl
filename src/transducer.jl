"""
A translating arc between two nodes in a finite-state transducer.
"""
struct TransArc
    origin::Int                        # the origin node
    destination::Int                   # the destination node
    translations::Dict{String, String} # the translation patterns
end

"""
A finite-state transducer.
"""
struct FSTransducer
    starter::Int           # the first node
    final::Int             # the final node
    arcs::Vector{TransArc} # connections between nodes
end

"""
Find a vector of integer IDs for possible next nodes given a node and a finite-state transducer.
Arguments:
    `machine::FSTransducer`: the finite-state transducer.
    `node::Int`: the node to find the next nodes of.
Returns:
    `::Vector{TransArc}`: a vector of arcs originating at the node in question.
"""
function next(machine::FSTransducer, node::Int)::Vector{TransArc}
    filter(arc -> arc.origin == node, machine.arcs)
end

"""
Translate a string pattern with a finite-state transducer.
Arguments:
    `patterns::Vector{String}`: the patterns to translate.
    `machine::FSTransducer`: the finite-state transducer.
Returns:
    `::Vector{String}`: the translated string patterns.
"""
function translate(patterns::Vector{String}, machine::FSTransducer)::Vector{String}
    current_node = machine.starter
    translation::Vector{String} = []
    for (i, pattern) in enumerate(patterns)
        potentials = filter(arc -> in(pattern, keys(arc.translations)), next(machine, current_node))
        if length(potentials) == 0
            return translation
        end
        current_node = potentials[1].destination
        push!(translation, potentials[1].translations[pattern])
    end
    translation
end