# Edit, then check

An agent added a version table to [`notes.podlite`](notes.podlite) and left out `=end table`. This is the check to run after every edit:

```bash
npx -y podlite@0.0.91 lint notes.podlite; echo "exit code: $?"
```

```
notes.podlite:11:1: error: =begin table is not closed before end of file (delimited-block-balance)
notes.podlite:11:1: warning: Line could not be parsed as a directive or block: =begin table (syntax-valid)

1 file checked, 1 error, 1 warning
exit code: 1
```

A script or a CI step stops on that exit code.

Add `=end table` after line 14, as in [`notes-fixed.podlite`](notes-fixed.podlite), and run it again:

```bash
npx -y podlite@0.0.91 lint notes-fixed.podlite
```

```
1 file checked, 0 errors, 0 warnings
```

To find a block, select it by name and attribute instead of searching the text:

```bash
npx -y podlite@0.0.91 query 'code[:lang<python>]' notes-fixed.podlite
```

```
=begin code :lang<python>
import example
example.run()
=end code
1 match
```

With `--to json` the block comes with its attributes and its start and end position:

```bash
npx -y podlite@0.0.91 query 'code[:lang<python>]' notes-fixed.podlite --to json
```

```
    "name": "code",
    ...
    "config": [
      {
        "name": "lang",
        "value": "python",
        "type": "string"
      }
    ],
    "location": {
      "start": {
        "offset": 206,
        "line": 19,
        "column": 1
      },
      "end": {
        "offset": 271,
        "line": 23,
        "column": 1
```

(Excerpt; the full output is the whole block as JSON.)

The output above is from podlite 0.0.91. [`run.sh`](run.sh) runs the same commands.

## Ask your agent to do the same

```
After you edit a .podlite file, run `npx -y podlite lint <file>` and fix every
error before you reply. To find a block, use `npx -y podlite query '<selector>' <file>`
instead of searching the text.
```
