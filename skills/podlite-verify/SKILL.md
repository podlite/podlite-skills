---
name: podlite-verify
description: Validate, lint, and self-check Podlite markup. Use after generating or editing .podlite files, when asked to verify/validate/lint/check Podlite, or to catch structural errors (unbalanced =begin/=end, attribute syntax, nested angles, list nesting) before delivering output.
license: MIT
metadata:
  author: podlite
  version: "1.0.0"
---

# Podlite Verify

AI-generated markup drifts: unbalanced blocks, broken nesting, attribute values that swallow the next token. Podlite is structured, so most of these are **mechanically checkable**. Verify before delivering.

Run two layers: (1) **self-check** the output against the rules below (always available, no tooling), then (2) **machine-validate** with the parser/linter when it is available.

- **Companion skill:** `podlite-markup` (how to write it)
- **Specification:** https://podlite.org/specification

## When to verify

- Immediately after generating or editing any `.podlite` / `.pod6` content, before presenting it
- When the user asks to validate, lint, check, or fix Podlite
- When a renderer or parser reports an error
- Before committing Podlite to a repository or knowledge base

## Layer 1: self-check rules (no tooling required)

Read the produced markup and confirm each invariant. These are the errors LLMs introduce most often.

| # | Check | Wrong | Right |
|---|-------|-------|-------|
| 1 | **Every `=begin X` has a matching `=end X`** with the same typename | `=begin code … =end pod` | `=begin code … =end code` |
| 2 | **Balanced block nesting**: inner blocks close before outer | `=begin pod =begin code =end pod` | `=begin pod =begin code =end code =end pod` |
| 3 | **List levels are sequential**: no skipping | `=item1` → `=item3` | `=item1` → `=item2` → `=item3` |
| 4 | **Attribute values with spaces are quoted** | `:caption<Q1 sales>` | `:caption('Q1 sales')` or `:caption("Q1 sales")` |
| 5 | **No raw `<`/`>` inside `:attr<…>`**: an inner `>` closes the attribute early | `:caption<See L<x\|y>>` | `:caption('See L<x\|y>')` |
| 6 | **Formatting codes are balanced** | `B<bold I<italic>` | `B<bold I<italic>>` |
| 7 | **Content containing `>` uses doubled delimiters** | `C<$x > 5>` | `C<< $x > 5 >>` or `C« $x > 5 »` |
| 8 | **Blank line separates paragraphs / terminates `=for` and abbreviated blocks** | two paragraphs glued | blank line between |
| 9 | **Full documents have a `=begin pod … =end pod` root** (or a top-level `=begin pod`) | content with no root | wrapped in `=pod` |
| 10 | **Indentation is intentional**: indented text inside `=pod`/`=item`/`=nested` becomes an implicit code block | accidental 4-space indent | flush-left prose |
| 11 | **Block casing matches role**: lowercase standard (`=head1`), UPPERCASE semantic (`=TITLE`), MixedCase custom (`=Image`) | `=image`, `=title` | `=Image`, `=TITLE` |
| 12 | **`=end` lines carry no attributes**: attributes belong on `=begin` only | `=end code :lang<js>` | `=end code` |
| 13 | **Markdown-fence attributes follow the language id** | ` ```:line-numbers python ` | ` ```python :line-numbers ` |
| 14 | **A continued attribute line starts with `=` and a space**: an indented one is content, and its attributes are lost | `=begin pod :type<x>`⏎`  :id<y>` | `=begin pod :type<x>`⏎`=  :id<y>` |
| 15 | **A list value separates on spaces, not commas**: a comma stays inside the value | `:columns<a,b,c>` is one name | `:columns<a b c>` or `:columns('a','b','c')` |
| 16 | **`=set` applies to the next block only**: it needs a block after it in the same scope | `=set` at end of document | `=set :caption('X')` followed by the block |
| 17 | **`G<>` conceals, it does not delete**: guarded text stays in the source and reaches anyone who reads the file | secrets inside `G<>` | secrets outside the document |
| 18 | **`:mime-type` carries its parameters**: CSV and TSV need the header state | `:mime-type<text/csv>` | `:mime-type<'text/csv; header=present'>` |

### The nested-angle trap (most common, most silent)

The single most frequent break: a `>` inside an angle-bracket attribute value. The parser closes `:key<…>` at the **first** `>`, so the rest leaks into the render and metadata is corrupted.

```
WRONG:  =for data-table :caption<Revenue > 100>
RIGHT:  =for data-table :caption('Revenue > 100')

WRONG:  :content-snippet<See B<bold> note>
RIGHT:  :content-snippet('See bold note')      # strip inner codes, or quote
```

Rule: if an attribute value contains `<`, `>`, or inline formatting codes, use the **parenthesised-quote form** `:key('…')`.

## Layer 2: machine validation (when tooling is available)

If Podlite tooling is present, parse the source. A failed parse or a reported problem means the markup is invalid. A clean run (empty problem list, exit 0) means the tools found nothing. It does not cover every Layer 1 rule: a skipped list level, for example, passes the linter. Keep the self-check.

**CLI (canonical):** the lint subcommand reports structural and syntax problems; the rule set is growing. Check #5 has a dedicated `attr-nested-angle` rule (error): it reports both a nested `<…>` pair and a bare `>` that closes an angle-delimited value early. An attribute the parser had to drop surfaces through `attr-value-dropped` (warning), and one written on an indented continuation line through `attr-continuation-dropped` (warning).

```bash
podlite lint --format json --strict path/to/file.podlite
```

**Programmatic (Node):** `@podlite/schema` exports `parse` and `validatePodliteAst`; use them in a build or CI step to fail on malformed input. Treat a thrown parse error or reported validation problems as a failure.

**Playground (no install):** paste into https://pod6.in/ . If it renders with the intended structure, the parse succeeded.

If no tool is available, do not claim validation ran. Report that only the Layer-1 self-check was applied.

## Verify procedure

1. **Self-check** the output against Layer-1 rules; fix every violation found.
2. **Machine-validate** with `podlite lint` (or `@podlite/schema` `parse`) if available.
3. **Read the reported errors**: fix the first error first; cascading errors often resolve together.
4. **Re-validate** until the parse is clean (zero problems).
5. **Round-trip check** (optional): render via pod6.in or `@podlite/to-jsx` and confirm the structure matches intent: headings nest correctly, tables have the right columns, no stray text from a swallowed attribute.
6. **Report honestly**: state which layers ran ("self-check + schema validation: clean" vs "self-check only, no parser available").

## Quick self-audit example

Given generated markup, scan top to bottom:

```podlite
=begin pod :type('page')
=TITLE Release Notes

=begin table :caption<Changes since v1.0>      ← #4: value has spaces, quote it
  Version | Note
  --------|------
  2.0     | Adds C<=data-table>
=end table

=item1 First
=item3 Third                                    ← #3 level skip: insert =item2 or demote to =item2
=end pod
```

Fixes: quote the caption (`:caption('Changes since v1.0')`, habitual safety), and repair the list level. Then validate.

## References

- [Podlite Specification](https://podlite.org/specification)
- [Podlite GitHub](https://github.com/podlite)
- Companion: `podlite-markup` skill (authoring)
