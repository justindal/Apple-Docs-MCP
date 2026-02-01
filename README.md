# Apple-Docs-MCP

A (Model Context Protocol) server that fetches and formats Apple Developer Documentation.

## Installation
### Homebrew

```bash
brew tap justindal/apple-docs-mcp
brew install apple-docs-mcp-server
```
The executable can be found in the `/opt/homebrew/Cellar/apple-docs-mcp-server/{VERSION}/bin` directory.

### Build from source

#### Prerequisites
- Swift 6.0+
- Xcode 16+
- macOS 13.0+

```bash
git clone https://github.com/justindal/Apple-Docs-MCP.git
cd Apple-Docs-MCP
swift build -c release
swift run Apple-Docs-MCP
```

The executable can be found in the `.build/release` directory.

## Example client configuration

Point the client at the built executable. For example:

```json
{
  "mcpServers": {
    "apple-docs": {
      "command": "/path/to/Apple-Docs-MCP"
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

## Acknowledgements:
- [Apple Developer Documentation](https://developer.apple.com/documentation)
- [Model Context Protocol](https://github.com/modelcontextprotocol/swift-sdk)
- [Swift Service Lifecycle](https://github.com/swift-server/swift-service-lifecycle)