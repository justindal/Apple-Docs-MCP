# Apple-Docs-MCP

A (Model Context Protocol) server that fetches and formats Apple Developer Documentation.

## Run locally

```bash
swift build
swift run Apple-Docs-MCP
```

## Example client configuration

Point the client at the built executable. For example:

```json
{
  "mcpServers": {
    "apple-docs": {
      "command": "Apple-Docs-MCP"
    }
  }
}
```

## Tools

### `listFrameworks`

Returns the list of supported frameworks (based on the `Framework` enum).

### `getDocumentation`

Input:
- `path` (string): either a framework name like `swiftui`, or a topic path like `swiftui/text` or `uikit/uiview`.

Output:
- Markdown for the topic, including a topics list when available.

### `symbolSearch`

Input:
- `framework` (string): e.g. `swiftui`
- `query` (string): e.g. `scrollview`

Output:
- Up to 20 matches from the framework’s reference index.



