# Releasing NCAlgebra

Maintainer checklist for cutting a new release. Everything is driven by the
Makefiles (`Makefile` at the root, `DOCUMENTATION/Makefile`); this document
just records the order and the manual steps that are easy to miss.

The kernel command below is written as `math`; use whatever launches your
Wolfram/Mathematica kernel.

## 1. Do the work on a branch

```
git checkout -b my-change
```

Make your code/doc changes. Package sources live in `NCAlgebra/`,
`NCExtras/`, `NCPoly/`, `NCSDP/`, `NCTeX/`. Documentation **sources** are the
`*.md` files under `DOCUMENTATION/` — never hand-edit generated `*.usage`,
`README.md`, `index.html`, or the paclet.

## 2. Bump the version (NOT auto-propagated)

The canonical version is the root file `NC_VERSION`, but nothing reads it
automatically. Update every place by hand:

- `NC_VERSION`
- `PacletInfo.wl` (`"Version" -> "X.Y.Z"`)
- `NCAlgebra/banner.txt` (runtime banner, printed via `FilePrint`)
- `README.md` (the **root** landing page — hand-maintained, and NOT the same as
  the generated `DOCUMENTATION/README.md`): the `# NCAlgebra - Version X.Y.Z`
  title **and** the `NCAlgebra-X.Y.Z.paclet` install URL
- `DOCUMENTATION/MANUAL/Preamble.md`, `DOCUMENTATION/MANUAL/Cover.md`
- `DOCUMENTATION/MANUAL/Running.md` (the `NCAlgebra-X.Y.Z.paclet` install URL)
- `DOCUMENTATION/MANUAL/Version60.md` — add a `## Version X.Y.Z {#VersionX_Y_Z}`
  changelog entry

Sanity check afterwards: `git grep -n "<old-version>"` should only match the
changelog history in `Version60.md` and the generated docs' changelog sections.

## 3. Regenerate the `.usage` files (from the `.md` sources)

`.usage` files are generated from `DOCUMENTATION/**/*.md` by `md2usage.py`.
For an affected package:

```
make -C DOCUMENTATION/<pkg>            # e.g. NCExtras, NCAlgebra
make -C DOCUMENTATION/<pkg> install    # moves the .usage into the package dir
```

`make usage` (from the root) regenerates all of them, but bumps a timestamp
in every file — prefer regenerating only what changed. The NCAlgebra package
uses heading level `-H "###"`; most others use the default `##`.

## 4. Run the tests

```
make test          # runs the full .NCTest suites via the kernel
```

Every test must pass before releasing.

## 5. Regenerate the manual/site docs

```
make doc           # -> DOCUMENTATION/{README.md, index.html, NCDocument.pdf}
                   #    and copies index.html + css into the github.io submodule
```

Needs `pandoc`, `pdflatex`, `biber`. `README.md`/`index.html`/`NCDocument.pdf`
are tracked generated artifacts — commit them.

### 5a. Commit the `github.io` Pages submodule

`DOCUMENTATION/github.io` is a **git submodule** (the `NCAlgebra.github.io`
Pages repo). `make doc` copies the new HTML into it, so commit it there first,
then advance the pointer in the parent:

```
cd DOCUMENTATION/github.io
git add index.html *.css
git commit -m "vX.Y.Z"          # submodule uses vX.Y.Z commit messages, no tags
cd -
git add DOCUMENTATION/github.io  # advance the submodule pointer in the parent
```

## 6. Rebuild the paclet

`NCAlgebraPaclet/` is git-ignored and rebuilt from the base sources; the
tracked release artifact is the archive `NCAlgebra-X.Y.Z.paclet` at the root.

```
make deploy        # runs `make paclet` then CreatePacletArchive via the kernel
git rm  NCAlgebra-<old>.paclet
git add NCAlgebra-<new>.paclet
```

## 7. Commit, push, PR

```
git add -A
git commit -m "..."
git push -u origin my-change
```

Open a PR against `master` and merge it (the project uses PR merge commits,
e.g. `V6.0.0 (#20)`).

## 8. Tag the release

Tags are **lightweight**, named `vX.Y.Z`, and point at the **master commit
after the merge** (that is how existing tags like `v6.0.0` are placed):

```
git checkout master && git pull
git tag vX.Y.Z            # on the merged release commit
git push origin vX.Y.Z
```

The `github.io` submodule is not tagged (it only carries `vX.Y.Z` commit
messages).

## Notes

- Line endings are LF-only (`.gitattributes`, `* text=auto eol=lf`). Some
  editors/tools write CRLF back into a file; after editing verify with
  `grep -c $'\r' <file>` and strip stray CR with `sed -i 's/\r$//' <file>`
  so diffs stay clean.
- The `math` kernel here is the Wolfram 15.0 Windows kernel bridged through
  WSL; it reads LF fine. Filesystem paths that cross the WSL/Windows boundary
  need care.
