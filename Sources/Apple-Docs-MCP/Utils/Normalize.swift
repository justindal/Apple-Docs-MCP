import Foundation

/// Clean up the search input.
///
/// This function keeps the string lowercase and removes diacritics.
///
/// - parameter input: the input string to clean up.
/// - Returns: the cleaned up String.
func normalizedSearch(_ input: String) -> String {
    let folded = input.folding(
        options: [.caseInsensitive, .diacriticInsensitive],
        locale: .current
    )
    return String(
        folded.unicodeScalars.filter { CharacterSet.alphanumerics.contains($0) }
    )
}
