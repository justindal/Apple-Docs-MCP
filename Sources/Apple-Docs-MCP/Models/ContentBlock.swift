import Foundation

public struct ContentBlock: Decodable, Sendable {
    public let type: String
    public let text: String?
    public let inlineContent: [InlineContent]?
    public let code: [String]?
    public let syntax: String?
    public let references: [String: Reference]?

    public func markdown(using references: [String: Reference]?) -> String {
        switch type {
        case "heading":
            return "### \(text ?? "Section")"
        case "paragraph":
            //            return inlineContent?.map { $0.text }.joined(separator: "") ?? ""
            return inlineContent?.map { $0.markdown(using: references) }.joined(
                separator: ""
            ) ?? ""
        case "codeListing":
            let codeBlock = code?.joined(separator: "\n") ?? ""
            return "```\(syntax ?? "swift")\n\(codeBlock)\n```"
        default:
            return ""
        }
    }
}
