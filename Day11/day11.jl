# Flashing octopuses
# Read input file
inputs = read("C:\\Users\\varunjos\\Documents\\GitHub\\AdventCode2021\\Day11\\input.txt", String) # Read all the inputs

# Parse the inputs
inputs = replace(inputs,'\r'=>"")  # Sanitize inputs
inputs = split.(inputs,'\n') # Split by line
inputs = [split.(line,"") for line in inputs]
inputs = [parse.(Int64, line) for line in inputs]

# Define useful functions
# Find all adjacent elements of a matrix element
function getadjacents(rownum, colnum, maxrow, maxcol)
    # Make an empty list of elements
    elementList = []
    # Move in each direction
    for direction in Iterators.product(-1:1, -1:1)
        # Do not at the element itself
        if !(direction == (0,0))
            # Find the adjacent point corresponding to the direction
            newPoint = (rownum, colnum) .+ direction
            # Check if the new point is legal, if yes add it to the list
            if (newPoint[1] > 0 && newPoint[2] > 0) && (newPoint[1] <= maxrow && newPoint[2] <= maxcol)
                push!(elementList, newPoint)
            end
        end
    end
    # Return the adjacent elements
    return elementList
end

# Make an adjacency dictionary
adjacencyDict = Dict()

# For each element in the matrix get all the adjacent elements
for rownum in 1:length(inputs)
    for colnum in 1:length(inputs[rownum])
        global adjacencyDict[(rownum, colnum)] = getadjacents(rownum, colnum, length(inputs), length(inputs[rownum]))
    end
end

# Initialize number of flashes
numFlash100 = 0
currLoop = 0

# Loop through 100 iterations
while true
    # Increment the loop
    global currLoop += 1
    # Initialize the list of flashed octopi
    flashed = []

    # Start by adding one energy to each octopus
    global inputs = [row .+ 1 for row in inputs]

    # Keep flashing till no new octopi flash this loop
    while true
        # Make a list of new octopi that flash during this loop
        newFlash = []

        # Go through all the octopi
        for key in keys(adjacencyDict)
            if inputs[key[1]][key[2]] > 9 && !in(key, flashed)
                push!(newFlash, key)
                # Add energy to each of the adjacent points if they haven't been flashed
                for adjacentPoint in adjacencyDict[key]
                    if !in(adjacentPoint, flashed)
                        global inputs[adjacentPoint[1]][adjacentPoint[2]] += 1
                    end
                end
            end
        end

        # Add the new flashes to the flashed list
        flashed = vcat(flashed, newFlash)

        # End the loop if nothing new flashes
        if length(newFlash) == 0
            break
        end
    end

    # Reset the flashed octopi to 0 energy
    for point in flashed
        global inputs[point[1]][point[2]] = 0
    end

    # Add the number of flashes to the total till 100 loops
    if currLoop <= 100
        global numFlash100 += length(flashed)
    end

    # Check if all the octopuses are synced, i.e. they all flash at the same time
    if length(flashed) == length(inputs)*length(inputs[1])
        # End the loops if the octopuses are synced
        break
    end
end

# Report the number of flashes in total
println("#1 result = ", numFlash100)
println("#2 result = ", currLoop)
