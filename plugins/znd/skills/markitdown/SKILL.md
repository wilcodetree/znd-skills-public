---
name: markitdown
description: >-
  Convert a PDF, Word, PowerPoint, Excel, HTML, CSV, JSON, XML or EPUB file to clean Markdown before reading it, using Microsoft's open-source markitdown tool, to cut token usage roughly 60 to 90 percent versus reading the file natively and to keep tables, headings and lists intact. Use before reading any file with one of those extensions, or when the user says "read this PDF", "summarise this report", "extract the data from this spreadsheet", "process this document", "convert this to markdown", or "use markitdown". Do NOT use for plain .txt or .md files, Claude reads those directly, and not for images unless text extraction from the image itself is the goal.
---

# Markitdown file preprocessor

Reading a PDF or an Office file natively can cost far more tokens than the same content
converted to Markdown first: a 20-page PDF that runs 80k tokens read natively often comes in
under 10k as converted Markdown, and tables, headings and lists survive the conversion where
native reading sometimes loses structure. `markitdown` is Microsoft's own open-source tool
(MIT licensed, github.com/microsoft/markitdown), not part of this skill, this skill is only the
instructions for driving it inside an agent sandbox.

## When to use this skill

- Any `.pdf`, `.docx`, `.doc`, `.pptx`, `.ppt`, `.xlsx`, `.xls`, `.html`, `.htm`, `.csv`, `.json`,
  `.xml` or `.epub` file is about to be read, especially a large one
- The user explicitly asks to convert a file to Markdown
- Do NOT use it for `.txt` or `.md`, native reading is already exact and cheaper for those. Do
  NOT use it for images unless the user wants text pulled out of the image specifically.

## Step 1: install markitdown

Sandboxed agent environments reset between sessions, so this usually needs to run once per
session:

```bash
pip install 'markitdown[all]' --break-system-packages -q
export PATH="$HOME/.local/bin:$PATH"
```

Verify with `markitdown --version`. If the environment persists across sessions (a local
machine, a long-lived container), this step only needs to run once ever.

## Step 2: find the real file path

The path a file tool reports and the path a shell command needs are not always identical in a
sandboxed agent environment. If a direct path fails, search for the file rather than guessing:

```bash
find / -name "yourfilename.pdf" 2>/dev/null
```

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

## Step 4: read the converted file, not the original

Read `/tmp/converted.md` for every subsequent step, summarising, extracting, analysing. Reading
the original file again defeats the entire point of converting it first.

## Supported formats

| Format | Notes |
|---|---|
| PDF | Text-based only. A scanned, image-only PDF converts to near-empty output, say so rather than proceeding as if it worked. |
| DOCX / DOC | Headings, tables and lists preserved. |
| PPTX / PPT | Slide text plus speaker notes, per slide. |
| XLSX / XLS | Each sheet becomes a Markdown table. |
| HTML | Clean text, links preserved. |
| CSV / JSON / XML | Structured text or tables. |
| EPUB | Chapter structure preserved. |

## Pitfalls

- Treating empty output from a scanned PDF as a conversion failure to retry. It is not a bug,
  markitdown cannot read text that was never there; the file needs OCR first.
- A restriction warning ("this PDF's metadata says text extraction is not allowed") is a
  warning, not a stop sign, `markitdown` proceeds, and so should the agent.
- Forgetting `export PATH="$HOME/.local/bin:$PATH"` after installing produces a plain
  "command not found", not an install error, re-run the export rather than reinstalling.
- Reading the original file again after conversion "just to double check". If the converted
  version is trusted enough to use, it is trusted enough to be the only copy read from.
