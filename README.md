# slidepack

A custom local Typst layout package for [polylux](https://typst.app/universe/package/polylux)-based slide pack presentations.

- Package name: `slidepack`
- Version: `0.1.0`
- Entrypoint: `lib.typ`

This is a local Typst package (not published to the public [Typst Universe](https://typst.app/universe) registry). It is installed into Typst's local package directory on your own machine, so any Typst project on that machine can import it via:

```typst
#import "@local/slidepack:0.1.0": slidepack
```

## Files

| File                          | Purpose                                                      |
|-------------------------------|---------------------------------------------------------------|
| `lib.typ`                     | The package source — defines the `slidepack` function/template. |
| `typst.toml`                  | The package manifest (name, version, entrypoint, metadata).   |
| `install-slidepack-package.sh`  | Installer script for Linux/macOS.                            |
| `install-slidepack-package.ps1` | Installer script for Windows (PowerShell).                   |

## Installing the package

The installer scripts read `name` and `version` straight out of `typst.toml` and copy `lib.typ` + `typst.toml` into Typst's local package directory for your OS, at:

```
{data-dir}/typst/packages/local/slidepack/0.1.0/
```

### Linux / macOS

```bash
chmod +x install-slidepack-package.sh
./install-slidepack-package.sh /path/to/folder/containing/lib.typ
```

If you omit the path argument, it defaults to the current directory.

This installs to:
- **Linux:** `$XDG_DATA_HOME/typst/packages/local` or `~/.local/share/typst/packages/local`
- **macOS:** `~/Library/Application Support/typst/packages/local`

### Windows (PowerShell)

```powershell
.\install-slidepack-package.ps1 -SourceDir "C:\path\to\folder\containing\lib.typ"
```

If you omit `-SourceDir`, it defaults to the current directory.

This installs to:
- **Windows:** `%APPDATA%\typst\packages\local`

## Using the package

Once installed, import it in any Typst document like a regular package:

```typst
#import "@preview/polylux:0.4.0": *
#import "@local/slidepack:0.1.0": slidepack

#show: slidepack.with(
  title: [A slide pack],
  author: "C Kunte",
)

#slide[
  = Hello

  Content goes here.
]
```

The [typst-snippets-st](https://github.com/ckunte/typst-snippets-st) and [typst-snippets-vim](https://github.com/ckunte/typst-snippets-vim) repositories provide editor snippets (`sp`, `ts`, `tc`, `ss`, `s1`, `s2`) that scaffold documents against this package.

You can check exactly where Typst looks for local packages on your system at any time by running:

```bash
typst info
```

and checking the `Package path` it reports.

## Updating the package

1. Edit `lib.typ` as needed
2. Bump the `version` field in `typst.toml` (e.g. `0.1.0` → `0.1.1`)
3. Re-run the appropriate install script — it will create a new versioned folder alongside the old one, so update your `#import` statements to match the new version

Old versions aren't deleted automatically; remove the corresponding folder under `packages/local/slidepack/` manually if you want to clean them up.

## Notes

- This uses Typst's standard **local package** convention (the `@local` namespace), which works with the Typst CLI / desktop app
- This is different from **Typst Pro's private packages**, a paid cloud feature of the [typst.app](https://typst.app) web editor where packages are published and shared through your online workspace instead of a folder on disk
