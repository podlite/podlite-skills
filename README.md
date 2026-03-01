<div align="center">

[![Podlite](https://github.com/podlite/podlite-specs/raw/main/assets/podlite_logo_256x256.png)](https://podlite.org)

</div>

# Podlite Skills

Teach your AI agent to write Podlite. Works with Claude Code, Codex CLI, Cursor, GitHub Copilot, and anything that supports [Agent Skills](https://agentskills.io).

## Skills

| Skill | Description |
|-------|-------------|
| [podlite-markup](skills/podlite-markup/SKILL.md) | Create and edit Podlite markup — docs, specs, ideas, structured content |

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

## What is Podlite?

Podlite is a markup language that reads like Markdown but has real structure — block boundaries, typed attributes, inline formatting. Think Markdown that machines can actually parse.

```raku
=begin pod :type('page') :tags<tutorial>
=TITLE My Document

=head1 Introduction

Podlite is B<readable> like Markdown but I<structured> like YAML.

=item Human-friendly syntax
=item Machine-parseable attributes with C<:key<value>>
=item Inline formatting: B<bold>, I<italic>, C<code>, L<links|https://podlite.org>

=begin table :caption('Format Comparison')
  Format   | Human | Machine | Attributes
  ---------|-------|---------|------------
  Markdown | +++   | +       | -
  YAML     | +     | +++     | +++
  Podlite  | +++   | +++     | +++
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
