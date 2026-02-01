import Foundation

public enum ClientError: Error {
    case invalidURL
    case networkError
    case httpError(statusCode: Int)
    case decodingError(Error)
}
