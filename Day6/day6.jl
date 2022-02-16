# Find the number of lamprays after N days
inputs = read("C:\\Users\\varunjos\\Documents\\GitHub\\AdventCode2021\\Day6\\input.txt", String) # Read all the inputs
inputs = replace(inputs,'\r'=>"")  # Sanitize inputs

# Find the start times for each lampray
startTimes = split.(strip.(inputs), ',')
startTimes = [parse.(Int, startTimes[i]) for i in 1:length(startTimes)]
println(startTimes)

# Loop through days
lamprayList = startTimes
maxDays = 80

for days in 1:maxDays
	# Set the current number of days for each lampray
	currLamprays = lamprayList
	#println(currLamprays)
	
	# Add new lamprays for each current lampray at 0 days till spawn
	newLamprays = [9 for x in currLamprays if x==0]
	append!(currLamprays, newLamprays)

	# For each spawning lampray reset the spawn counter
	currLamprays[currLamprays .== 0] .= 7
	
	# Advance by a day
	currLamprays = [x - 1 for x in currLamprays]
	
	# Store the result
	global lamprayList = currLamprays
end

# Display the number of lamprays in the ocean after 80 days
println("#1 result = ", length(lamprayList))

# Part 1 uses too much memory to be useful for 256 day calculations
numRays = [count(x-> x==i, startTimes) for i in 0:8]
maxDays = 256

# Loop through the days
for days in 1:maxDays
	newRays = popfirst!(numRays)
	append!(numRays, newRays)
	global numRays[7]+= newRays
end

# Display the number of lamprays in the ocean after 256 days
println("#2 result = ", sum(numRays))
