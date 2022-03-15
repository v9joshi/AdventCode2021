# Some Euler integration
inputs = read("C:\\Users\\varunjos\\Documents\\GitHub\\AdventCode2021\\Day17\\input.txt", String) # Read all the inputs
inputs = replace(inputs,'\r'=>"")                   # Sanitize inputs
inputs = replace(inputs,'\n'=>"")                   # Sanitize inputs

# Parse the input
inputs = split(inputs, "x=")
inputs = split(inputs[2],", y=")

xInputs = inputs[1]
xLim = parse.(Int, split(xInputs,".."))
yInputs = inputs[2]
yLim = parse.(Int, split(yInputs,".."))

# xLim = [281, 311]
# yLim = [-74, -54]

# Make an empty list to store all the valid positions
validStart = []

# Check all possible values
for yVal in yLim[1]:(-yLim[1])
    for xVal in 1:xLim[2]
        # Start at (0,0)
        xPos = 0
        yPos = 0

        # Set the speed
        xSpeed = xVal
        ySpeed = yVal

        # Keep looping till you either hit the target or go beyond it
        while true
            # Step forward by 1 step
            xPos = xPos + xSpeed
            yPos = yPos + ySpeed

            # Apply drag
            if xSpeed > 0
                xSpeed = xSpeed - 1
            end

            # Apply gravity
            ySpeed = ySpeed - 1

            # Check if you've hit the target area
            if (xPos >= xLim[1]) && (xPos <= xLim[2]) && (yPos >= yLim[1]) && (yPos <= yLim[2])
                push!(validStart, (xVal, yVal))
                break

            # Check if you've reached beyond the target
            elseif xPos > xLim[2] || yPos < yLim[1]
                break
            end
        end
    end
end

# What's the answer?
println("#1 answer ", Int((- yLim[1])*(-1 - yLim[1])/2))
println("#2 answer ", length(validStart))
