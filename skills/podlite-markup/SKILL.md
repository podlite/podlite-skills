---
name: podlite-markup
description: Create and edit Podlite markup files. Use when working with .podlite files, or when the user mentions Podlite, formatting codes, declarative blocks, structured markup for documentation, or AI agent instructions.
license: MIT
metadata:
  author: podlite
  version: "2.0.0"
---

# Podlite Markup

Podlite is a lightweight markup language for documentation, knowledge bases, and structured content. It extends Markdown concepts with explicit block boundaries, typed attributes, and rich inline formatting.

- **Extension:** `.podlite`
- **Document root:** optional; the specification wraps a `.podlite` file in `=pod` implicitly
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
| `=data-table` | Render CSV/TSV (inline, `:src<file:…>`, or `:src<data:…>`) | `=for data-table :src<file:./planets.csv>` |
| `=comment` | Not rendered | `=begin comment` |
| `=nested` | Indented/nested content | `=begin nested :notice<warning>` |
| `=picture` | Image | `=picture diagram.png` |
| `=defn` | Definition | `=defn Term` |
| `=toc` | Table of contents | `=toc head1, head2` |
| `=include` | Include external content (directive) | `=include file:./other.podlite` |
| `=boundary` | Structural section divider (chapters/parts) | `=boundary :caption('End of Part I')` |
| `=formula` | Math formula | `=begin formula` |
| `=input`/`=output` | Pre-formatted I/O | `=begin input` |

**Semantic blocks** (UPPERCASE): `=TITLE`, `=DESCRIPTION`, `=AUTHOR`, `=VERSION`, `=CHANGES`, `=TODO`

**Custom blocks** (mixed-case): `=Diagram`, `=Mermaid`, `=Markdown`. Images use `=picture`.

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
| `G<>` | Guard (concealed in production output) | `G<sk-12345>` |
| `E<>` | Entity/emoji | `E<0xA9>` `E<:smile:>` |
| `L<>` | Link | `L<text\|https://url>` |
| `W<>` | Contextual backlink | `W<term\|defn:term>` |
| `X<>` | Index entry | `X<text\|entry,subentry>` |
| `P<>` | Inline picture | `P<file:./chart.png>` |
| `F<>` | Mathematical formula | `F<x^2 + y^2>` |
| `M<>` | Module-defined code | `M<scheme:contents>` |
| `A<>` | Macro or object contents | `A<macro-name>` |
| `S<>` | Preserved spaces | `S<keep   these>` |

**Links:** `L<text|https://url>` `L<text|file:./path>` `L<text|#section-id>` `L<#id>`

**Escape angles:** `C<< $x<5> >>` or `C« $x<5> »`

**Nesting:** `B<I<bold italic>>`

## Attributes

Attributes go on any block after the type name:

```
:key                       boolean true
:!key                      boolean false
:key<value>                string
:key<val1 val2>            list of words (spaces separate, commas do not)
:key('value with spaces')  quoted string
:key<'value with spaces'>  quoted string in angle brackets
:key(42)                   number
:key('a','b')              list, comma-separated
:key{:a<x>, :b(42), :c}    map, option form (`:c` alone is true, `:!c` is false)
:key{a=>1, b=>'x'}         map, arrow form
:key<>  :key()             empty list
:key{}                     empty map
```

A single word in `<…>` keeps its text: `:key<1>` is the string `1`, `:key<True>` is the string `True`. A number needs `:key(42)`, a boolean needs `:key` or `:key(True)`.

**Common attributes:**

| Attribute | Purpose | Used with |
|-----------|---------|-----------|
| `:id<ID>` | Block identifier for linking | Any block |
| `:caption('Title')` | Title for the block | any block |
| `:lang<python>` | Programming language | `=code` |
| `:allow<B I E>` | Allow markup in verbatim | `=code` |
| `:tags<t1 t2>` | Categorization tags | `=para`, `=pod` |
| `:numbered` | Ordered list/heading | `=item`, `=head` |
| `:checked` / `:!checked` | Task list checkbox | `=item` |
| `:notice<warning>` | Notification type (note/tip/important/warning/caution) | `=nested` |
| `:folded` | Collapsed by default | Any block |
| `:masked` | Conceal block content in production output (pairs with `G<>`) | Any block |
| `:src<URI>` | Source: `file:`, `data:`, `http:`/`https:`, `doc:` | `=data-table`, `=include` |
| `:columns<a b>` | Ordered column projection (names or 1-based indices) | `=data-table` |
| `:rename{k=>'v'}` | Display name overrides for projected columns | `=data-table` |
| `:mime-type('text/csv; header=present')` | MIME type + RFC 6838 parameters; `header=present\|absent` for CSV/TSV | `=data`, `=data-table`, `=include` |

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

## `=set` — attribute assignment to next block

Like `=config`, but targets **a single block instance** rather than all blocks of a type. Two syntaxes — config-style and alias-style (multiline with inline markup).

```podlite
=set :caption('Quarterly revenue') :id<table-q1>
=begin table
...
=end table
```

Alias syntax supports multiline values and inline formatting:

```podlite
=set :caption Selected B<chemical> elements with their
=               L<atomic numbers|#elements> and symbols
=begin table
...
=end table
```

Precedence: explicit block attributes > `=set` > `=config` defaults. Transparent to intervening directives (`=config`, `=alias`, `=include`, `=boundary`, `=comment`); applies to the **next non-directive block**. With `=include`, applies to the first block of the included content.

## Content masking — `G<>` and `:masked`

Marks content as **guarded** (concealed in published output, preserved in source/document model). Two render modes: production (default — masked) and draft (visible).

```podlite
The password is G<hunter2> and must not be exposed.

=for para :masked
This whole paragraph is masked in production output.
```

- Mask character: renderer-defined, default `█` (U+2588)
- Guard propagates through `L<>`, `=include`, aliases, `data:` references
- Not active in `=code` by default — enable with `:allow<G>`
- **Not a security mechanism** — original text remains in source/VCS; use real encryption for secrets

## Rules

- Indented text in `=pod`/`=item`/`=nested` becomes an implicit code block
- Blank line separates paragraphs
- `=item1` → `=item2` → `=item3` for nesting: an `=item3` needs an `=item2` earlier in the same block
- Podlite natively supports Markdown: `.md` files are parsed in Markdown mode
- Markdown fenced code blocks accept Podlite attributes after the language identifier — `` ```python :line-numbers :highlight(2,'5-7') :caption<Example> ``
- A comma inside `<…>` is part of the value, not a separator — `:tags<a,b>` is the string `a,b`; a list needs spaces
- Guillemets are not quotation marks — `:caption<«Q1 sales»>` keeps the brackets inside the value; quote with `'…'`
- Inside `(…)` and `{…}` every string is quoted; a bare word is not a valid element, apart from `True` and `False`
- Square brackets are not a value form — a list is written `<a b>` or `('a','b')`, never `:key[a,b]`
- Attributes continue on a line starting with `=` in the first column and a space; a line starting with spaces is block content, and the attributes written on it are lost
- A value in `(…)` or `{…}` may continue on such a line; a value in `<…>` or in quotes ends with its line
- A value that cannot be read is dropped together with its attribute, the block itself parses on, and the parser reports the position

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

=begin nested :notice<warning>
B<Breaking change in v2.0:> Configuration migrated from YAML to Podlite.
Run C<podlite-migrate> before upgrading.
=end nested
```

### CSV rendering with `=data-table`

```podlite
=for data-table :src<file:./planets.csv>
=               :columns<name radius_km moons>
=               :rename{radius_km=>'Radius (km)'}
=               :caption('Inner planets')
```

Inline body form:

```podlite
=begin data-table :mime-type('text/csv; header=present')
name,age,city
Alice,30,London
Bob,25,Paris
=end data-table
```

Or referencing a `=data` block by key:

```podlite
=begin data :key<sales> :mime-type('text/csv; header=present')
quarter,region,revenue
Q1,EU,120
=end data

=for data-table :src<data:sales> :columns<quarter revenue>
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
