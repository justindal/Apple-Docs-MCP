import Foundation
import Logging
import MCP
import ServiceLifecycle

@main
struct Apple_Docs_MCP {
    static func main() async {
        var serviceGroup: ServiceGroup
        LoggingSystem.bootstrap(StreamLogHandler.standardError)
        let logger = Logger(label: "Apple-Docs-MCP")
        let transport = StdioTransport(logger: logger)

        let docs = DocumentationClient()
        let mcp = Server(
            name: "Apple Documentation MCP",
            version: "1.0.0",
            capabilities: .init(
                tools: .init(listChanged: true)
            )
        )
        let mcpService = MCPService(transport: transport, server: mcp)

        await mcp.withMethodHandler(ListTools.self) { _ in
            return ToolHandlers.listTools()
        }

        await mcp.withMethodHandler(CallTool.self) { params in
            return await ToolHandlers.callTool(params, docs: docs)
        }

        serviceGroup = ServiceGroup(
            services: [mcpService],
            gracefulShutdownSignals: [.sigterm, .sigint],
            logger: logger
        )

        do {
            logger.info("Starting service...")
            try await serviceGroup.run()
        } catch {
            logger.error("Service failed: \(String(describing: error))")
        }
    }
}
