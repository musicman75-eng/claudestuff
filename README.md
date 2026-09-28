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

## HyperFrames (video animation)

[HyperFrames](https://github.com/heygen-com/hyperframes) turns HTML, CSS and
GSAP animations into rendered MP4 video. It is set up here in three parts:

- **Skills** live in [`.claude/skills/`](.claude/skills) (all 21 published
  HyperFrames skills, vendored from upstream `f55c0bb`, Apache-2.0). Claude Code
  loads them automatically in this repo. Start any video request with
  `/hyperframes`, or go straight to a workflow such as `/motion-graphics`,
  `/faceless-explainer`, `/talking-head-recut`, `/embedded-captions`,
  `/music-to-video`, `/slideshow` or `/general-video`.
- **Project** lives in [`videos/`](videos). `index.html` is the root timeline;
  scenes go in `videos/compositions/`. A 6-second title card is included as a
  working example. GSAP and fonts are bundled under `videos/assets/` because the
  cloud render browser cannot reach CDNs.
- **Session hook** ([`.claude/hooks/session-start.sh`](.claude/hooks/session-start.sh))
  installs ffmpeg and the headless Chrome renderer at the start of every
  Claude Code on the web session.

```bash
cd videos
npm run check    # lint + runtime + layout + contrast gate
npm run render   # writes renders/<name>.mp4
npm run dev      # live preview studio (local machine)
```

Try a prompt like: *"Using /hyperframes, make a 20-second vertical clip from
this sermon excerpt with kinetic type in Anton, navy and warm gold."*

## HyperFrames Student Kit (footage editing)

[`student-kit/`](student-kit) is Nate Herk's
[HyperFrames Student Kit](https://github.com/nateherkai/hyperframes-student-kit)
(upstream `ec112ff`, MIT plus the kit's use permission in
`student-kit/licenses/`). Where `videos/` is for building motion graphics from
scratch, the kit is for editing your own recordings: transcribe, cut dead air
and retakes, plan the story, then layer motion graphics from its 406-card style
library.

It is a self-contained workspace with its own `CLAUDE.md` and 15 skills in
`student-kit/.claude/skills/`, and it pins its own HyperFrames version
(0.7.109). Work inside `student-kit/` so its instructions and skills apply:
`/edit-video`, `/short-form-edit`, `/cut-silences`, `/cut-mistakes`,
`/video-storytelling`, `/motion-showreel`, `/style-library`.

Left out on purpose: the 12 teaching projects and showcase videos (~390 MB of
footage) and the AI Automation Society brand files, which the kit's license says
are not licensed for reuse.

```bash
cd student-kit
npm test                        # 11 kit tests
npm run new-video -- my-sermon  # creates video-projects/my-sermon
```

Transcription uses ElevenLabs by default. Put `ELEVENLABS_API_KEY` in
`student-kit/.env` (gitignored), or ask for Whisper instead. Everything under
`student-kit/video-projects/` is gitignored, so footage and renders never land
in the repo. In a cloud session they disappear when the container is reclaimed.

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
