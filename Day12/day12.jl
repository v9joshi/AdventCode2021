# Navigating caves (some graph stuff)
inputs = read("C:\\Users\\varunjos\\Documents\\GitHub\\AdventCode2021\\Day12\\input.txt", String) # Read all the inputs

# Parse the inputs
inputs = replace(inputs,'\r'=>"")  # Sanitize inputs
inputs = split.(inputs,'\n') # Split by line
inputs = [split.(line,'-') for line in inputs]

# Make some support functions
# Remove a node from the entire dictionary
function removeNode(inputDict, node)
    # println("Deleting ", node, " from ")
    # println(localDict)
    localDict = deepcopy(inputDict)
    # Remove the key
    delete!(localDict, node)

    # Remove nodes from values as well
    for key in keys(localDict)
        filter!(ele -> ele != node, localDict[key])
    end

    # println("removing ", node ," result ")
    # println(localDict)

    # Return the dictionary
    return localDict
end

# Find path from one node to another
function findPath(inputDict, startNode, endNode, passCounter)
    allPaths = []
    localPassCounter = deepcopy(passCounter)

    # Count the number of passes for each node
    if startNode in keys(localPassCounter) && startNode == lowercase(startNode)
        localPassCounter[startNode] += 1
    else
        localPassCounter[startNode] = 1
    end

    # Check if you've reached the end
    if startNode == endNode
        # If you've reached the end terminate
        #println(startNode)
        #println("---")
        return endNode
    else
        # println(startNode, " then ")
        # If we haven't reached the end, check the nodes connected to the start node
        nodeList = inputDict[startNode]

        if (length(nodeList) == 0 || count(numReps -> numReps > 1, values(localPassCounter)) > 1)
            # println("Node list is empty")
            # println("-")
            return "invalid path"
        end

        # If the start node is lower case, remove it from the dict
        localDict = deepcopy(inputDict)
        if startNode == "start"
            localDict = removeNode(localDict, startNode)
        elseif (startNode == lowercase(startNode) && count(numReps -> numReps > 1, values(localPassCounter)) > 0)
            localDict = removeNode(localDict, startNode)
        end

        # If you haven't reached the end check every connected node
        for node in nodeList
            # Once the start node has been removed look for paths to the end
            # println("test ", node)
            # println(localDict)
            allPaths = vcat(allPaths, findPath(localDict, node, endNode, localPassCounter))
        end

        # Return every path to the end found so far
        return vcat.(startNode, allPaths)
    end
end


# Make a dict to represent the graph
graphDict = Dict()
for line in inputs
    # Add the left and right parts of the line to dict and connect them
    if !in(line[1], keys(graphDict))
        global graphDict[line[1]] = []
    end
    if !in(line[2], keys(graphDict))
        global graphDict[line[2]] = []
    end

    # Connect both nodes
    push!(graphDict[line[1]], line[2])
    push!(graphDict[line[2]], line[1])
end

# Find paths from start to end
# println("-------")
# println(graphDict)
# println("-------")
passCounter = Dict()
allPaths = findPath(graphDict,"start","end", passCounter)
# println("-------")
# println(graphDict)
# println("-------")
# Clean up paths that don't lead anywhere
allPaths = filter(path -> in("end", path), allPaths)

# println.(sort(allPaths))

# Print the results
println("Number of paths = ", length(allPaths))
