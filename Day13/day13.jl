# Folding paper (some array stuff)
inputs = read("C:\\Users\\varunjos\\Documents\\GitHub\\AdventCode2021\\Day13\\input.txt", String) # Read all the inputs

# Parse the inputs
inputs = replace(inputs,'\r'=>"")  # Sanitize inputs
inputs = split.(inputs,'\n') # Split by line

dotLocations  = []
foldLocations = []

while !(inputs[1] == "")
    currLocation = split(popfirst!(inputs),",")
    currLocation = parse.(Int64, currLocation)
    push!(dotLocations, currLocation)
end

# Drop the empty line
foldInputs = inputs[2:end]
foldInputs = split.(foldInputs," ")
foldInputs = [split.(val[3],"=") for val in foldInputs]
foldLocations = [(input[1], parse(Int64, input[2])) for input in foldInputs]

# Make the first fold
for (foldNum, fold) in enumerate(foldLocations)
    # Make a list of points to add to the new dot list
    addList = []
    # Make a list of points to remove from the old list of dots
    removeList = []

    # Check if it's a vertical or horizontal fold
    if fold[1] == "y"
        # Examine each dot
        for dot in dotLocations
            # If dot is below the fold then remove it and add a new dot in
            # the right location
            if dot[2] > fold[2]
                push!(removeList, dot)
                push!(addList, [dot[1], 2*fold[2] - dot[2]])
            end
        end
    elseif fold[1] == "x"
        # Examine each dot
        for dot in dotLocations
            # If dot is to the right of the fold then remove it and add a new
            # dot in the correct location
            if dot[1] > fold[2]
                push!(removeList, dot)
                push!(addList, [2*fold[2] - dot[1], dot[2]])
            end
        end
    end

    # Remove all the dots in the remove list
    global dotLocations = filter!(dot -> !in(dot, removeList), dotLocations)

    # Add all the dots in the add list and make the list unique
    global dotLocations = unique(vcat(dotLocations, addList))

    # What's the number of dots after the first fold?
    if foldNum == 1
        println("Answer #1 = ", length(dotLocations))
    end
end

# Make the final image
# Find the number of rows and columns in the image
maxX = maximum([dot[1] for dot in dotLocations])
maxY = maximum([dot[2] for dot in dotLocations])

for row in 0:maxY
    rowString = []
    for col in 0:maxX
        # If the current location is in the list of dots put a #
        if in([col, row], dotLocations)
            push!(rowString, "#")
        # Otherwise put a "."
        else
            push!(rowString, ".")
        end
    end
    # Print this row
    println(join(rowString))
end
