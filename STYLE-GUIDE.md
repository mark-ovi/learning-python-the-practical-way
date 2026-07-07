# Style guide (book + code)

This guide defines the default style for book content and Python code in this
repository. Keep changes small, consistent, and runnable.

## Scope

- Book content: `free/content/**` and `paid/content/**`
- Example code: `free/content/examples/**` and `paid/content/examples/**`
- Project solutions: `free/project-solutions/**` and `paid/project-solutions/**`

## Python code style

### Formatting and imports

- Use **Black** formatting defaults (line length 88).
- Use **isort** with Black-compatible ordering for imports.
- Keep imports at module top-level unless a local import is required to avoid a
  circular dependency or optional dependency crash.
- Group imports in this order:
  1. Standard library
  2. Third-party packages
  3. Local modules

### Naming

- Modules/files: `snake_case.py`
- Functions/variables: `snake_case`
- Classes: `PascalCase`
- Constants: `UPPER_SNAKE_CASE`
- Private/internal helpers: leading underscore (for example `_parse_row`)

### General code conventions

- Prefer explicit, readable code over compact tricks.
- Add type hints for new public functions and non-trivial helpers.
- Raise clear exceptions instead of silently ignoring errors.

## Docstring conventions

- Follow PEP 257 basics (triple double quotes, concise summary line).
- Add docstrings for:
  - Public modules with non-obvious behavior
  - Public classes
  - Public functions/methods that are not self-evident
- Keep one-line docstrings for simple functions.
- Use short multi-line docstrings when arguments/return behavior needs
  clarification.
- For small chapter snippets, docstrings are optional unless they improve
  teaching clarity.

## Example runnability

- Default rule: examples should be **copy/paste runnable**.
- If an example is intentionally partial (teaching snippet only), mark it
  clearly in nearby text (for example: "illustrative snippet, not standalone").
- Include required setup directly in the chapter or an adjacent `README.md`
  (dependencies, environment variables, and run command).
- Prefer deterministic output where practical so readers can compare results.

## Command and output formatting in book chapters

- Use fenced code blocks with an explicit language.
- Use `bash` for shell commands and `powershell` for Windows-specific commands.
- Use `text` for expected output.
- Keep command blocks and output blocks separate.
- Keep command examples minimal and executable from repository root unless a
  different working directory is explicitly shown.

Example:

```bash title="Terminal"
python free/content/examples/1.1/1-1-hello-world.py
```

```text title="Expected output"
Hello, world!
```

## Local contributor checks

Run these checks before opening a PR:

```bash
python -m pip install -r requirements.txt
python -m ruff check .
python -m black --check .
python -m isort --check-only .
python -m mkdocs build -f mkdocs.local.yml
```

If formatting checks fail, run:

```bash
python -m black .
python -m isort .
```
