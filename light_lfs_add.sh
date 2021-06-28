## this script should not be directly executed — it is intended to be run as an Automator service

# track number of subdirectories
MIN_DIRS=10000

# loop through input files and folders
for f in "$@"; do
    # extract directory and determine number of dirs
    DIR=$(dirname "$f")
    DIRS=$(grep -o "/" <<< "$DIR" | wc -l)

    # save most root directory
    if [ $DIRS -lt $MIN_DIRS ]; then
        SET_DIR=$DIR
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

# enable tag command
export PATH="/usr/local/bin/:$PATH"

# loop through input files and folders
for f in "$@"; do
    # git add and tag each file and folder
    git add "$f"
    tag -a Blue -R "$f"
done
