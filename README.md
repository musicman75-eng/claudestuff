# Skill Installation Prototype

A minimal prototype showing how a Claude **skill** is structured and how to
install it so Claude can discover and load it on demand.

## Layout

```
.
├── install.sh            # installs skills/ into a Claude skills directory
├── skills/
│   └── prototype/
│       └── SKILL.md      # the example skill
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

# Install into a custom location (e.g. a project-local skills dir)
./install.sh --target ./.claude/skills prototype
# or
CLAUDE_SKILLS_DIR=./.claude/skills ./install.sh
```

After installing, the `prototype` skill becomes available and loads whenever a
task matches its description.

## Creating a new skill from the prototype

1. Copy `skills/prototype/` to `skills/<your-skill-name>/`.
2. Edit the `name` and `description` in the frontmatter — the `description`
   drives when your skill triggers, so be specific.
3. Replace the body with your skill's real instructions.
4. Run `./install.sh <your-skill-name>`.
