import Foundation

struct MagicCardApiResponse: Decodable {
    let cards: [MagicCard]
}

struct MagicCard: Decodable {
    let name: String
    let type: String
    let manaCost: String?
    let setName: String
}
