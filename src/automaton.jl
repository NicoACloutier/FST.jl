"""
A node of a finite-state automaton.
"""
struct Node
    pattern::String                    # the string pattern to match on the node
    next::Vector{Union{Node, Nothing}} # a vector of nodes it points to, `::Nothing` if this is a terminal node.
end

"""
A finite-state automaton.
"""
struct FSAutomaton
    starter::Node #the first node
end

"""
Find a pattern match in a series of next nodes given a node to check on.
Arguments:
    `pattern::String`: the pattern.
    `node::Node`: the node to check the next nodes of.
Returns:
    `::Union{Int, Nothing, Missing}`: `::Int` with the index of the first matching pattern if present, `::Nothing` if terminal node, 
        `::Missing` if no node was found with a matching pattern.
"""
function find_pattern(pattern::String, node::Node)::Union{Int, Nothing, Missing}
    for (i, potential_next) in enumerate(node.next)
        if isnothing(potential_next)
            return nothing
        elseif pattern == potential_next.pattern
            return i
        end
    end
    return missing
end

"""
Recognize a string pattern utilizing a fine-state automaton.
Arguments:
    `patterns::Vector{String}`: the patterns to be recognized by the finite-state automaton.
    `machine::FSAutomaton`: the finite-state automaton.
Returns:
    `::Bool`: whether the string pattern is matched.
"""
function recognize(patterns::Vector{String}, machine::FSAutomaton)::Bool
    current_node = machine.starter
    for (i, pattern) in enumerate(patterns)
        next = find_pattern(pattern, current_node)
        if isnothing(next) && i != length(patterns)
            return false
        elseif ismissing(next)
            return false
        end
        current_node = current_node.next[i]
    end
    map(isnothing, current_node.next) |> any
end

"""
Generate a string pattern utilizing a finite-state automaton. Automatically selects the first next node if multiple are present.
    Not guaranteed to reach a stopping point.
Arguments:
    `machine::FSAutomaton`: the finite-state automaton.
Returns:
    `::Vector{String}`: the output.
"""
function generate(machine::FSAutomaton)::Vector{String}
    pattern::Vector{String} = []
    current_node = machine.starter
    while !isnothing(current_node.next)
        push!(pattern, current_node.pattern)
        current_node = current_node.next[1]
    end
    pattern
end