# backup.fish

Quickly backs up files with a lot of flexible options.

## Install

via [oh-my-fish](https://github.com/oh-my-fish/oh-my-fish):

```fish
omf install backup.fish

```

via [fisher](https://github.com/jorgebucaran/fisher):

```fish
fisher install aidenlangley/backup.fish
```

## Usage

```fish
backup -f/--format_datetime -%s [ARGS]...
    Format the datetime to your liking - %s for epoch (1790564782), see man date for more.
backup -d/--dest archive [ARGS]...
    Specify a backup directory with -d/--dest.
backup -D/--mkdir archive [ARGS]...
    Same as -d/--dest, but have it created automatically with -D/--makedir.
backup -s/--suffix '.bak' [ARGS]...
    Completely replace the suffix, datetime and file extension with one option.
```
