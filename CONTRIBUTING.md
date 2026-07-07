# Contributing to "Learning Python the Practical Way"

Thanks for your interest. This repository uses a split-license model, so text and
code contributions do not all default to the same license.

## Contributor acknowledgement and licensing

By submitting a contribution (issue, pull request, patch, or other content), you
confirm and agree to the following:

- You retain copyright in your contribution.
- You grant the repository owners a perpetual, worldwide, royalty-free right to
  use, reproduce, modify, adapt, publish, translate, create derivative works
  from, and distribute your contribution as part of this project.
- You agree that non-code instructional content is licensed under
  CC BY-NC-SA 4.0 and that code contributions are licensed under the MIT terms
  used in this repository.
- You confirm you have the right to contribute the material you submit.
- You acknowledge that contributions will not be paid and that contributors may
  be credited in acknowledgements unless they request anonymity.
- You confirm your contribution contains no confidential or third-party
  proprietary material for which you do not have the necessary rights.

See:

- [LICENSE.md](LICENSE.md) for book text and prose
- [LICENSE-CODE.md](LICENSE-CODE.md) for code
- [CODE-LICENSE-POLICY.md](CODE-LICENSE-POLICY.md) for code-scope and
  attribution rules

## How to contribute

1. Fork the repo or create a branch in your fork.
2. Use a descriptive branch name such as `feature/chapter-5` or `fix/typo-ch2`.
3. Make focused commits with clear messages.
4. Open a PR to `main`, use the PR template, and request `@mark-ovi` as
   reviewer.
5. Address review comments and keep PRs small enough to review comfortably.

## What to contribute

- Typo and copy edits
- Corrections to code examples and runnable tests
- Clarifications or improvements to explanations
- New examples or chapters (open an issue first for larger additions)

## Chapter template and folder conventions

Use [CHAPTER-TEMPLATE.md](CHAPTER-TEMPLATE.md) when creating or restructuring a
chapter. It defines the expected chapter sections, example-linking pattern, and
asset references.

Use these repo-relative paths:

- Chapters: `/content/chapters/`
- Examples: `/content/examples/`
- Project solutions: `/project-solutions/`

Keep code, tests, and assets grouped with the chapter they support, and follow
the naming and mapping rules described in the chapter template.

## Style guide

Follow [STYLE-GUIDE.md](STYLE-GUIDE.md) for:

- Markdown and chapter formatting
- Python code style and naming
- Example runnability expectations
- Local formatting and validation commands

## Running checks locally

Before opening a PR, install dependencies and run the current local checks from
the repository root:

```bash
python -m pip install -r requirements.txt
npm install
python -m ruff check .
python -m mkdocs build -f mkdocs.local.yml
npx markdownlint-cli2 "free/content/**/*.md" "paid/content/**/*.md"
```

If `mkdocs.local.yml` is not present in your checkout, use:

```bash
python -m mkdocs build -f mkdocs.yml
```

For the broader formatting guidance used in this repo, also review the
formatter checks listed in [STYLE-GUIDE.md](STYLE-GUIDE.md).

## Review process

- All PRs touching `main` require review from the code owner (`@mark-ovi`).
- CI checks must pass before merging.
- Add a changelog entry for substantive changes when appropriate.

## Security

Do not open public issues for security-sensitive information. Contact the
repository owner privately.

Thank you for helping improve the book.
