import Foundation

public struct MagicCardApiResponse: Decodable {
    public let cards: [MagicCard]
}

public struct MagicCard: Decodable {
    public  let name: String
    public let type: String
    public let manaCost: String?
    public let setName: String
}
