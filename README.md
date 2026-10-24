<div align="center">

[![Podlite](https://github.com/podlite/podlite-skills/raw/main/assets/podlite_logo_ai_256x256.png)](https://podlite.org)

</div>

# Podlite Skills

> Teach your agent to write Podlite, then check it with the parser.

Install for your agent; [skills.sh](https://skills.sh) lists the agents its installer supports:

```bash
npx skills add podlite/podlite-skills
```

## Why

CommonMark specifies how Markdown is parsed, but its conformance tests compare HTML output, not trees. Each parser builds its own tree format, and there is no syntax for typed attributes. When an agent regenerates a document between sessions, a dropped block boundary or broken nesting becomes a *silent* diff you only notice later.

Podlite has one specification and one reference parser, [`@podlite/schema`](https://www.npmjs.com/package/@podlite/schema). Every tool built on it sees the same tree, and `podlite lint` reports this kind of breakage with a line number instead of letting it vanish into a re-render.

## See it (runnable, ~10s)

Run the parser:

```bash
npm i @podlite/schema
node -e "const {parse}=require('@podlite/schema'); console.dir(parse('=head1 Hello World'), {depth:5})"
```

Each block comes back with its `type`, `location.start` and `location.end`. A heading also carries its `name` and `level`.

Convert back out with `toHtml` (full-fidelity) or `toMarkdown`. `toMarkdown` writes Markdown. Attributes without a Markdown form, such as `:status<draft>`, are left out; a code block keeps its language.

## Check that your agent calls the parser

Paste this into your agent:

```
Use the podlite MCP server to parse the document below. Tell me, for every
block: its type, its level if it has one, and the line it starts on. Name the
tool you called.

=head1 Setup

Install the thing.

=head2 Windows
```

The parser answers: `head` at line 1, level 1; a paragraph at line 3; `head` at line 5, level 2. The MCP server setup is on [podlite.org/for-agents](https://podlite.org/for-agents).

## Edit, then check

An agent leaves a table open; `podlite lint` reports the line and exits with code 1; after the fix, `podlite query` selects a block by name and attribute. Files, commands and real output: [examples/edit-and-check](examples/edit-and-check/).

## Skills

| Skill | Description |
|-------|-------------|
| [podlite-markup](skills/podlite-markup/SKILL.md) | Create and edit Podlite markup — docs, specs, ideas, structured content |
| [podlite-verify](skills/podlite-verify/SKILL.md) | Validate and self-check Podlite — catch unbalanced blocks, nested-angle attributes, list-nesting errors before delivering |

## Installation

### skills.sh (recommended)

One command; [skills.sh](https://skills.sh) lists the agents its installer supports:

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
