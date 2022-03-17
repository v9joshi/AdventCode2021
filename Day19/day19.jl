# Rotation matrices
inputs = read("C:\\Users\\varunjos\\Documents\\GitHub\\AdventCode2021\\Day19\\input.txt", String) # Read all the inputs
inputs = replace(inputs,'\r'=>"")                   # Sanitize inputs
inputs = split(inputs,'\n')

# Parse these inputs
scannerNum  = -1
beaconDict  = Dict()

for inputline in inputs
    # If the word scanner is in the line, make a new scanner
    if !isnothing(findfirst("scanner", inputline))
        global scannerNum +=1
        global beaconDict[scannerNum] = Set()

    # Otherwise if the line has some text on it, it must be a beacon location
    elseif length(inputline) > 0
        line = split(inputline,',')
        line = parse.(Int, line)
        push!(beaconDict[scannerNum], line)
    end
end

# Make all the transformation matrices
transformationDict = Dict()
transformNum = 0

# Basic 2D rotations
rots2D = [[1, 0, 0, 1], [0, -1, 1, 0],[-1, 0, 0, -1], [0, 1, -1, 0]]

# The z-direction could be any of global x,y or z
for zRow in [1,2,3]
    # z-direction can also be flipped
    for zSign in [1,-1]
        # Make the transformation matrix for this scanner orientation
        for rot in rots2D
            # Increase the transform count
            global transformNum += 1

            # Find the rows for x and y elements
            xRow = mod(zRow, 3) + 1
            yRow = mod(zRow + 1, 3) + 1

            # Start with an empty matrix
            transMat = zeros(3,3)

            # Change the elements
            transMat[zRow, 3] = zSign
            transMat[xRow, 1] = rot[1]
            transMat[xRow, 2] = rot[2]
            transMat[yRow, 1] = rot[3]*zSign
            transMat[yRow, 2] = rot[4]*zSign

            # Store the transform
            global transformationDict[transformNum] = transMat
        end
    end
end

# Support functions
function findTranslation(vectorSet1, vectorSet2)
    # Take every pair of vectors from the set except the last 11
    # because if only 11 are left to match, then no match will succeed
    for (vector1, vector2) in Iterators.product(vectorSet1, collect(vectorSet2)[1:end-11])
        #println("testing pair: ", vector1, vector2)
        # Find the translation from one vector to the other
        translationVec = vector2 - vector1

        # Make a new set of vectors by translating all the vectors in set2 using
        # the same translation
        testSet = Set()
        for vector2 in vectorSet2
            push!(testSet, vector2 .- translationVec)
        end

        # See if this new set intersects with set 1
        matchCount = length(intersect(testSet, vectorSet1))

        # If more 12 or more vectors match, we have found the correct translation
        if matchCount >= 12
            println("match found")
            return translationVec
        end
    end
    # If no match is found return nothing
    return nothing
end

# Make a dictionary with all scanner rotations and translations relative to 0
scannerDict = Dict()
scannerDict[0] = [[0,0,0], 17] # No translation and no rotation
testingSet = [beaconDict[0]]
testNum = 0
rotatedBeaconsDict = Dict()

# Go through all the scanner pairs and find scanners with overlapping beacons
while !(keys(scannerDict) == keys(beaconDict))
    global testNum = testNum + 1
    newBeacons = Set()
    for scanner2 in setdiff(keys(beaconDict), keys(scannerDict))
        println("testing scanner ", scanner2, " test num ", testNum, " of ", length(keys(beaconDict)))

        # Test all possible rotations
        for rotNum in keys(transformationDict)
            # println("Testing rot number ", rotNum)
            if (scanner2, rotNum) in keys(rotatedBeaconsDict)
                rotatedBeacons = rotatedBeaconsDict[(scanner2, rotNum)]
            else
                rotatedBeacons = Set()
                for beacon in beaconDict[scanner2]
                    push!(rotatedBeacons, transformationDict[rotNum]*beacon)
                end
                rotatedBeaconsDict[(scanner2, rotNum)] = rotatedBeacons
            end

            # Find the translation corresponding to this rotation
            translationValue = findTranslation(testingSet[testNum], rotatedBeacons)

            # If a translation is found, store the new beacons
            if !isnothing(translationValue)
                # Add this new scanner to the scanner dict
                scannerDict[scanner2] =[translationValue, rotNum]

                # Translate all the rotated beacons
                for beacon in rotatedBeacons
                    push!(newBeacons, beacon - translationValue)
                end

                # Add this new set of beacons to the testing set
                push!(testingSet, newBeacons)

                # Stop testing rotations for this scanner
                break
            end
        end
    end

    # Expand the global beacon location dictionary
    global beaconDict[0] = union(beaconDict[0], newBeacons)
    println("Number of matches left: ", length(keys(beaconDict)) - length(keys(scannerDict)))
end

# Find the manhattan distance between each pair of scanners
scannerDist = []
for scanner1 in keys(scannerDict)
    for scanner2 in keys(scannerDict)
        # No need to test a scanner with itself
        if scanner1 == scanner2
            continue
        end

        # Find the global position of the scanners
        loc1 = scannerDict[scanner1][1]
        loc2 = scannerDict[scanner2][1]

        # Measure and store the manhattan distance
        distanceVal = sum(abs.(loc1 - loc2))
        push!(scannerDist, ((scanner1, scanner2), distanceVal))
    end
end
# Check the final number of beacons
println("#1 answer: ", length(beaconDict[0]))
println("#2 answer: ", maximum(x -> x[2], scannerDist))
