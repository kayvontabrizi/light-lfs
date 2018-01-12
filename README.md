# Light LFS

Light LFS is an extension that manages the duplicitous storage of large files in Git. It was modeled after [git-media](https://github.com/alebedev/git-media) and [Git LFS](https://git-lfs.github.com/).

Light LFS provides two distinct services:

1. A filter that feeds Git a hash of an added file. This allows git to track changes to the file, but impairs its ability to restore versions of that file.
2. Favoriting and syncing services, which can be used to maintain a local copy of filtered files.

## Configuration

Configure a clean filter, and optionally, a local directory to which large files should be synced.

	$ git config filter.light_lfs.clean /path/to/light_lfs/light_lfs_filter
	$ git config filter.light_lfs.smudge cat
	$ git config filter.light_lfs.require true

Specify which extensions should be managed via the the `.gitattributes` file.

	$ echo "*.mov filter=light_lfs binary" >> .gitattributes
	$ echo "*.jpg filter=light_lfs binary" >> .gitattributes

Staging files with these extensions will now apply the hash filter, preventing the accumulation of large amounts of redundant data in the `.git` directory.

_**Note:** It is crticial to understand that this filter prevents Git from usefully restoring or comparing filtered files (as with `git checkout --` or `git diff`). Please use this filter carefully._

### Sync Filtered Files to a Local Repository

Light LFS allows the syncing of tracked and filtered files to a local directory. This was originally intended for use as a favoriting system (one might imagine keeping a local copy of favorite photos from a storage-heavy remote repository of photos).

This syncing system employs MacOS Automator services to provide a context menu-based favoriting and syncing system.

Visual tagging of tracked or _favorited_ files requires the [Tag](https://github.com/jdberry/tag) utility. This can be easily installed via `brew install tag` or `sudo port install tag`.

To enable local directory syncing, specify a local path with `git config`:

	$ git config filter.light_lfs.localpath /path/to/local_directory

Now, copy Automator services to enable right click-based favoriting:

	$ cp /path/to/light_lfs/services/* /Users/<username>/Library/Services

The context menu should include three services:

- **Favorite (Light LFS):**
Stages (`git add`) the selected files and folders, and marks them for syncing.
- **Unfavorite (Light LFS):**
Unstages (`git rm --cached`) the selected files and folders, and unmarks them for syncing.
- **Sync (Light LFS):**
Downloads absent files and deletes extraneous ones. Execute on root folder to sync entire repository.

_**Note:** The local repository can be any directory. Importantly, any files not tracked **and filtered** in the remote repository **will be deleted**._

## Installation

    $ cd /path/to/light_lfs
    $ git clone https://github.com/kayvontabrizi/light-lfs.git

See [Configuration](#configuration) for set-up details.

## Attribution

Written by Kayvon Tabrizi. Feel free to use, modify, and attribute as desired.