# Find the fuel needed to align all crabs
inputs = read("C:\\Users\\varunjos\\Documents\\GitHub\\AdventCode2021\\Day7\\input.txt", String) # Read all the inputs
inputs = replace(inputs,'\r'=>"")  # Sanitize inputs

# Find the start position for each crab
startPosn = split.(strip.(inputs), ',')
startPosn = [parse.(Int, startPosn[i]) for i in 1:length(startPosn)]
#println(startPosn)

# Loop through all possibilities
minX = minimum(startPosn)
maxX = maximum(startPosn)
fuelCost = zeros(Int, maxX - minX + 1)

for position in minX:maxX
	global fuelCost[position - minX + 1] = sum(abs.(startPosn.- position))
end

# Display the minimum fuel cost
println("#1 result = ", minimum(fuelCost))

# Change fuel calculation method
fuelCost = zeros(Int, maxX - minX + 1)

for position in minX:maxX
	positionChange = abs.(startPosn.- position)
	costForEachChange = 0.5*positionChange.*(positionChange.+1)
	global fuelCost[position - minX + 1] = sum(costForEachChange)
end

# Display the minimum fuel cost
println("#2 result = ", minimum(fuelCost))