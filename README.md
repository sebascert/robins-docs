# Document Compiler

I still don't find LaTex pleasant to use, so I created this for simple document
generation utilities.

Document compiler compiles a bunch of markdown into a given target, supported by
[pandoc](https://pandoc.org/).

## Dependencies

Document Compiler requires [pandoc](https://pandoc.org/installing.html) and
[yq](https://github.com/mikefarah/yq/#install).

## How to use

Clone the repo:

```bash
your_doc=<your document>
git clone https://github.com/sebascert/doc-compiler.git "$your_doc"
cd "$your_doc"
git checkout --orphan doc
git commit -am "init"
```

Add your document contents to `src/` in markdown files, then compile with:

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

## Contributing

For bugs or requested features please contribute an issue, if you want to
contribute code or documentation open a PR.
