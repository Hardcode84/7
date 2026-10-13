# Slide PDF export

Install Bun and Firefox, then run from the repository root:

```bash
bash build_tools/generate_slides_pdf.sh
```

The script installs the locked Marp dependencies with Bun. It writes
`build/slides/ProjectOverviewSlides.pdf` from
[the Markdown deck](../../docs/ProjectOverviewSlides.md).

Set a different output path with the optional argument:

```bash
bash build_tools/generate_slides_pdf.sh build/slides/overview.pdf
```

Relative output paths use the current directory. The script can run from any
directory. It uses a non-hidden temporary Firefox profile under the user's home
and removes it on exit. No Node.js installation is required.

Keep generated PDF, slide images, presentations, and dependency directories out
of Git. The text dependency lockfile remains tracked.
