# Proposal Lifecycle

## Stages

### Draft

**Directory:** `drafts/`

The starting point. Drafts are informal explorations of an idea. They don't need to be complete or polished — just enough to communicate the core concept.

**Requirements:**
- YAML frontmatter with `title`, `author`, `status`
- A clear problem statement

**Promotion criteria:**
- The idea has been discussed and has support
- The problem and solution are well-defined enough to specify

### Proto

**Directory:** `proto/`

A structured proposal with full frontmatter and detailed specification. Protos should be concrete enough that someone could implement them.

**Requirements:**
- Full YAML frontmatter (title, author, status, created, updated)
- Abstract, Motivation, Specification, Rationale sections
- Security considerations addressed

**Promotion criteria:**
- Specification is complete and unambiguous
- Community feedback has been incorporated
- No unresolved blocking questions

### Submitted

**Directory:** `submitted/`

The proposal has been finalized and exported for formal ARC submission. At this point the proposal should be stable.

**Requirements:**
- All proto requirements met
- Exported via `scripts/export-arc.sh`
- Reviewed by at least one other contributor

### Archived

**Directory:** `archived/`

Proposals that have been withdrawn, superseded, or are no longer actively pursued. Archiving preserves history without cluttering active directories.

## Transitions

```
  ┌──────────┐     ┌──────────┐     ┌───────────┐
  │  Draft   │────▶│  Proto   │────▶│ Submitted │
  └──────────┘     └──────────┘     └───────────┘
       │                │                  │
       └───────┬────────┴──────────────────┘
               ▼
        ┌────────────┐
        │  Archived  │
        └────────────┘
```

Any stage can move to Archived. Only forward promotion is supported for active proposals (draft to proto to submitted).

## Tooling

| Action | Command |
|--------|---------|
| Create draft | `cp templates/draft.md drafts/my-idea.md` |
| Promote | `./scripts/promote.sh <source> <target-stage>` |
| Validate | `./scripts/validate.sh` |
| Export | `./scripts/export-arc.sh <proto-file>` |
