import MCP

/// The available tools of the MCP.
public struct Toolbox {
    public static let listFrameworksTool: Tool = Tool(
        name: "listFrameworks",
        description: "Returns a list of available Apple Frameworks.",
        inputSchema: ["type": "object", "properties": [:], "required": []]
    )

    public static let getDocumentationTool = Tool(
        name: "getDocumentation",
        description: "Fetches the documentation for a framework or topic.",
        inputSchema: [
            "type": "object",
            "properties": [
                "path": [
                    "type": "string",
                    "description":
                        "Fetches documentation. For frameworks use the name (e.g. 'swiftui'). For symbols, PREPEND the framework (e.g. 'swiftui/text', 'uikit/uiview').",
                ]
            ],
            "required": ["path"],
        ]
    )

    public static let symbolSearchTool = Tool(
        name: "symbolSearch",
        description: "Search for a symbol within a Framework.",
        inputSchema: [
            "type": "object",
            "properties": [
                "query": [
                    "type": "string",
                    "description":
                        "The term to search for (e.g. 'scrollview').",
                ],
                "framework": [
                    "type": "string",
                    "description":
                        "The framework to search in (e.g. 'swiftui').",
                ],
            ],
            "required": ["query", "framework"],
        ]
    )

    public static let allTools: [Tool] = [
        listFrameworksTool,
        getDocumentationTool,
        symbolSearchTool,
    ]

}
