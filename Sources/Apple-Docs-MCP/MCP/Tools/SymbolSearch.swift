import Foundation

struct ScoredRef {
    let ref: Reference
    let score: Int
}

enum SymbolSearch {
    static func search(
        query: String,
        in references: some Sequence<Reference>,
        limit: Int = 20
    ) -> [Reference] {
        let rawQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        let normalizedQuery = normalizedSearch(rawQuery)

        func score(ref: Reference) -> Int {
            var score = 0

            if let title = ref.title {
                if title.localizedCaseInsensitiveContains(rawQuery) {
                    score += 3
                }
                if normalizedSearch(title).contains(normalizedQuery) {
                    score += 2
                }
            }

            if let url = ref.url {
                if url.localizedCaseInsensitiveContains(rawQuery) { score += 2 }
                if normalizedSearch(url).contains(normalizedQuery) {
                    score += 2
                }
            }

            return score
        }

        return
            references
            .map { ref in ScoredRef(ref: ref, score: score(ref: ref)) }
            .filter { $0.score > 0 }
            .sorted {
                if $0.score != $1.score { return $0.score > $1.score }
                return ($0.ref.url?.count ?? 0) < ($1.ref.url?.count ?? 0)
            }
            .prefix(limit)
            .map(\.ref)
    }
}
