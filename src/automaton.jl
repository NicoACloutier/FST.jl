"""
An arc between two nodes in a finite-state machine.
"""
struct Arc
    origin::Int      # the origin node
    destination::Int # the destination node
    pattern::String  # the arc pattern
end

"""
A finite-state automaton.
"""
struct FSAutomaton
    starter::Int      # the first node
    final::Int        # the final node
    arcs::Vector{Arc} # connections between nodes
end

"""
Find a vector of integer IDs for possible next nodes given a node and a finite-state automaton.
Arguments:
    `machine::FSAutomaton`: the finite-state automaton.
    `node::Int`: the node to find the next nodes of.
Returns:
    `::Vector{Arc}`: a vector of arcs originating at the node in question.
"""
function next(machine::FSAutomaton, node::Int)::Vector{Arc}
    filter(arc -> arc.origin == node, machine.arcs)
end

"""
Recognize a vector of string patterns utilizing a finite-state automaton, return whether recognized.
Arguments:
    `patterns::Vector{String}`: the vector of string patterns to check against.
    `machine::FSAutomaton`: the finite-state machine.
Returns:
    `::Bool`: whether the patterns were recognized.
"""
function recognize(patterns::Vector{String}, machine::FSAutomaton)::Bool
    current_node = machine.starter
    for (i, pattern) in enumerate(patterns[1:end-1])
        potentials = filter(arc -> arc.pattern == pattern, next(machine, current_node))
        if length(potentials) == 0
            return false
        end
        current_node = potentials[1].destination
    end
    any(arc -> arc.pattern == patterns[end] && arc.destination == machine.final, next(machine, current_node))
end

"""
Generate a string pattern using a finite-state automaton.
    Not guaranteed to stop.
Arguments:
    `machine::FSAutomaton`: the finite-state automaton.
Returns:
    `::Vector{String}`: the generated string pattern.
"""
function generate(machine::FSAutomaton)::Vector{String}
    pattern::Vector{String} = []
    current_node = machine.starter
    while current_node != machine.final
        arc = next(machine, current_node)[1]
        push!(pattern, arc.pattern)
        current_node = arc.destination
    end
    pattern
end