# 52s
BEGIN{
    # note that robots cost at most 2 resource types (comma in RS isn't needed)
    RS = "[:.,]|costs|and" ; SUBSEP=","
    types["ore"] ; types["clay"] ; types["obsidian"] ; types["geode"]

    # only the top max_queue paths are explored each minute
    # the metric is geode + geode robots * time remaining
    # works on my input with 50k, doesn't work with 40k
    max_queue = 50000
}
/Blueprint/ { blueprint = $2 ; n_blueprints++ ; next }
/robot/ { robot = $2 ; next }
/ore|clay|obsidian/ { cost[blueprint,robot,$2] = $1 ; next}
END {
    FS = ","
    # initial state of resources and robots (see search func)
    id = 0 SUBSEP 1 SUBSEP			\
	0 SUBSEP 0 SUBSEP			\
	0 SUBSEP 0 SUBSEP			\
	0 SUBSEP 0
    score = 1
    for (i = 1 ; i <= 3 ; i++) {
	q[id] = 0
	blueprint = i
	score *= search(32, q)
    }
    print score
}

function max(a, b) { return a > b ? a : b }

function search(time, queue,    next_queue, resources, robots, type, robot, resource, can_build, n_build, id, maxval, temp_queue, i, need_to_build) {
    for (id in queue) {
	$0 = id
	resources["ore"] = $1 ; robots["ore"] = $2
	resources["clay"] = $3 ; robots["clay"] = $4
	resources["obsidian"] = $5 ; robots["obsidian"] = $6
	resources["geode"] = $7 ; robots["geode"] = $8
	if (time == 1)
	    maxval = max(resources["geode"] + robots["geode"], maxval)
	else{
	    # acquire new resources
	    for (type in types) resources[type] += robots[type]
	    # build a new robot
	    n_build = 0
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
		for (resource in types) {
		    if (resources[resource] - robots[resource] < cost[blueprint,robot,resource]){
			can_build = 0
			break
		    }
		}
		if (can_build) {
		    n_build++
		    robots[robot]++
		    for (resource in resources)
			resources[resource] -= cost[blueprint,robot,resource]
		    id = resources["ore"] SUBSEP robots["ore"] SUBSEP resources["clay"] SUBSEP robots["clay"] SUBSEP resources["obsidian"] SUBSEP robots["obsidian"] SUBSEP resources["geode"] SUBSEP robots["geode"]
		    temp_queue[id] = resources["geode"] + (time-1) * robots["geode"]
		    for (resource in resources)
			resources[resource] += cost[blueprint,robot,resource]
		    robots[robot]--
		}
	    }
	    if (n_build < length(types)){ # don't wait if everything can be built
		id = resources["ore"] SUBSEP robots["ore"] SUBSEP resources["clay"] SUBSEP robots["clay"] SUBSEP resources["obsidian"] SUBSEP robots["obsidian"] SUBSEP resources["geode"] SUBSEP robots["geode"]
		temp_queue[id] = resources["geode"] + (time-1) * robots["geode"]
	    }
	}
	
    }
    delete queue
    delete resources
    delete robots
    
    if (time == 1) return maxval
    
    if (length(temp_queue) > max_queue) {
	asorti(temp_queue, temp_queue, "my_compare")
	for (i = 1 ; i <= length(temp_queue) && i <= max_queue ; i++)
	    next_queue[temp_queue[i]]
	delete temp_queue
	return search(time - 1, next_queue)
    } else {
	return search(time-1, temp_queue)
    }
}

function my_compare(i1, v1, i2, v2) { # sort keys by value with asorti in reverse order
    return v2-v1
}
