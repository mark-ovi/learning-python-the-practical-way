# Chapter Markdown template

Use this template when creating a new chapter.

## File and asset conventions

1. Chapter files go in `content/chapters/` with a numeric prefix `<part#-chapter#-filename>.md`, for example: `1-2-Loops.md`.
2. Chapter assets go in `content/assets/<part.chapter>/`, for example: `content/assets/1.2/`.
3. Asset files use `part#-chapter#-asset-name`, for example: `1-2-request-flow.png`.
4. Prefer reference-style links for reusable asset paths so the chapter body stays readable.

Example asset references from a chapter in `content/chapters/`:

```md
![Request flow diagram][img-request-flow]

[img-request-flow]: ../assets/1.2/1-2-request-flow.png
```

## Code example conventions

1. Chapter examples go in `content/examples/<part.chapter>/`, for example: `content/examples/1.2/`.
2. Example files use `<part#-chapter#-example-name>`, for example: `1-2-loops-basic.py`.
3. If an example needs setup notes or multiple supporting files, add a `README.md` in the same chapter example folder.
4. If an example needs chapter-specific dependencies, add a `requirements.txt` in the same chapter example folder.
5. Put tests for chapter examples in `content/examples/<part.chapter>/tests/`.
6. Chapters map directly to their example and asset folders. For example, `content/chapters/1-2-Loops.md` maps to `content/examples/1.2/` and `content/assets/1.2/`.
7. Prefer reference-style links for reusable example paths so the chapter body stays readable.

Example code references from a chapter in `content/chapters/`:

```md
See [the loops example][example-loops-basic].

[example-loops-basic]: ../examples/1.2/1-2-loops-basic.py
```

## Chapter template

```md
---
title: "Part X, Chapter Y: Chapter Title"
summary: "One-sentence chapter summary."
difficulty: "beginner" # beginner | intermediate | advanced
estimated_time: "25 min"
---

# Part X, Chapter Y: Chapter Title

> **Learning goals**
>
> By the end of this chapter, the reader can:
> - Goal 1
> - Goal 2
> - Goal 3

## Prerequisites

- Previous chapter(s): [Part X, Chapter Y-1](./xx-previous.md)
- Required tools/libraries:
  - Python 3.11+
  - requests (or other package)

## Why this matters

Brief context that connects this chapter to real-world usage.

## Core concept

Explain the main idea first, then show the smallest useful example.

```python title="examples/1.2/1-2-basic-example.py"
print("Minimal, runnable example")
```

Use inline code for short names like `dict`, `pip install`, and `--help`.

## Step-by-step walkthrough

### 1. First step

Describe what the reader should do and why.

```bash title="Terminal"
python -m venv .venv
```

### 2. Second step

Add the next step, including expected output when useful.

```text title="Expected output"
Environment created successfully.
```

## Common mistakes and troubleshooting

!!! warning "Common error"
    Explain the symptom, cause, and exact fix.

!!! tip "Good practice"
    Provide a practical habit that avoids recurring mistakes.

## Exercises

### Exercise 1 (Core)

**Task:** A clear prompt for the reader.

**Success criteria:**
- Criterion 1
- Criterion 2

### Exercise 2 (Stretch)

Optional challenge that extends the core concept.

## Chapter recap

- Key point 1
- Key point 2
- Key point 3

## Next chapter

One sentence that bridges to the next chapter topic:
[Part X, Chapter Y+1: Next Topic](./zz-next-topic.md)

<!-- Asset references -->
[img-example]: ../assets/X.Y/X-Y-example.png
[example-basic]: ../examples/X.Y/X-Y-basic-example.py
```
