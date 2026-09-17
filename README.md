# Golurk

<img width="1584" height="396" alt="Image" src="https://github.com/user-attachments/assets/d0f41175-51ad-4df9-911c-e2818fb54720" />

> Project Structure Analyser — visualise trees, aggregate code, and scope to microservices.

`golurk` is a zero-dependency bash tool for modern development workflows. It goes beyond the classic `tree` command by letting you dump file contents for LLM context, target specific microservices in a monorepo, output JSON or YAML, watch for live changes, and save files directly to your desktop. It works natively on Linux, macOS, and WSL on Windows.

Brought to you by [QubeUtils](https://github.com/QubeUtils).

---

## Installation

### Homebrew (macOS and Linux)

```bash
brew tap QubeUtils/tap
brew install golurk
```

### NPM

```bash
npm install -g golurk
```

Or run it without installing anything permanently:

```bash
npx golurk tree
```

### curl (manual install)

```bash
curl -fsSL https://raw.githubusercontent.com/QubeUtils/Golurk/main/install.sh | bash
```

This installs `golurk` to `~/.local/bin`. Make sure that directory is in your `$PATH`.

---

## Uninstall

### Homebrew

```bash
brew uninstall golurk
```

### NPM

```bash
npm uninstall -g golurk
```

### Manual (curl install)

```bash
rm ~/.local/bin/golurk
# Optionally, remove the config file too
rm ~/.golurkrc
```

---

## WSL (Windows)

`golurk` works inside Windows Subsystem for Linux. When you use the `--desktop` flag, it automatically detects your Windows desktop path and saves files there so you can access them directly from Windows.

---

## Quick Start

**View your project tree:**
```bash
golurk tree
```

**Dump your entire codebase into a single file for an LLM (Claude, ChatGPT, etc.):**
```bash
golurk tree -C context.txt --skip-binaries -M 500k
```

**Add a custom header to the LLM context dump:**
```bash
golurk tree -C context.txt --template "Analyze this {LANG} project. Root: {ROOT}. Date: {DATE}."
```

**Export the tree as JSON or YAML:**
```bash
golurk tree --json -o structure.json
golurk tree --yaml -o structure.yaml
```

**Target specific microservices in a monorepo:**
```bash
golurk tree -m "auth,payment"
```

**Save output directly to your desktop:**
```bash
golurk tree --desktop
```

**Watch for file changes and re-run automatically:**
```bash
golurk tree --watch --watch-interval 3
```

**Preview which files would be included in a dump, without writing anything:**
```bash
golurk tree -C context.txt --dry-run
```

**See what changed vs a branch:**
```bash
golurk diff main
golurk diff main --stat
```

**Show project statistics:**
```bash
golurk stats --line-count
```

---

## Commands

### `golurk tree [options]`

Generates a visual project tree and optionally aggregates file contents into a single file.

| Option | Description |
|---|---|
| `-o, --output FILE` | Save tree output to a file |
| `-C, --contents-file FILE` | Aggregate all file contents into a single file |
| `-B, --skip-binaries` | Skip binary files during content aggregation |
| `-M, --max-size SIZE` | Skip files larger than a given size (e.g. `5M`, `500k`) |
| `-m, --microservices LIST` | Target only specific microservices by name |
| `-f, --file-name PATTERN` | Only show files matching a pattern (e.g. `pom.xml`) |
| `-d, --dir-pattern PATTERN` | Only show files under directories matching a pattern |
| `--level N` | Show structure up to N levels deep |
| `--compact` | Show folders only, hide files |
| `--json` | Output the tree as JSON |
| `--yaml` | Output the tree as YAML |
| `--desktop` | Save both the tree and contents to your desktop |
| `--output-desktop` | Save the tree file to your desktop |
| `--contents-desktop` | Save the contents file to your desktop |
| `--changed` | Only show files and directories with git changes |
| `--follow-symlinks` | Follow symbolic links during traversal |
| `--dry-run` | Preview which files would be included, without writing |
| `--watch` | Re-run automatically every few seconds |
| `--watch-interval N` | Seconds between re-runs when using `--watch` (default: 3) |
| `--template STRING` | Prepend a custom header to content dumps. Supports `{DATE}`, `{ROOT}`, `{LANG}`, `{VERSION}` |
| `--gitignore-full` | Enable full `.gitignore` parsing including negation and double-star patterns |
| `--clip` | Copy the final output to your system clipboard |
| `--shorten-paths` | Flatten deep directory paths for readability |
| `--no-color` | Disable coloured output |

### `golurk micro`

Lists all detected microservices in your project. A directory is considered a microservice if it contains a `src/` folder or a `pom.xml` file.

```bash
golurk micro --microservices
```

### `golurk stats [options]`

Shows a summary of directories, files, total size, and top file extensions.

| Option | Description |
|---|---|
| `-o, --output FILE` | Save stats to a file |
| `--desktop` | Save stats to your desktop |
| `--line-count` | Include total source line count |

### `golurk diff [commit]`

Shows which files changed between your working tree and a commit or branch. Defaults to `HEAD`.

| Option | Description |
|---|---|
| `--staged` | Show staged changes only |
| `--stat` | Show a diffstat instead of a plain file list |

---

## Project Config (`.golurkrc`)

You can place a `.golurkrc` file in your project root to set per-project defaults. Any flags you pass on the command line will always override the config file.

```bash
# .golurkrc
EXTRA_EXCLUDES+=(tmp logs coverage)
MAX_DEPTH=5
SKIP_BINARIES=true
GITIGNORE_FULL=true
```

---

## Contributing

Contributions are welcome. See [CONTRIBUTING.md](CONTRIBUTING.md) for instructions on setting up the test suite and submitting a pull request.

## License

[MIT](LICENSE)
