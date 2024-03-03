/*
	begin with your stack of surfaces. index 0 is the contents,
	index 1 and 2 are ping and pong
*/
stack = kawase_single_filter_create_stack();

/*
	then create your list of distance values. for smaller content surfaces
	a set of 1, 1, 2, 3 is fine and nice. for bigger content surfaces a set
	of 1, 2, 3, 4, 4, 5, 6, 7 is best. you can play with this but non integer
	values and negative values will break the blur. an odd number of distances
	will also break this.
*/
distancelist = [
	[ 0, 0 ],
	[ 0, 0, 0, 0 ],
	[ 0, 0, 0, 0, 0, 0 ],
	[ 0, 1 ],
	[ 0, 0, 1, 1, 2, 2 ],
	[ 1, 2, 3, 4, 4, 5, 6, 7 ]
]
distancenames = [
	"small standard",
	"medium standard",
	"large standard",
	"small smudge",
	"medium smudge",
	"large smudge"
]
distanceindex = 0;