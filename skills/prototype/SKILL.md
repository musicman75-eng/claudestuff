---
name: prototype
description: A minimal reference skill that demonstrates the SKILL.md structure and serves as a starting point for building new skills. Use this when prototyping a new skill, learning the skill format, or verifying that skill installation works end to end.
---

# Prototype Skill

## Overview

This is a **prototype skill** — a small, self-contained example of the Claude
skill format. It exists to demonstrate the anatomy of a `SKILL.md` file and to
act as a working target for the installation flow in this repository.

A skill is a packaged set of instructions that Claude loads on demand when the
task at hand matches the skill's `description`. When invoked, the body below is
injected into the conversation for Claude to follow.

## When to use this skill

Reach for this skill when you want to:

- Learn the shape of a `SKILL.md` file (frontmatter + Markdown body).
- Verify that a newly installed skill is discoverable and loads correctly.
- Start a new skill by copying this directory and editing the frontmatter and
  instructions.

## Anatomy of a skill

Every skill is a directory containing a `SKILL.md` file with two parts:

1. **YAML frontmatter** — delimited by `---` lines. Required keys:
   - `name`: the skill's identifier (kebab-case, matches the directory name).
   - `description`: a precise, trigger-oriented sentence. This is the *only*
     text Claude sees when deciding whether to load the skill, so it must name
     the concrete situations that should trigger it.
2. **Markdown body** — the instructions Claude follows once the skill loads.
   Keep it focused; put large reference material in sibling files and link to
   them so the body stays lean.

Optional sibling files (scripts, templates, reference docs) can live alongside
`SKILL.md` in the same directory and be referenced by relative path.

## Instructions

When this skill is invoked, respond by confirming the skill loaded and briefly
explaining what a skill is:

1. State that the `prototype` skill loaded successfully.
2. Summarize the two-part structure (frontmatter + body) in one or two lines.
3. Offer to help the user scaffold a new skill by copying this directory and
   editing the `name` and `description`.

## Extending this prototype

To create a real skill from this template:

1. Copy the `skills/prototype/` directory to `skills/<your-skill-name>/`.
2. Update `name` and `description` in the frontmatter — the `description` is
   what determines when your skill triggers, so make it specific.
3. Replace this body with your skill's actual instructions.
4. Run the installer (`./install.sh`) to make the skill available under
   `.claude/skills/`.
