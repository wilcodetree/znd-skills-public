---
name: markitdown
description: >-
  Convert a PDF, Word, PowerPoint, Excel, HTML, CSV, JSON, XML or EPUB file to clean
  Markdown before reading it: cuts token usage roughly 60 to 90 percent versus reading the
  file natively and keeps tables, headings and lists intact. Use before reading any file
  with one of those extensions, or on "read this PDF", "process this document", or "use
  markitdown". Do NOT use for plain .txt or .md files, native reading is already exact and
  cheaper for those, and not for images unless the goal is text extraction from the image
  itself.
---

# Markitdown file preprocessor

`markitdown` is Microsoft's own open-source tool (MIT licensed,
github.com/microsoft/markitdown); this skill is only the instructions for driving it inside
an agent sandbox. A 20-page PDF that runs 80k tokens read natively often comes in under 10k
as converted Markdown, with tables, headings and lists preserved where native reading
sometimes loses structure.

## Step 1: install markitdown

Sandboxed agent environments reset between sessions, so this usually needs to run once per
session:

```bash
pip install 'markitdown[all]' --break-system-packages -q
export PATH="$HOME/.local/bin:$PATH"
```

Done when `markitdown --version` prints a version. On a persistent environment (a local
machine, a long-lived container), this only needs to run once ever.

## Step 2: find the real file path

The path a file tool reports and the path a shell command needs are not always identical in
a sandboxed agent environment. If a direct path fails, search rather than guess:

```bash
find / -name "yourfilename.pdf" 2>/dev/null
```

Done when the command returns one real path.

## Step 3: convert

```bash
export PATH="$HOME/.local/bin:$PATH"
markitdown "/path/to/file.pdf" -o /tmp/converted.md
```

For a whole folder:

```bash
export PATH="$HOME/.local/bin:$PATH"
for f in /path/to/folder/*.pdf; do
  markitdown "$f" -o "/tmp/$(basename "${f%.pdf}").md"
done
```

Done when `/tmp/converted.md` (or one file per input) exists and is non-empty for a
text-based source.

## Step 4: read the converted file, not the original

Read `/tmp/converted.md` for every subsequent step: summarising, extracting, analysing.
Reading the original file again defeats the point of converting it first. Done when the
task's output is built entirely from the converted file.

## Supported formats

| Format | Notes |
|---|---|
| PDF | Text-based only. A scanned, image-only PDF converts to near-empty output; say so rather than proceeding as if it worked. |
| DOCX / DOC | Headings, tables and lists preserved. |
| PPTX / PPT | Slide text plus speaker notes, per slide. |
| XLSX / XLS | Each sheet becomes a Markdown table. |
| HTML | Clean text, links preserved. |
| CSV / JSON / XML | Structured text or tables. |
| EPUB | Chapter structure preserved. |

## Pitfalls

- Treating empty output from a scanned PDF as a conversion failure to retry. It is not a
  bug, markitdown cannot read text that was never there; the file needs OCR first.
- A restriction warning ("this PDF's metadata says text extraction is not allowed") is a
  warning, not a stop sign; `markitdown` proceeds, and so should the agent.
- Forgetting `export PATH="$HOME/.local/bin:$PATH"` after installing produces a plain
  "command not found", not an install error; re-run the export rather than reinstalling.
- Reading the original file again "just to double check". If the converted version is
  trusted enough to use, it is trusted enough to be the only copy read from.
