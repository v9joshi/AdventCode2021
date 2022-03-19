# Memory trickery for the most part
inputs = read("C:\\Users\\varunjos\\Documents\\GitHub\\AdventCode2021\\Day22\\test_input.txt", String) # Read all the inputs
inputs = replace(inputs,'\r'=>"")                   # Sanitize inputs
inputs = split(inputs,"\n")

# Support functions
# Find the part of input1 that intersects with input2
function findIntersection(input1, input2)
    a = (input1[1] <= input2[1] <= input1[end])
    b = (input1[1] <= input2[end] <= input1[end])
    c = (input2[1] <= input1[1] <= input2[end])

    # Input2 lies entirely inside input1
    if a && b
        return input2
    # Left half of input2 overlaps with right half of input1
    elseif a
        return input2[1]:input1[end]
    # Right half of input2 overlaps with left half of input1
    elseif b
        return input1[1]:input2[end]
    # Input1 lies inside of input2
    elseif c
        return input1
    # The inputs are disjoint
    else
        return []
    end
end

# Find the part of input1 that doesn't intersect with input2
function findDiff(input1, input2)
    a = (input1[1] < input2[1] <= input1[end])
    b = (input1[1] <= input2[end] < input1[end])
    c = (input2[1] <= input1[1] <= input2[end])

    # Input2 lies entirely inside input1
    if a && b
        return [input1[1]:input2[1]-1, input2[end]+1:input1[end]]
    # Left half of input2 overlaps with right half of input1
    elseif a
        return [input1[1]:input2[1]-1]
    # Right half of input2 overlaps with left half of input1
    elseif b
        return [input2[end]+1:input1[end]]
    # Input1 lies inside of input2
    elseif c
        return []
    # The inputs are disjoint
    else
        return [input1]
    end
end

# Turn some cubes off
function turnCubesOff(onCubes, offCubes)
    # println("Curr Cubes: ", onCubes)
    # println("Turning cubes off at: ", offCubes)
    # Make a new set of cubes
    resultCubes = []

    # Go through every cube that's already on
    for cuboid in onCubes
        # Do these two sets intersect?
        intX = findIntersection(cuboid[1], offCubes[1])
        intY = findIntersection(cuboid[2], offCubes[2])
        intZ = findIntersection(cuboid[3], offCubes[3])

        # If they intersect, find the non-intersecting regions
        if !isempty(intX) && !isempty(intY) && !isempty(intZ)
            println(cuboid," intersects ", offCubes, " at ", [intX, intY, intZ])

            diffX = findDiff(cuboid[1], intX)
            diffY = findDiff(cuboid[2], intY)
            diffZ = findDiff(cuboid[3], intZ)

            # println("Non-overlapping region is: ")

            # Add the non-intersection regions to the cube set
            for xBlock in diffX
                println([xBlock, cuboid[2], cuboid[3]])
                push!(resultCubes, [xBlock, cuboid[2], cuboid[3]])
            end

            for yBlock in diffY
                println([intX, yBlock, cuboid[3]])
                push!(resultCubes, [intX, yBlock, cuboid[3]])
            end

            for zBlock in diffZ
                println([intX, intY, zBlock])
                push!(resultCubes, [intX, intY, zBlock])
            end

        # If they don't intersect, keep this cuboid intact
        else
            # println(cuboid," doesn't intersect ", offCubes)
            push!(resultCubes, cuboid)
        end
    end

    # println("Result of off Step: ", resultCubes)
    # Return the result
    return resultCubes
end

# Turn some cubes on
function turnCubesOn(onCubes, newCubes)
    println("Turning cubes on at: ", newCubes)
    # Make a new set of cubes
    resultCubes = []

    # Iterate through all the cubes that are already on
    for cuboid in onCubes
        # Find where these cubes intersect with the new set
        intX = findIntersection(x, cuboid[1])
        intY = findIntersection(y, cuboid[2])
        intZ = findIntersection(z, cuboid[3])

        if !isempty(intX) && !isempty(intY) && !isempty(intZ)
            # If there are any intersections, turn those cubes off
            println(cuboid, " intersects at ", [intX, intY, intZ])
            returnedCubes = turnCubesOff([cuboid], [intX, intY, intZ])

            for cube in returnedCubes
                push!(resultCubes, cube)
            end
        else
            push!(resultCubes, cuboid)
        end
    end

    # Add the new cube to the results
    push!(resultCubes, newCubes)

    # println("Result of on Step: ", resultCubes)
    return resultCubes
end

# Now to act on these inputs for initializtion
onCubes = []
legalPoints = -50:50 #Inf
limiter = true
for inputLine in inputs
    println(inputLine)
    action, locationString = split(inputLine," ")
    locationString = replace(locationString,".." => ':')
    locationString = split(locationString,',')

    expressions = Meta.parse.(locationString)
    x, y, z = eval.(expressions)

    # Limit the list of cubes to -50:50 in each dimension
    if limiter
        x = findIntersection(legalPoints, x)
        y = findIntersection(legalPoints, y)
        z = findIntersection(legalPoints, z)
    end

    if isempty(x) || isempty(y) || isempty(z)
        continue
    end

    # Perform the action on each cube
    if isempty(onCubes) && action == "on"
        push!(onCubes, [x,y,z])
    elseif action == "on"
        global onCubes = turnCubesOn(onCubes, [x,y,z])
    elseif action == "off"
        global onCubes = turnCubesOff(onCubes, [x,y,z])
    end
end

# Measure the on cubes
totalOnCubes = 0
for cubeSet in onCubes
    currOnCubes = length(cubeSet[1])*length(cubeSet[2])*length(cubeSet[3])
    println(cubeSet, " contains ", currOnCubes)
    global totalOnCubes += currOnCubes
end

# Answer 1
println("#1 answer : ", totalOnCubes)
