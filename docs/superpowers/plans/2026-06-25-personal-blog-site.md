# Personal Blog Site Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Turn the Hextra example site in `docs/` into a Chinese personal homepage plus blog.

**Architecture:** Keep Hextra as the theme and use `docs/` as the actual Hugo site. Hide official demo sections through site configuration, then replace top-level content with a personal homepage, blog, about page, projects page, and one starter post.

**Tech Stack:** Hugo, Hextra, Markdown content files, YAML site configuration.

---

### Task 1: Reconfigure The Site

**Files:**
- Modify: `docs/hugo.yaml`

- [ ] Set the site title, default language, description, navigation, blog settings, archive settings, and edit URL for a personal Chinese blog.
- [ ] Ignore the upstream Hextra demo docs, glossary, translated demo pages, and release-note blog posts so the deployed site only exposes personal content.
- [ ] Keep FlexSearch, RSS, dark mode, archives, and blog tag display enabled.

### Task 2: Replace Top-Level Content

**Files:**
- Modify: `docs/content/_index.md`
- Modify: `docs/content/blog/_index.md`
- Modify: `docs/content/about/index.md`
- Create: `docs/content/projects/index.md`
- Create: `docs/content/blog/start-here.md`

- [ ] Replace the Hextra marketing homepage with a personal landing page.
- [ ] Make the blog index explain that posts live under `docs/content/blog/`.
- [ ] Replace the Hextra about page with an editable personal profile page.
- [ ] Add a projects page for selected work.
- [ ] Add a starter blog post that documents the writing workflow and front matter.

### Task 3: Verify Build

**Files:**
- No source changes expected.

- [ ] Run `npm run build`.
- [ ] Confirm Hugo builds successfully and ignored demo content does not appear in the generated site.
