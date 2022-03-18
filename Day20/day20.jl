# Image enhancement
inputs = read("C:\\Users\\varunjos\\Documents\\GitHub\\AdventCode2021\\Day20\\input.txt", String) # Read all the inputs
inputs = replace(inputs,'\r'=>"")                   # Sanitize inputs
inputs = split(inputs,"\n\n")

# Separate the enhancement algorithm and the input image
algorithm  = split(replace(inputs[1],'\n'=>""), "")
algorithm = replace(algorithm, "#" => true)
algorithm = replace(algorithm, "." => false)

inputImage = split.(split(inputs[2], '\n'),"")

# Turn the image into a dictionary
imageDict = Dict()
for (rowNum, colNum) in Iterators.product(1:length(inputImage), 1:length(inputImage[1]))
    imageDict[(rowNum, colNum)] = inputImage[rowNum][colNum] == "#"
end

# Support functions
# Pad the image with some .'s
function expandImage(imageDict, pixelVal)
    minX = minimum(x -> x[1], keys(imageDict))
    minY = minimum(x -> x[2], keys(imageDict))
    maxX = maximum(x -> x[1], keys(imageDict))
    maxY = maximum(x -> x[2], keys(imageDict))

    for pixel in Iterators.product(minX-1:maxX+1,minY-1:maxY+1)
        if !in(pixel, keys(imageDict))
            imageDict[pixel] = pixelVal
        end
    end

    # Return the imagedict
    return imageDict
end

# Run the enhancement function
function enhance(imageDict, algorithm, pixelVal = false)
    # Make an empty enhanced image
    enhancedImage = Dict()

    # Expand the image by padding
    imageDict = expandImage(imageDict, pixelVal)

    # Enhance the image
    for pixel in keys(imageDict)
        # Find the corresponding binary number
        binNum = 0

        # Go through all the adjacent pixels
        for shift in Iterators.product(-1:1:1, -1:1:1)
            newPixel = pixel .+ reverse(shift) # Product goes in column order, we want row order

            # If the adjacent position is in the dict, it must be bright
            binNum = binNum*2
            binNum += in(newPixel, keys(imageDict)) ? imageDict[newPixel] : pixelVal
        end

        # Find the corresponding binary number
        enhancedImage[pixel] = algorithm[binNum + 1]
    end

    # Do the outside pixels become bright or dark?
    outsidePixel = pixelVal ? algorithm[end] : algorithm[1]

    # Return the enhanced image
    return enhancedImage, outsidePixel
end

# For the first step just do a normal step
imageDict, outsideVal = enhance(imageDict, algorithm)

# For the rest of them, we need to consider the effect of the algorithm on outside points
numIter = 2
for _ in 1:(numIter - 1)
    global imageDict, outsideVal = enhance(imageDict, algorithm, outsideVal)
end

# Print the results
println("#1 result : ", sum(values(imageDict)))

numIter2 = 50
for _ in 1:(numIter2 - numIter)
    global imageDict, outsideVal = enhance(imageDict, algorithm, outsideVal)
end

println("#2 result : ", sum(values(imageDict)))
