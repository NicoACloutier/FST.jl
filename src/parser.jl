"""
A finite-state parser.
"""
struct FSParser
    starter::Int      # the first node
    final::Int        # the final node
    arcs::Vector{Arc} # connections between nodes
end

"""
Convert a finite-state automaton to a parser.
Arguments:
    `automaton::FSAutomaton`: the finite-state automaton to convert.
Returns:
    `::FSParser`: the converted finite-state parser.
"""
function parser(automaton::FSAutomaton)
    FSParser(automaton.starter, automaton.final, automaton.arcs)
end

"""
Find a vector of integer IDs for possible next nodes given a node and a finite-state parser.
Arguments:
    `machine::FSAutomaton`: the finite-state parser.
    `node::Int`: the node to find the next nodes of.
Returns:
    `::Vector{Arc}`: a vector of arcs originating at the node in question.
"""
function next(machine::FSParser, node::Int)::Vector{Arc}
    filter(arc -> arc.origin == node, machine.arcs)
end

"""
Recognize a vector of string patterns utilizing a finite-state parser, return whether recognized and path traversed.
    Returns empty vector for path traversed if not recognized.
Arguments:
    `patterns::Vector{String}`: the vector of string patterns to check against.
    `machine::FSAutomaton`: the finite-state machine.
Returns:
    `::Bool`: whether the patterns were recognized.
    `::Vector{Int}`: the path traversed. Empty if no end node found.
"""
function recognize(patterns::Vector{String}, machine::FSParser)::Tuple{Bool, Vector{Int}}
    current_node = machine.starter
    path = [current_node,]
    for (i, pattern) in enumerate(patterns[1:end-1])
        potentials = filter(arc -> arc.pattern == pattern, next(machine, current_node))
        if length(potentials) == 0
            return (false, [])
        end
        current_node = potentials[1].destination
        push!(path, current_node)
    end
    ends = filter(arc -> arc.pattern == patterns[end] && arc.destination == machine.final, next(machine, current_node))
    found = length(ends) >= 1
    (found, found ? vcat(path, [ends[1].destination]) : [])
end