import Foundation

public struct Reference: Decodable, Sendable {
    public let title: String?
    public let url: String?
    public let kind: String?
}
