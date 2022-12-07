/^\$ cd \// { path = "/" }
/^\$ cd \.\./ { path = gensub(/^[^\/]+\//, "", 1, path) }
/^\$ cd [^.\/]/ { path = $3 "/" path } # path is built in reverse
/^[0-9]/ { # file listing
    temp_path = path
    do {
	sizes[temp_path] += $1
	temp_path = gensub(/^[^\/]*\//, "", 1, temp_path)
    } while (temp_path != "")
}
END {
    to_free = 30000000 - (70000000 - sizes["/"])
    min = 70000000
    for (dir in sizes) { size = sizes[dir]
	if (size <= 100000) sum += size
	else if (size >= to_free && size < min) min = size
    }
    print sum"\n"min
}
