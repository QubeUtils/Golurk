# Golurk

<img width="1584" height="396" alt="Image" src="https://github.com/user-attachments/assets/d0f41175-51ad-4df9-911c-e2818fb54720" />

> **Project Structure Analyser; visualise trees, aggregate code, and scope to microservices.**

`golurk` is a lightning-fast, zero-dependency bash tool designed for modern development workflows. It goes beyond the classic `tree` command by allowing you to easily dump file contents for LLM context, target specific microservices in a monorepo, output structured JSON/YAML, watch for live changes, and save artifacts directly to your desktop — all while natively bridging Linux/macOS and WSL/Windows.

Brought to you by [QubeUtils](https://github.com/QubeUtils).

---

## 📦 Installation

Install `golurk` directly using curl. It installs to `~/.local/bin` by default.

```bash
curl -fsSL https://raw.githubusercontent.com/QubeUtils/golurk/main/install.sh | bash
```
*(Ensure `~/.local/bin` is in your `$PATH`!)*

The installer automatically verifies the SHA256 checksum of the downloaded binary.

### WSL Users
`golurk` works flawlessly inside Windows Subsystem for Linux (WSL). When you use the `--desktop` flags, it automatically detects your Windows desktop path and saves files there so you can easily access them from Windows.

---

## 🚀 Quick Start

### 1. View your project tree
```bash
golurk tree
```
*Respects `.gitignore` automatically!*

### 2. Dump repo context for an LLM (Claude / ChatGPT)
```bash
# Dump the tree and all file contents, skipping binaries and files over 500k
golurk tree -C context.txt --skip-binaries -M 500k
```

### 3. Add a custom header to your LLM context dump
```bash
golurk tree -C context.txt --template "Analyze this {LANG} project. Root: {ROOT}. Date: {DATE}."
```

### 4. Export as JSON or YAML
```bash
golurk tree --json -o structure.json
golurk tree --yaml -o structure.yaml
```

### 5. Target specific Microservices
```bash
# Only analyze the auth and payment services
golurk tree -m "auth,payment"
```

### 6. Send output straight to your Desktop
```bash
golurk tree --output-desktop
```

### 7. Watch for live changes
```bash
golurk tree --watch --watch-interval 3
```

### 8. Preview a content dump without writing (dry run)
```bash
golurk tree -C context.txt --dry-run
```

### 9. See what changed vs a branch
```bash
golurk diff main
golurk diff main --stat
```

### 10. Project statistics with line count
```bash
golurk stats --line-count --desktop
```

---

## 🛠️ Commands

### `golurk tree [options]`
Generates a visual project tree and optionally aggregates file contents.

**Key Options:**
*   `-o, --output FILE` : Save tree output to a file.
*   `-C, --contents-file FILE` : Aggregate file contents into a single text file (great for LLMs).
*   `-B, --skip-binaries` : Skip binary files during content aggregation.
*   `-M, --max-size SIZE` : Skip files larger than a certain size (e.g., `5M`, `500k`).
*   `-m, --microservices LIST` : Target only specific microservices by name.
*   `--json` : Output tree as JSON.
*   `--yaml` : Output tree as YAML.
*   `--output-desktop` : Save the tree file directly to your desktop.
*   `--contents-desktop` : Save the contents dump directly to your desktop.
*   `--desktop` : Save *both* to your desktop.
*   `-f, --file-name PATTERN` : Only show files matching a pattern (e.g. `"pom.xml"`).
*   `--changed` : Only show files/directories with git changes.
*   `--follow-symlinks` : Follow symbolic links during traversal.
*   `--dry-run` : Preview which files would be included in a content dump, without writing.
*   `--watch` : Re-run automatically whenever you press Ctrl+C... just kidding — loops every `--watch-interval` seconds.
*   `--template STRING` : Prepend a custom header to content dumps. Supports `{DATE}`, `{ROOT}`, `{LANG}`, `{VERSION}`.
*   `--gitignore-full` : Enable full `.gitignore` parsing including `!negation` and `**` double-star patterns.
*   `--line-count` : Include total source line count in `--stats` output.
*   `--no-color` : Disable ANSI colorized output.

### `golurk micro`
Lists all detected microservices in your project based on standard conventions (directories containing `src/` or `pom.xml`).

### `golurk stats`
Displays a quick summary of directories, files, total size, top file extensions, and optionally total line count.

*   `-o, --output FILE` : Save stats to a file.
*   `--desktop` : Save stats output to your desktop.
*   `--line-count` : Include total source line count.

### `golurk diff [commit]`
Shows files changed between the working tree and a commit/branch (default: `HEAD`).

*   `--staged` : Show staged changes only.
*   `--stat` : Show a diffstat instead of the file list.

---

## ⚙️ Project Config (`.golurkrc`)

Place a `.golurkrc` file in your project root to set per-project defaults. CLI flags always override config values.

```bash
# .golurkrc — golurk project config
EXTRA_EXCLUDES+=(tmp logs coverage)
MAX_DEPTH=5
SKIP_BINARIES=true
GITIGNORE_FULL=true
```

---

## 🤝 Contributing

Contributions are welcome! Feel free to open an issue or submit a PR on [GitHub](https://github.com/QubeUtils/golurk).

## 📄 License

MIT License.
