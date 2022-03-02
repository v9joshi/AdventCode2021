# Find the risk level of a lava tube
# Read input file
inputs = read("C:\\Users\\varunjos\\Documents\\GitHub\\AdventCode2021\\Day9\\input.txt", String) # Read all the inputs

# Parse the inputs
inputs = replace(inputs,'\r'=>"")  # Sanitize inputs
inputs = split.(inputs,'\n') # Split by line
inputs = [split.(line,"") for line in inputs]
inputs = [parse.(Int64,line) for line in inputs if length(line) > 1]

# Define useful functions
# Find all adjacent elements of a matrix element
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

# Check if a point is the lowest in its neighborhood
function lowpoint(rownum, colnum, inputs)
    # Get all the adjacent locations
    adjacentLocs = getadjacents(rownum, colnum, length(inputs), length(inputs[1]))

    # Get the height of each adjacent location
    adjacents = [inputs[loc[1]][loc[2]] for loc in adjacentLocs]

    # If the current point is the lowest in the region then return true
    all(adjacents.> inputs[rownum][colnum])
end

# Find the basin for an input point
function findbasin(rownum, colnum, inputs)
    # Add the point to the basin
    basinLocs = [(rownum, colnum)]

    # For each location in the basin check if connected locations are in the basin
    for basinLoc in basinLocs
        # Find all the adjacent locations
        adjacentLocs = getadjacents(basinLoc[1], basinLoc[2], length(inputs), length(inputs[1]))

        # Check each adjacent location to see if it should be added to the basin
        for adjacent in adjacentLocs
            # Max height is 9, don't re-add locations
            if (inputs[adjacent[1]][adjacent[2]] < 9) && !in(adjacent, basinLocs)
                push!(basinLocs, adjacent)
            end
        end
    end
    return basinLocs
end

# Initialize the risk level and list of basins
riskLevel = 0
basins = []

# Go through each element in the input
for (rownum, row) in enumerate(inputs)
    for (colnum, ele) in enumerate(row)
        # Check if the location is a low point
        if lowpoint(rownum, colnum, inputs)
            # Add the low point to the risk level
            global riskLevel+= ele + 1

            # Add the basin for the low point to the basin list
            push!(basins, findbasin(rownum, colnum, inputs))
        end
    end
end

# Find the length of each basin and sort them in descending order
basinSizes = [length(x) for x in basins]
basinSizes = sort(basinSizes, rev = true)

# Display the total risk level
println("#1 result = ", riskLevel)

# Display the product of the sizes of the three biggest basins
println("#2 result = ", prod(basinSizes[1:3]))
