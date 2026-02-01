import Foundation

enum Endpoints {
    /// Base URL for Apple docs JSON.
    static let baseJSONDataURL = URL(
        string: "https://developer.apple.com/tutorials/data/documentation/"
    )!

    /// The URL for the JSON data for a given topic.
    /// - parameter path: the path to the topic.
    /// - Returns: the URL for the JSON data.
    static func topicJSONURL(path: String) -> URL? {
        let clean = path.lowercased().trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        let sanitized = clean.hasPrefix("/") ? String(clean.dropFirst()) : clean
        guard !sanitized.isEmpty else { return nil }
        return
            baseJSONDataURL
            .appending(path: sanitized)
            .appendingPathExtension("json")
    }
}
