import Foundation

public struct TopicSection: Decodable, Sendable {
    public let title: String
    public let identifiers: [String]
}
