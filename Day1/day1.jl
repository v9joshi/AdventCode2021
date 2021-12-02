using DelimitedFiles

numbers = readdlm("C:\\Users\\varunjos\\Documents\\GitHub\\AdventCode2021\\Day1\\input.txt")
numvec = vec(numbers)


# Part 1
numdiff = diff(numvec)
p = x-> (x>0)
numInc = count(p, numdiff)
println("#1 result = ", numInc)

# Part 2
moving_sum(vs,n) = [sum(@view vs[i:(i+n-1)]) for i in 1:(length(vs)-(n-1))]
sumvec = moving_sum(numvec,3)
numdiff = diff(sumvec)
p = x-> (x>0)
numInc = count(p, numdiff)

println("#2 result = ", numInc)