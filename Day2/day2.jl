using DelimitedFiles

commands = readdlm("C:\\Users\\varunjos\\Documents\\GitHub\\AdventCode2021\\Day2\\input.txt")

# part 1
case_sum(vs, case_val) = sum(@view vs[i,2] for i in 1:size(vs,1) if (cmp(vs[i,1], case_val)==0))
forward = case_sum(commands,"forward")
depth = case_sum(commands,"down") - case_sum(commands,"up")

result = forward[1]*depth[1]
println("#1 final pos = ", result)

# part 2
aim = 0
forward = 0
depth = 0
for i in 1:size(commands,1)
    if (cmp(commands[i,1],"forward") == 0)
        global forward = forward + commands[i,2]
        global depth = depth + aim*commands[i,2]
    elseif (cmp(commands[i,1],"up") == 0)
        global aim = aim  - commands[i,2]
    elseif (cmp(commands[i,1],"down")==0)
        global aim = aim  + commands[i,2]
    end
end

result = forward*depth
println("#2 final pos = ", result)
