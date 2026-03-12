```
     _    ____   ____  _____                     _
    / \  |  _ \ / ___||  ___|__  _   _ _ __   __| |_ __ _   _
   / _ \ | |_) | |    | |_ / _ \| | | | '_ \ / _` | '__| | | |
  / ___ \|  _ <| |___ |  _| (_) | |_| | | | | (_| | |  | |_| |
 /_/   \_\_| \_\\____||_|  \___/ \__,_|_| |_|\__,_|_|   \__, |
                                                         |___/
```

A pre-ARC standards incubator. Experiment and iterate on standards before formal ARC submission.

## Lifecycle

```
draft → proto → submitted → official ARC
```

| Stage | Directory | Purpose |
|-----------|---------------|----------------------------------------------|
| Draft | `drafts/` | Raw ideas, early exploration |
| Proto | `proto/` | Structured proposals with frontmatter |
| Submitted | `submitted/` | Finalized proposals exported for ARC review |
| Archived | `archived/` | Withdrawn or superseded proposals |

## Quick Start

### Create a new draft

```bash
cp templates/draft.md drafts/my-idea.md
# Edit drafts/my-idea.md with your idea
```

### Promote draft to proto

```bash
./scripts/promote.sh drafts/my-idea.md proto
```

### Validate all proposals

```bash
./scripts/validate.sh
```

### Export a proto to ARC format

```bash
./scripts/export-arc.sh proto/my-idea.md
```

## Repository Structure

```
.
├── .github/workflows/   # CI: validation and export automation
├── drafts/              # Raw ideas and early explorations
├── proto/               # Structured proposals with frontmatter
├── submitted/           # Finalized proposals ready for ARC
├── archived/            # Withdrawn or superseded proposals
├── exports/             # Generated ARC-formatted outputs
├── templates/           # Starter templates for drafts and protos
├── scripts/             # Promotion, validation, and export tools
└── docs/                # Process documentation and governance
```

## Design Philosophy

ARCFoundry is a **standards lab** — a builder workshop and staging pipeline for ARC proposals.

- Fast drafting of ideas
- Structured but lightweight process
- Automated promotion and export
- Minimal governance friction
- Clear evolution path toward ARC proposals

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for the full guide.

## License

[MIT](LICENSE)
