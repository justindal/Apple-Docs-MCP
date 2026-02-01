import Foundation

public struct Section: Decodable, Sendable {
    public let kind: String
    public let content: [ContentBlock]?
    public let declarations: [Declaration]?
    public let mentions: [String]?
    public let references: [String: Reference]?

    public func markdown(using references: [String: Reference]?) -> String {
        switch kind {
        case "declarations":
            guard let decls = declarations else { return "" }
            let code = decls.flatMap { $0.tokens }.map { $0.text }.joined(
                separator: ""
            )
            return "## Declaration\n```swift\n\(code)\n```"

        case "mentions":
            guard let ids = mentions, let refs = references else { return "" }
            //            let links = ids.compactMap { refs[$0] }.map {
            //                "- [\($0.title)](\($0.url))"
            //            }
            let links = ids.compactMap { id -> String? in
                guard let ref = refs[id], let title = ref.title,
                    let url = ref.url
                else { return nil }
                return "- [\(title)](\(url))"
            }

            if links.isEmpty { return "" }
            return "### Related\n\(links.joined(separator: "\n"))"

        case "content":
            guard let blocks = content else { return "" }
            return blocks.map { $0.markdown(using: references) }.joined(
                separator: "\n\n"
            )
        //            return blocks.map { $0.markdown }.joined(separator: "\n\n")

        default:
            return ""
        }
    }

}
