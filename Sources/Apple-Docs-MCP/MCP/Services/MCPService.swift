import Logging
import MCP
import ServiceLifecycle

/// An MCP service to handle server start and shutdown.
struct MCPService: Service {
    let server: Server
    let transport: Transport

    init(transport: Transport, server: Server) {
        self.transport = transport
        self.server = server
    }

    /// Start the server.
    ///
    /// This runs forever.
    func run() async throws {
        try await server.start(transport: transport)
        for await _ in AsyncStream<Never>.makeStream().stream {}
    }

    /// Gracefully shutdown the server.
    func shutdown() async throws {
        await server.stop()
    }
}
