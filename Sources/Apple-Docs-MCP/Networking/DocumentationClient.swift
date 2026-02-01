import Foundation

/// Client to fetch documentation and parse the response into markdown format.
public actor DocumentationClient {
    private let decoder: JSONDecoder
    private let session: HTTPDataDownloader

    public init(session: HTTPDataDownloader? = nil) {
        if let session = session {
            self.session = session
        } else {
            let config = URLSessionConfiguration.default
            config.urlCache = URLCache(
                memoryCapacity: (1024 * 1024 * 100),
                diskCapacity: (1024 * 1024 * 100)
            )
            self.session = URLSession(configuration: config)
        }
        self.decoder = JSONDecoder()
    }

    /// Get Framework/Topic documentation given a Framework.
    /// - parameter framework: the Framework to search for.
    /// - Returns: the parsed Topic object.
    /// - Throws: ``ClientError.invalidURL`` if the URL is invalid.
    public func fetch(framework: Framework) async throws -> Topic {
        guard let url = framework.jsonURL else {
            throw ClientError.invalidURL
        }
        return try await fetch(url: url)
    }

    /// Get Topic information from the URL and create into a Topic object.
    /// - parameter url: the URL to get information from.
    /// - Returns: the created Topic object.
    /// - Throws: ``ClientError.decodingError`` if the data could not be decoded.
    public func fetch(url: URL) async throws -> Topic {
        let data = try await self.session.getData(from: url)

        do {
            return try decoder.decode(Topic.self, from: data)
        } catch {
            throw ClientError.decodingError(error)
        }
    }
}
