import Foundation

public struct Declaration: Decodable, Sendable {
    public let tokens: [Token]

    public struct Token: Decodable, Sendable {
        public let text: String
        public let kind: String
    }
}
