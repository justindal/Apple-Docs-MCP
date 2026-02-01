import Foundation

public protocol HTTPDataDownloader: Sendable {
    func getData(from url: URL) async throws -> Data
}

/// HTTPDataDownloader configuration.
extension URLSession: HTTPDataDownloader {

    /// Get data from given URL.
    /// - parameter url: link to get data from.
    /// - Returns: the Data object.
    /// - Throws: ``ClientError.networkError`` if the request fails.
    public func getData(from url: URL) async throws -> Data {
        let validStatus = 200...299
        var req = URLRequest(url: url)
        req.setValue(
            "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)",
            forHTTPHeaderField: "User-Agent"
        )

        let (data, response) = try await self.data(for: req)

        guard let http = response as? HTTPURLResponse else {
            throw ClientError.networkError
        }

        guard validStatus.contains(http.statusCode) else {
            throw ClientError.httpError(statusCode: http.statusCode)
        }

        return data
    }
}
