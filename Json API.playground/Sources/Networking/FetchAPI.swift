import Foundation

public class FetchAPI {
    
    public init() {}
    
    public func fetchMagicCards(completion: @escaping ([MagicCard]?, Error?) -> Void) {
        
        let optUrl = URL(string: "https://api.magicthegathering.io/v1/cards?name=Opt")!
        let lotusUrl = URL(string: "https://api.magicthegathering.io/v1/cards?name=Black%20Lotus")!

        let urls = [optUrl, lotusUrl]
        let group = DispatchGroup()
        var cards: [MagicCard] = []
        var errors: [Error] = []
        for url in urls {
            group.enter()
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                defer { group.leave() }
                if let error = error {
                    errors.append(MagicAPIError.networkError(error))
                    return
                }
                guard let response = response as? HTTPURLResponse else {
                    errors.append(MagicAPIError.invalidResponse)
                    return
                }
                switch response.statusCode {
                case 200...299:
                    break
                case 429:
                    // Слишком много запросов: пользователь отправил слишком много запросов за заданный промежуток времени.Подождите несколько секунд и повторите запрос.
                    DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
                        URLSession.shared.dataTask(with: url).resume()
                    }
                    return
                case 500...599:
                    //Ошибка сервера: повторите попытку позже
                    errors.append(MagicAPIError.invalidStatusCode(response.statusCode))
                    return
                default:
                    errors.append(MagicAPIError.invalidStatusCode(response.statusCode))
                    return
                }
                guard let data = data else {
                    errors.append(MagicAPIError.dataNotReceived)
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(MagicCardApiResponse.self, from: data)
                    cards.append(contentsOf: response.cards)
                } catch let error {
                    errors.append(MagicAPIError.decodingError(error))
                }
            }
            task.resume()
        }
        group.notify(queue: DispatchQueue.main) {
            if errors.isEmpty {
                completion(cards, nil)
            } else {
                completion(nil, errors.first)
            }
        }
    }
}
