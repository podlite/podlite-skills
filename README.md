<div align="center">

[![Podlite](https://github.com/podlite/podlite-skills/raw/main/assets/podlite_logo_ai_256x256.png)](https://podlite.org)

</div>

# Podlite Skills

> One grammar, one AST. Your Markdown parses in unchanged — and when something regenerates the doc, the break Markdown swallows silently becomes a **line-located error**, equally legible to a person and to an agent.

[![GitHub Stars](https://img.shields.io/github/stars/podlite/podlite-skills?style=social)](https://github.com/podlite/podlite-skills)

Works with [Claude Code](https://claude.ai/code), [Codex CLI](https://github.com/openai/codex), [Cursor](https://cursor.sh), [GitHub Copilot](https://github.com/features/copilot), and [35+ agents](https://skills.sh):

```bash
npx skills add podlite/podlite-skills
```

## Why

Markdown has **no single spec-defined canonical AST** — CommonMark deliberately defines none. So two parsers can disagree on the tree, and typed attributes have nowhere to live. When an agent regenerates a document between sessions, a dropped block boundary or broken nesting becomes a *silent* diff you only notice later.

Podlite ships **one canonical grammar and one AST**, so that class of breakage surfaces as a line-located error instead of vanishing into a re-render.

This is *not* "a markup with a real parser" — `remark`/`mdast` is a real typed AST too. The difference is **one** canonical, spec-defined tree with stable block boundaries and typed attributes — not a tree your toolchain happens to pick.

Honest trade: Markdown wins on ubiquity and tooling. Podlite wins when structure has to **survive regeneration** by an agent.

## See it (runnable, ~10s)

Don't take the claim — run the parser on your own machine:

```bash
npm i @podlite/schema
node -e "const {parse}=require('@podlite/schema'); console.dir(parse('=head1 Hello World'), {depth:5})"
```

Every node comes back with its `type`, `name`, `level`, and a `location: { line, column }`. That's the whole point: a structural break points at a line, it doesn't disappear.

Convert back out with `toHtml` (full-fidelity) or `toMarkdown` (**best-effort** — typed attributes have no Markdown equivalent, so that structure is intentionally dropped; characterized, not silent).

## Skills

| Skill | Description |
|-------|-------------|
| [podlite-markup](skills/podlite-markup/SKILL.md) | Create and edit Podlite markup — docs, specs, ideas, structured content |
| [podlite-verify](skills/podlite-verify/SKILL.md) | Validate and self-check Podlite — catch unbalanced blocks, nested-angle attributes, list-nesting errors before delivering |

## Installation

### skills.sh (recommended)

One command, [35+ agents](https://skills.sh):

```bash
npx skills add podlite/podlite-skills
```

### Claude Code (manual)

```bash
cp -r skills/ /path/to/your/project/.claude/skills/
```

### Codex CLI

```bash
cp -r skills/ ~/.codex/skills/
```

### Other tools

Drop `SKILL.md` where your agent looks for skills. See [agentskills.io/specification](https://agentskills.io/specification).

## What Podlite looks like

Reads like Markdown; carries explicit boundaries and typed attributes:

```raku
=begin pod :type('page') :tags<tutorial>
=TITLE My Document

=head1 Introduction

Podlite is B<readable> like Markdown but I<structured> with typed attributes.

=item Human-friendly syntax
=item Machine-parseable attributes with C<:key<value>>
=item Inline formatting: B<bold>, I<italic>, C<code>, L<links|https://podlite.org>

=begin table :caption('Trade-offs, not a clean sweep')
  Format   | Ubiquity | Canonical AST
  ---------|----------|--------------------
  Markdown | +++      | none (by design)
  Podlite  | +        | one, spec-defined
=end table

=end pod
```

## Podlite Resources

<div align="center">
<table border=0><tr><td valign=top><div align="center">

##### specification

</div>

* [Source](https://github.com/podlite/podlite-specs)
* [in HTML](https://podlite.org/specification)
* [Discussions](https://github.com/podlite/podlite-specs/discussions)
* [Implementation](https://github.com/podlite/podlite)

</td><td valign=top><div align="center">

##### publishing system

</div>

* [Podlite-web](https://github.com/podlite/podlite-web)
* [How-to article](https://zahatski.com/2022/8/23/1/start-you-own-blog-site-with-podlite-for-web)

</td><td valign=top><div align="center">

##### desktop editor

</div>

* [Podlite-desktop](https://github.com/podlite/podlite-desktop)
* [Releases](https://github.com/podlite/podlite-desktop/releases)

</td><td valign=top><div align="center">

##### online resources

</div>

* [podlite.org](https://podlite.org)
* [pod6.in](https://pod6.in/)
* [github.com/podlite](https://github.com/podlite/)

</td></tr></table>
</div>

## Agent Skills

* [Agent Skills Specification](https://agentskills.io/specification)
* [skills.sh — marketplace](https://skills.sh)

## License

MIT
