# Min cost path finding - A*
inputs = read("C:\\Users\\varunjos\\Documents\\GitHub\\AdventCode2021\\Day15\\input.txt", String) # Read all the inputs

# Parse the inputs
inputs = replace(inputs,'\r'=>"")                   # Sanitize inputs
inputs = split.(inputs,'\n')                        # Split by line
inputs = split.(inputs, "")                         # Split into digits
inputs = [parse.(Int, line) for line in inputs]     # Translate digits into integers

# Cost value for each node
costValue = inputs

# Now make it bigger, while wrapping costs such that 9+1 = 1
# Add more columns
costValBig = [vcat(a,mod.(a,9).+1,mod.(a.+1,9) .+1,mod.(a.+2,9) .+1,mod.(a.+3,9) .+1) for a in inputs]
inputs = deepcopy(costValBig)

# Add more rows
for repNum in 1:4
    for row in inputs
        push!(costValBig, mod.(row.+(repNum-1),9) .+1)
    end
end

# Support functions
# Find the adjacent elements for the input index
function getadjacents(rownum, colnum, maxrow, maxcol)
    elementList = []
    if rownum > 1
        push!(elementList, (rownum - 1,colnum))
    end
    if colnum > 1
        push!(elementList, (rownum,colnum - 1))
    end
    if rownum < maxrow
        push!(elementList, (rownum+1,colnum))
    end
    if colnum < maxcol
        push!(elementList, (rownum,colnum+1))
    end
    return elementList
end

# A star algorithm
function Astar(costInput)
    # Find the dimensions of the input
    maxX = length(costInput)
    maxY = length(costInput[1])

    # Initialize a cost dictionary
    costDict = Dict()

    # All costs start at infinity
    for (xPos, yPos) in Iterators.product(1:maxX,1:maxY)
        costDict[(xPos,yPos)] = Inf
    end

    # Starting point has 0 cost
    costDict[(1,1)] = 0

    # Start by visiting the starting point
    nodesToVisit = [(1,1)]

    # Keep on looping
    while true
        # Make a list of all the nodes that change cost in this loop
        changedNodes = []

        # Visit all the keys in the "To-Visit" list
        for key in nodesToVisit
            # Find all adjacent nodes
            adjElements = getadjacents(key[1],key[2], maxX, maxY)

            # Check the adjacent nodes
            for ele in adjElements
                # Calculate a test cost
                testCost = costDict[key] + costInput[ele[1]][ele[2]]

                # If this test cost is less than the measured cost, replace it
                if testCost < costDict[ele]
                    costDict[ele] = testCost

                    # Add this node to the list of changed nodes
                    push!(changedNodes, ele)
                end
            end
        end

        # If no nodes changed, end the loop
        if length(changedNodes) == 0
            break
        else
            # If some nodes changed, visit them on the next pass-through
            nodesToVisit = changedNodes
        end
    end
    return costDict[(maxX,maxY)]
end

# Find the shortest path length to the end
println("#1 answer: ", Astar(costValue))
println("#2 answer: ", Astar(costValBig))
