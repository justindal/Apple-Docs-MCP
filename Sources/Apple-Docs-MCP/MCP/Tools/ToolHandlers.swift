import Foundation
import MCP

enum ToolHandlers {
    static func listTools() -> ListTools.Result {
        .init(tools: Toolbox.allTools)
    }

    static func callTool(
        _ params: CallTool.Parameters,
        docs: DocumentationClient
    ) async -> CallTool.Result {
        switch params.name {
        case Toolbox.listFrameworksTool.name:
            return listFrameworks()

        case Toolbox.getDocumentationTool.name:
            return await getDocumentation(params: params, docs: docs)

        case Toolbox.symbolSearchTool.name:
            return await symbolSearch(params: params, docs: docs)

        default:
            return .init(content: [.text("Unknown tool")], isError: true)
        }
    }

    private static func listFrameworks() -> CallTool.Result {
        let names = Framework.allCases.map(\.rawValue)
        return CallTool.Result(content: [
            .text(names.joined(separator: ", "))
        ])
    }

    private static func getDocumentation(
        params: CallTool.Parameters,
        docs: DocumentationClient
    ) async -> CallTool.Result {
        guard let arg = params.arguments?["path"]?.stringValue else {
            return CallTool.Result(
                content: [.text("Missing 'path' argument")],
                isError: true
            )
        }

        let cleanPath = arg.lowercased().trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        do {
            let topic: Topic

            if let framework = Framework(rawValue: cleanPath) {
                topic = try await docs.fetch(framework: framework)
            } else {
                let sanitized =
                    cleanPath.hasPrefix("/")
                    ? String(cleanPath.dropFirst()) : cleanPath

                guard let url = Endpoints.topicJSONURL(path: sanitized) else {
                    return CallTool.Result(
                        content: [
                            .text("Invalid URL path construction.")
                        ],
                        isError: true
                    )
                }

                topic = try await docs.fetch(url: url)
            }

            return CallTool.Result(content: [.text(topic.markdown)])

        } catch {
            return CallTool.Result(
                content: [
                    .text(
                        "Failed to fetch documentation for '\(cleanPath)': \(error)"
                    )
                ],
                isError: true
            )
        }
    }

    private static func symbolSearch(
        params: CallTool.Parameters,
        docs: DocumentationClient
    ) async -> CallTool.Result {
        guard
            let query = params.arguments?["query"]?.stringValue,
            let frameworkName = params.arguments?["framework"]?.stringValue,
            let framework = Framework(rawValue: frameworkName.lowercased())
        else {
            return CallTool.Result(
                content: [
                    .text("Missing 'query' or valid 'framework'")
                ],
                isError: true
            )
        }

        do {
            let rootTopic = try await docs.fetch(framework: framework)

            guard let refs = rootTopic.references else {
                return CallTool.Result(content: [
                    .text("No references found in \(frameworkName)")
                ])
            }

            let matches = SymbolSearch.search(query: query, in: refs.values)

            if matches.isEmpty {
                return CallTool.Result(content: [
                    .text(
                        "No symbols found matching '\(query)' in \(frameworkName)."
                    )
                ])
            }

            let resultLines = matches.compactMap { ref -> String? in
                guard let title = ref.title, let url = ref.url else {
                    return nil
                }

                return "- [\(title)](\(url))"
            }

            return CallTool.Result(content: [
                .text(
                    "Found \(matches.count) matches:\n"
                        + resultLines.joined(separator: "\n")
                )
            ])

        } catch {
            return CallTool.Result(
                content: [.text("Search failed: \(error)")],
                isError: true
            )
        }
    }
}
