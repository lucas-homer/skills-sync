# skills-sync

Keep your agent skills in sync across machines. Syncs `~/.agents/.skill-lock.json` via a private GitHub gist.

## Prerequisites

| Dependency | Why | Install |
|-----------|-----|---------|
| Node.js ≥18 | Provides `npx` for the skills CLI | `brew install node` or [nodejs.org](https://nodejs.org) |
| `gh` CLI | Gist CRUD for syncing | `brew install gh` then `gh auth login` |
| `jq` | JSON parsing | `brew install jq` |

Verify:

```bash
node --version    # ≥18
gh --version      # any
jq --version      # any
gh auth status    # must be authenticated
```

## Install

```bash
git clone https://github.com/lucas-homer/skills-sync.git
cd skills-sync && ./install.sh
```

Or one-liner:

```bash
curl -sSL https://raw.githubusercontent.com/lucas-homer/skills-sync/master/install.sh | bash
```

## Setup

You need at least one skill installed (creates `~/.agents/.skill-lock.json`):

```bash
npx skills add anthropics/skills
```

Then initialize sync:

```bash
# First machine — creates a private gist
skills-sync init

# Other machines — link to the same gist
skills-sync init <gist-id>
```

## Usage

```bash
# Install a skill and auto-sync
skills-sync add anthropics/skills

# Push local lock file to gist
skills-sync push

# Pull remote lock file and install missing skills
skills-sync pull

# Pull and remove local-only skills
skills-sync pull --prune

# Show diff between local and remote
skills-sync status
```

## How it works

`skills-sync` doesn't sync the skills directory — it syncs the lock file. The lock file at `~/.agents/.skill-lock.json` tracks every installed skill with its GitHub source, hash, and timestamps. By syncing this file via a private gist, any machine can replay the installs using `npx skills add <source>`.

### Files on your machine

| File | Purpose |
|------|---------|
| `~/.local/bin/skills-sync` | The installed script |
| `~/.agents/.skill-lock.json` | Lock file (source of truth for installed skills) |
| `~/.agents/.skills-sync-config` | Config file (stores your gist ID) |

## License

MIT
