import Foundation

public struct InlineContent: Decodable, Sendable {
    public let type: String
    public let text: String
    public let identifier: String?

    enum CodingKeys: String, CodingKey {
        case type, text, code, identifier
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decode(String.self, forKey: .type)
        self.identifier = try? container.decode(
            String.self,
            forKey: .identifier
        )
        // text = try container.decode(String.self, forKey: .text)
        if let t = try? container.decode(String.self, forKey: .text) {
            self.text = t
        } else if let c = try? container.decode(String.self, forKey: .code) {
            self.text = "`\(c)`"
        } else {
            self.text = ""
        }
    }

    public func markdown(using references: [String: Reference]?) -> String {
        if type == "reference", let id = identifier, let ref = references?[id],
            let title = ref.title
        {
            if let url = ref.url {
                return "[\(title)](\(url))"
            } else {
                return title
            }
        }
        return text
    }
}
