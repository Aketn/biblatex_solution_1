# latexmk Troubleshooting Report

## Overview

- **Date**: 2025-09-29
- **Environment**: LuaLaTeX + Biber (`latexmk`)
- **Issue**: `latexmk` would not converge because `version.dat` kept changing on every run.
- **Solution**: Instruct `latexmk` to ignore `*.dat` files when comparing hashes.


## Symptom Detail

Running `latexmk -lualatex -interaction=nonstopmode main.tex` showed repeated rebuilds. The log reported:

```text
Rules that could not be fulfilled:
   lualatex
   lualatex
...
Latexmk: Run number 13 of rule 'lualatex'
```

Despite no source changes, `latexmk` believed an output file changed at each pass.

## Root Cause Investigation

- `latexmk` maintains a hash table of generated files.
- If any file's hash differs between runs, `latexmk` triggers another compilation.
- `version.dat` is regenerated every run with unique content, so its hash always changes.

## Resolution

Add the following line to `.latexmkrc`:

```perl
$hash_calc_ignore_pattern{'pdflatex'} = '^version\\.dat$';
```

For a LuaLaTeX workflow, target `lualatex` instead:

```perl
$hash_calc_ignore_pattern{'lualatex'} = '^version\\.dat$';
```

This tells `latexmk` to skip checksum comparisons for `version.dat`, allowing the build to converge.


## Verification

1. Run `latexmk -lualatex -interaction=nonstopmode main.tex`.
2. Confirm that the build completes with “`All targets are up-to-date`” after the standard LuaLaTeX/Biber cycle.
3. Subsequent runs should exit immediately when no sources have changed.

## Additional Notes

- The pattern uses double escaping (`\`) so that the final regex is `^version\.dat$`.
- Apply similar ignore patterns if other automatically changing files appear in your workflow.
