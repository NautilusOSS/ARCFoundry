# Contributing to ARCFoundry

Thanks for your interest in contributing to ARCFoundry.

## How It Works

ARCFoundry is a pre-ARC standards incubator. Ideas start as drafts, mature into protos, and eventually get submitted as formal ARC proposals.

## Workflow

### 1. Start a Draft

Copy the draft template and write up your idea:

```bash
cp templates/draft.md drafts/your-idea.md
```

Drafts are informal. Focus on the problem, the proposed solution, and why it matters.

### 2. Promote to Proto

When your draft has enough substance, promote it:

```bash
./scripts/promote.sh drafts/your-idea.md proto
```

Protos require structured frontmatter (title, author, status, created date). The promotion script handles this.

### 3. Get Feedback

Open a pull request with your proto. Discussion happens in PR reviews. Iterate until the proposal is solid.

### 4. Export for ARC Submission

When ready for formal ARC submission:

```bash
./scripts/export-arc.sh proto/your-idea.md
```

The exported file lands in `exports/` formatted for the ARC process.

## Guidelines

- **One idea per file.** Keep proposals focused.
- **Use the templates.** They exist to keep things consistent.
- **Frontmatter matters.** Protos must have valid YAML frontmatter.
- **Be concise.** Shorter proposals that communicate clearly are better than long ones that don't.

## Pull Requests

- Keep PRs scoped to a single proposal or a single change.
- Include the proposal stage in your PR title, e.g. `[draft] Token-gated voting` or `[proto] Token-gated voting`.
- Run `./scripts/validate.sh` before opening a PR.

## Code of Conduct

Be respectful, constructive, and focused on building good standards.
