import Foundation

/// Decoded Framework/Topic object.
public struct Topic: Decodable, Sendable {
    public let metadata: Metadata
    public let abstract: [InlineContent]?
    public let primaryContentSections: [Section]?
    public let topicSections: [TopicSection]?
    public let references: [String: Reference]?

    public var markdown: String {
        var output = [String]()
        output.append("# \(metadata.title)")

        if let abstract = abstract {
            //            let text = abstract.map { $0.text }.joined(separator: "")
            let text = abstract.map { $0.markdown(using: references) }.joined(
                separator: ""
            )
            output.append("> \(text)")
        }

        if let sections = primaryContentSections {
            for section in sections {
                output.append(section.markdown(using: references))
            }
        }

        if let sections = topicSections, let refs = references {
            output.append("\n## Topics")
            for section in sections {
                output.append("\n### \(section.title)")
                for identifier in section.identifiers {
                    if let ref = refs[identifier], let title = ref.title,
                        let url = ref.url
                    {
                        output.append("- [\(title)](\(url))")
                    }
                }
            }
        }

        return output.joined(separator: "\n")
    }

}
