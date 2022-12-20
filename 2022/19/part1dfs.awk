# 5m18s
BEGIN{
    # note that robots cost at most 2 resource types (comma in RS isn't needed)
    RS = "[:.,]|costs|and" ; SUBSEP=","
    types["ore"] ; types["clay"] ; types["obsidian"] ; types["geode"]
}
/Blueprint/ { blueprint = $2 ; n_blueprints++ ; next }
/robot/ { robot = $2 ; next }
/ore|clay|obsidian/ { cost[blueprint,robot,$2] = $1 ; next}
END {
    res["ore"] = 0 ; res["clay"] = 0 ; res["obsidian"] = 0 ; res["geode"] = 0
    rbts["ore"] = 1 ; rbts["clay"] = 0 ; rbts["obsidian"] = 0 ; rbts["geode"] = 0
    for (i = 1 ; i <= n_blueprints ; i++) {
	blueprint = i
	score += i * search(res, rbts, 24)
    }
    print score
}

function max(a, b) { return a > b ? a : b }

function search(resources, robots, time,    id, type, robot, resource, can_build, n_build, need_to_build, new_resources, new_robots, maxval) {
    if (time == 1) return resources["geode"] + robots["geode"]

    # memoization
    id = blueprint SUBSEP time
    for (type in types)	id = id SUBSEP resources[type] SUBSEP robots[type]
    if (id in memo) return memo[id]
    
    # acquire new resources
    # these are acquired during this minute, so can't be used to build yet
    for (type in types) {
	new_resources[type] += resources[type] + robots[type]
	new_robots[type] = robots[type]
    }

    # build a new robot
    n_build = 0 # number of robot types that can be built
    for (robot in types) {
	# because of the 1 robot/minute limitation
	# don't need to build more than the max cost of that resource
	if (robot != "geode"){ # always need to build more geode robots
	    need_to_build = 0
	    for (type in types) # robot here is the resource needed to build type
		if(cost[blueprint,type,robot] > robots[robot]){
		    need_to_build=1
		    break
		}
	    if (!need_to_build) continue
	}
	
	can_build = 1
	for (resource in types)
	    if (resources[resource] < cost[blueprint,robot,resource]){
		can_build = 0
		break
	    }
	if (can_build) {
	    n_build++
	    new_robots[robot]++
	    for (resource in new_resources)
		new_resources[resource] -= cost[blueprint,robot,resource]
	    maxval = max(maxval, search(new_resources, new_robots, time-1))
	    for (resource in new_resources)
		new_resources[resource] += cost[blueprint,robot,resource]
	    new_robots[robot]--
	}
    }
    # if can build every type of robot, no need to wait for resources
    if (n_build < length(types)) # don't build (wait for more resources)
	maxval = max(maxval, search(new_resources, new_robots, time-1))

    delete new_resources
    delete new_robots

    memo[id] = maxval
    return maxval
}
