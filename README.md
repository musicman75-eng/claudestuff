# Skill Installation Prototype

A prototype showing how a Claude **skill** is structured and how to install it
so Claude can discover and load it on demand.

## Bundled skills

- [`prototype`](skills/prototype/SKILL.md) — Emil Kowalski's "Prototyping
  Variants" skill: builds several genuinely different versions of a described UI
  piece behind a live visual picker so you can flip through them and promote a
  winner. Ships with a sibling [`PICKER.md`](skills/prototype/PICKER.md) that
  specifies the picker chrome verbatim.
  Source: <https://github.com/emilkowalski/skills>
- [`stop-slop`](skills/stop-slop/SKILL.md) — Hardik Pandya's skill for removing
  AI writing tells from prose: banned phrases, structural clichés, and a 1–10
  scoring rubric. Ships with reference files under
  [`references/`](skills/stop-slop/references) loaded on demand.
  Source: <https://github.com/hardikpandya/stop-slop>

## Layout

```
.
├── install.sh                  # installs skills/ into a Claude skills directory
├── skills/
│   ├── prototype/
│   │   ├── SKILL.md            # skill definition (frontmatter + instructions)
│   │   └── PICKER.md           # sibling reference file loaded by the skill
│   └── stop-slop/
│       ├── SKILL.md            # skill definition
│       ├── references/         # phrases.md, structures.md, examples.md
│       └── LICENSE
└── README.md
```

## What is a skill?

A skill is a directory containing a `SKILL.md` file. That file has:

- **YAML frontmatter** with a `name` and a `description`. The `description` is
  the only text Claude reads when deciding whether to load the skill, so it must
  clearly name the situations that should trigger it.
- A **Markdown body** with the instructions Claude follows once the skill loads.

Optional scripts, templates, or reference docs can sit alongside `SKILL.md` in
the same directory.

## Installing

"Installing" a skill copies its directory into a Claude skills directory (by
default `~/.claude/skills/`), where Claude discovers it automatically.

```bash
# List what can be installed
./install.sh --list

# Install every skill in skills/
./install.sh

# Install a specific skill
./install.sh prototype
./install.sh stop-slop

# Install into a custom location (e.g. a project-local skills dir)
./install.sh --target ./.claude/skills prototype
# or
CLAUDE_SKILLS_DIR=./.claude/skills ./install.sh
```

After installing, a skill becomes available and loads whenever a task matches
its description. Reference files and subdirectories are copied along with the
skill.

## Creating a new skill from the prototype

1. Copy `skills/prototype/` to `skills/<your-skill-name>/`.
2. Edit the `name` and `description` in the frontmatter — the `description`
   drives when your skill triggers, so be specific.
3. Replace the body with your skill's real instructions.
4. Run `./install.sh <your-skill-name>`.
