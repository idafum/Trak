# Feature: Subjects (CLI)

## Summary
Build CLI support for managing subjects beyond creation: list, rename, and delete.

## Subfeature issues
- [ ] [Subjects: List subjects (CLI)](subjects-list-subjects-cli.md)
- [ ] [Subjects: Rename subject (CLI)](subjects-rename-subject-cli.md)
- [ ] [Subjects: Delete subject (CLI)](subjects-delete-subject-cli.md)

## Command examples
```bash
$ trak subject list
```
Expected output snippet:
```
Subjects:
- Swift
- Cybersecurity
- Systems Design
```

```bash
$ trak subject rename "Swift" "SwiftUI"
```
Expected output snippet:
```
Renamed subject "Swift" -> "SwiftUI".
```

```bash
$ trak subject delete "Cybersecurity"
```
Expected output snippet:
```
Deleted subject "Cybersecurity".
```

## Error handling (exit codes/messages)
- Exit code `1`: Invalid arguments or missing required subject name(s). Message: `Invalid arguments. See --help for usage.`
- Exit code `2`: Subject not found. Message: `Subject "<name>" not found.`
- Exit code `3`: Target subject already exists (rename). Message: `Subject "<name>" already exists.`
- Exit code `4`: Storage or filesystem error. Message: `Failed to update subjects: <details>`
