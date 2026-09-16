# Contributing to Golurk

First off, thank you for considering contributing to Golurk! It's people like you that make open source such a great community.

## Getting Started

1. Fork the repository on GitHub and clone it locally.
2. Ensure you have a Unix-like environment (WSL, Linux, macOS, or Git Bash on Windows).
3. Ensure you have `bats` installed to run the test suite. If you don't have it, you can install it via your package manager (e.g. `sudo apt-get install bats` or `npm install -g bats`).

## Making Changes

1. Create a new branch for your feature or bugfix (`git checkout -b feature/your-feature-name`).
2. Modify the `golurk` bash script.
3. Ensure you add tests in `tests/test_golurk.bats` for any new functionality or bug fixes.

## Running Tests

Before submitting a Pull Request, always run the test suite to ensure no existing functionality is broken:

```bash
bats tests/
```

*Note for Windows users: if you installed BATS via `npm`, it is highly recommended to run the test suite inside Git Bash or WSL.*

## Submitting a Pull Request

- Ensure all tests pass.
- Update the `README.md` if you are adding new features, changing flags, or altering the public API.
- Write a clear and concise PR description explaining the changes and the reasoning behind them.

## Code Style

- Stick to standard bash conventions.
- Use `[[ ]]` over `[ ]` for conditional logic.
- Avoid using `eval` for security reasons when parsing user input.
- Keep the script self-contained (try to avoid introducing heavy external dependencies unless absolutely necessary like `fd`).
