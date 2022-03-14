# Parsing Hex codes
inputs = read("C:\\Users\\varunjos\\Documents\\GitHub\\AdventCode2021\\Day16\\input.txt", String) # Read all the inputs
inputs = replace(inputs,'\r'=>"")                   # Sanitize inputs
inputs = replace(inputs,'\n'=>"")                   # Sanitize inputs

# Convert input from hex to bits
bitInput = join(bitstring.(hex2bytes(inputs)))

# Parse the bits
function parseBits(bitInput, readLoc, versionSum)
    # Read the packet version
    packetVersion = parse(Int, bitInput[readLoc:readLoc+2], base = 2)
    readLoc = readLoc + 3
    versionSum = versionSum + packetVersion

    # Read the packet type
    packetType = parse(Int, bitInput[readLoc:readLoc+2], base = 2)
    readLoc = readLoc + 3

    if packetType == 4 # Packet is a literal
        literalBits = []
        # Keep reading bits till the last block
        while true
            println("literal detected ", packetVersion)
            # Read the bits
            bitValue = bitInput[readLoc:readLoc + 4]
            readLoc = readLoc + 5
            push!(literalBits, bitValue[2:5])

            # Check if this block is the final block
            if bitValue[1] == '0'
                break
            end
        end
        # Convert the bits into a number
        literalBits = join(literalBits)
        outputVal =  parse(Int, literalBits, base = 2)

    else # Packet is an operator
        println("operator detected ", packetVersion)
        literalVal = []
        lengthID = bitInput[readLoc]
        readLoc = readLoc + 1

        # Check the length id
        if lengthID == '0'
            # Read 15 bits to find the number of bits in all subpacket
            lengthBits = bitInput[readLoc:readLoc + 14]
            readLoc = readLoc + 15
            lengthVal = parse(Int, lengthBits, base = 2)
            oldLoc = readLoc
            println("length ID 0 ", lengthVal, " bits")

            # Read all the subpackets till the bit count matches length
            while (readLoc - oldLoc) < lengthVal
                readLoc, versionSum, outputVal = parseBits(bitInput, readLoc, versionSum)
                push!(literalVal, outputVal)
            end
        else
            # Read 11 bits to find the number of sub-packets
            lengthBits = bitInput[readLoc:readLoc + 10]
            readLoc = readLoc + 11
            lengthVal = parse(Int, lengthBits, base = 2)
            println("length ID 1 ", lengthVal, " sub-packets")

            # Read all the sub-packets
            for packetNum in 1:lengthVal
                readLoc, versionSum, outputVal = parseBits(bitInput, readLoc, versionSum)
                push!(literalVal, outputVal)
            end
        end

        # Perform the requested operation on the inputs
        outputVal = getOutput(packetType, literalVal)
    end

    # Return all required values
    return readLoc, versionSum, outputVal
end

# Perform the requested operation
function getOutput(packetType, literalVal)
    if packetType == 0
        outputVal = sum(literalVal)
    elseif packetType == 1
        outputVal = prod(literalVal)
    elseif packetType == 2
        outputVal = minimum(literalVal)
    elseif packetType == 3
        outputVal = maximum(literalVal)
    elseif packetType == 5
        outputVal = Int(literalVal[1] > literalVal[2])
    elseif packetType == 6
        outputVal = Int(literalVal[1] < literalVal[2])
    elseif packetType == 7
        outputVal = Int(literalVal[1] == literalVal[2])
    end

    # Return the result
    return outputVal
end

# Determine the result of the input
readLoc, versionSum, outputVal = parseBits(bitInput,1, 0)

# Print out the answers
println("#1 answer = ", versionSum)
println("#2 answer = ", outputVal)
