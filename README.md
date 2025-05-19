# Document Compiler

I still don't find LaTex pleasant to use, so I created this for simple document
generation utilities.

Document Compiler compiles a bunch of markdown into a given target, supported by
[pandoc](https://pandoc.org/).

## Dependencies

Document Compiler requires [pandoc](https://pandoc.org/installing.html) and
[yq](https://github.com/mikefarah/yq/#install).

## How to use

There are several ways to use this project depending on your
[version control needs](#version-control-workflows). After choosing a version
control workflow, add your document contents to `src/` in markdown files, then
compile your document with:

```bash
./compile.sh
```

The output document will be in `out/<configured-name>`, which defaults to
`out/doc.pdf`.

## Config

> The default configuration is mostly to my taste.

Pandoc configuration is stored in `metadata.yaml`, read the official docs on
[pandoc metadata](https://pandoc.org/MANUAL.html#metadata-variables) for the
available options. Change the cover contents in `src/cover.md`, read the
[official docs](https://pandoc.org/MANUAL.html#extension-pandoc_title_block) for
the format and options.

> The table of contents is configured in `metadata.yaml`

Document Compiler configuration is stored in `config.yaml`, the available
options are as follows:

```yaml
output_filename: doc.pdf

cover_page: true

include_all_sources: true
# defines the rendering order for the given sources
# if include_all_sources is set to false, only include this sources
# provide sources relative to src/ i.e. source.md, not src/source.md
sources:
#- source1
#- source2
#- ...
```

## Sources Formatting

[Prettier](https://prettier.io/) is used for formatting the source files, to do
so run:

> The cover page is excluded as it uses non standard markdown syntax.

```bash
find src/ -name "*.md" ! -path src/cover.md -exec prettier --write {} \;
```

## Version Control Workflows

### GitHub Fork

The simplest way to use Document Compiler with version control is to
[fork](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/about-forks)
this repo, this gives you an identical copy of this repo, under your GitHub
account.

### Within a Git Repo

A common scenario is wanting to track the documentation for a project. The
straightforward approach is to discard the history of this repo, and just commit
the project files into your project history. However, this becomes problematic
when you need to upgrade to a different version of Document Compiler.

A better solution is to use `git submodules`, with them you can manage the
history of both your project and doc-compiler simultaneously by
[forking](#github-fork) this repo and then using it as a submodule of your
project.

> If you're not familiar with them, I highly recommend reading this
> [guide](https://git-scm.com/book/en/v2/Git-Tools-Submodules).

### Discard Version Control

If you wish to discard version control (discouraged), simply download the repo
contents and remove the git database:

```bash
git clone --depth=1 "https://github.com/sebascert/doc-compiler.git"
rm -rf ./doc-compiler/.git
```

## Contributing

For bugs or requested features please contribute an issue, if you want to
contribute code or documentation open a PR.
