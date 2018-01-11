# track number of subdirectories
MIN_DIRS=10000

# loop through input directories
for f in "$@"; do
	# determine number of dirs
	DIRS=$(grep -o "/" <<< "$f" | wc -l)

	# save most root directory
	if [ $DIRS -lt $MIN_DIRS ]; then
		SET_DIR="$f"
		MIN_DIRS=$DIRS
	fi
done

# set current directory to the most root file directory
cd "$SET_DIR"

# exit if current directory is not git repository
if ! ( [ -d .git ] || git rev-parse --git-dir > /dev/null 2>&1 ); then
	exit 0
fi

# exit if current directory has not configured Light LFS
if [ -z $(git config filter.light_lfs.localpath) ]; then exit 0; fi;

# loop through input folders
for f in "$@"; do
	# execute light_lfs_sync
	/Users/ktabrizi/Documents/Applications/LightLFS/light_lfs_sync "$f"
done