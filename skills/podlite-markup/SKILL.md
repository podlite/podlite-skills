---
name: podlite-markup
description: Create and edit Podlite markup files. Use when working with .podlite files, or when the user mentions Podlite, formatting codes, declarative blocks, structured markup for documentation, or AI agent instructions.
license: MIT
metadata:
  author: podlite
  version: "1.0.0"
---

# Podlite Markup

Podlite is a lightweight markup language for documentation, knowledge bases, and structured content. It extends Markdown concepts with explicit block boundaries, typed attributes, and rich inline formatting.

- **Extension:** `.podlite`
- **Document root:** `=begin pod ... =end pod`
- **Every directive** starts with `=` as first non-whitespace on its line
- **Full specification:** https://podlite.org/specification

## Block forms

Every block type supports three equivalent forms:

```
=head1 Title                                    abbreviated (one line)

=for head1 :attr<val>                           paragraph (content until blank line)
Title text

=begin head1 :attr<val>                         delimited (explicit =end)
Title text
=end head1
```

## Block types

| Block | Purpose | Example |
|-------|---------|---------|
| `=head1`..`=head4` | Headings | `=head1 Introduction` |
| `=para` | Explicit paragraph | `=begin para :tags<ai>` |
| `=item` | List item (`=item` = `=item1`) | `=item First point` |
| `=item1`/`=item2`/`=item3` | Nested lists (no level skip) | `=item2 Sub-point` |
| `=code` | Code block (verbatim) | `=begin code :lang<js>` |
| `=table` | Data table | `=begin table :caption('Title')` |
| `=comment` | Not rendered | `=begin comment` |
| `=nested` | Indented/nested content | `=begin nested :notify<warning>` |
| `=picture` | Image | `=picture diagram.png` |
| `=defn` | Definition | `=defn Term` |
| `=toc` | Table of contents | `=toc head1, head2` |
| `=include` | Include file | `=include file:./other.podlite` |
| `=formula` | Math formula | `=begin formula` |
| `=input`/`=output` | Pre-formatted I/O | `=begin input` |

**Semantic blocks** (UPPERCASE): `=TITLE`, `=DESCRIPTION`, `=AUTHOR`, `=VERSION`, `=CHANGES`, `=TODO`

**Custom blocks** (mixed-case): `=Image`, `=Diagram`, `=Mermaid`, `=Markdown`

## Inline formatting codes

| Code | Purpose | Example |
|------|---------|---------|
| `B<>` | Bold | `B<important>` |
| `I<>` | Italic | `I<emphasis>` |
| `U<>` | Underline | `U<unusual>` |
| `C<>` | Inline code | `C<variable>` |
| `O<>` | Strikethrough | `O<removed>` |
| `K<>` | Keyboard input | `K<Ctrl+S>` |
| `T<>` | Terminal output | `T<OK>` |
| `R<>` | Replaceable | `R<filename>` |
| `H<>` | Superscript | `H<2>` |
| `J<>` | Subscript | `J<n>` |
| `N<>` | Footnote | `N<See appendix>` |
| `D<>` | Definition | `D<term>` |
| `V<>` | Verbatim | `V<no B<markup>>` |
| `Z<>` | Zero-width comment | `Z<hidden note>` |
| `E<>` | Entity/emoji | `E<0xA9>` `E<:smile:>` |
| `L<>` | Link | `L<text\|https://url>` |

**Links:** `L<text|https://url>` `L<text|file:./path>` `L<text|#section-id>` `L<#id>`

**Escape angles:** `C<< $x<5> >>` or `C« $x<5> »`

**Nesting:** `B<I<bold italic>>`

## Attributes

Attributes go on any block after the type name:

```
:key                       boolean true
:!key                      boolean false
:key<value>                string
:key<val1 val2>            list (space-separated)
:key('value with spaces')  quoted string
:key(42)                   number
```

**Common attributes:**

| Attribute | Purpose | Used with |
|-----------|---------|-----------|
| `:id<ID>` | Block identifier for linking | Any block |
| `:caption('Title')` | Caption | `=table`, `=picture` |
| `:lang<python>` | Programming language | `=code` |
| `:allow<B I E>` | Allow markup in verbatim | `=code` |
| `:tags<t1,t2>` | Categorization tags | `=para`, `=pod` |
| `:numbered` | Ordered list/heading | `=item`, `=head` |
| `:checked` / `:!checked` | Task list checkbox | `=item` |
| `:notify<warning>` | Notification type (note/warning/info/error) | `=nested` |
| `:folded` | Collapsed by default | Any block |

## Tables

```podlite
=begin table :caption('API Endpoints')
  Method   | Endpoint     | Auth
  ---------|--------------|----------
  GET      | /api/users   | Bearer
  POST     | /api/users   | Admin
  DELETE   | /api/users   | Admin
=end table
```

Column separators: `|` or 2+ spaces. Row separators: `-`, `=`, `_` lines.

Inline formatting works in cells: `B<bold>`, `C<code>`, `L<link|url>`.

## Config directive

Pre-set attributes for all blocks of a type:

```podlite
=config code :lang<typescript>
=config head1 :numbered
```

## Rules

- Indented text in `=pod`/`=item`/`=nested` becomes an implicit code block
- Blank line separates paragraphs
- `=item1` → `=item2` → `=item3` for nesting (sequential, no skipping levels)
- Podlite natively supports Markdown: `.md` files are parsed in Markdown mode

## Complete examples

### Article with sections, code, and table

```podlite
=begin pod :type('page') :tags<tutorial,podlite>
=TITLE Getting Started with Podlite

=begin DESCRIPTION
A quick introduction to Podlite markup language.
=end DESCRIPTION

=toc head1, head2

=head1 Introduction

Podlite is a B<lightweight> markup language designed for both
I<humans> and I<machines>. See the L<full spec|https://podlite.org/specification>.

=head2 Lists

=item First item
=item Second item with C<inline code>
=item1 Nested level 1
  =item2 Sub-item

=head2 Code

=begin code :lang<javascript>
function hello() {
  console.log("Hello, Podlite!");
}
=end code

=head2 Comparison

=begin table :caption('Format Comparison')
  Format     | Human-readable | Machine-readable
  -----------|----------------|------------------
  Markdown   | +++            | +
  YAML       | +              | +++
  Podlite    | +++            | +++
=end table

=end pod
```

### Task list with notifications

```podlite
=head1 Setup Checklist

=item :checked Install Node.js
=item :checked Clone repository
=item :!checked Configure C<.env> file
=item :!checked Run C<npm test>

=begin nested :notify<warning>
B<Breaking change in v2.0:> Configuration migrated from YAML to Podlite.
Run C<podlite-migrate> before upgrading.
=end nested
```

### Structured idea (IdeaLab format)

```podlite
=begin idea :id<PERF-rendering> :status<new> :affects<axona>
=TITLE Optimize Graph Rendering with WebGL

=MOTIVATION
Canvas 2D bottleneck at 500+ nodes. WebGL enables 10K+ smooth rendering.

=CONTEXT
=item Current: Canvas 2D, 15 fps at 1K nodes
=item Target: WebGL shaders, 60 fps at 10K nodes

=QUESTIONS
=item WebGL context loss on mobile — acceptable?
=item Bundle size impact of WebGL dependencies?
=end idea
```

## References

- [Podlite Specification](https://podlite.org/specification)
- [Podlite GitHub](https://github.com/podlite)
- [Podlite Desktop](https://github.com/podlite/podlite-desktop) (Microsoft Store)
