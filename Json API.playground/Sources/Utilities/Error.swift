import Foundation

enum MagicAPIError: Error {
    case invalidResponse
    case invalidStatusCode(Int)
    case networkError(Error)
    case dataNotReceived
    case decodingError(Error)
}
