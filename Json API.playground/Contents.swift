import Foundation

let fetch = FetchAPI()

fetch.fetchMagicCards { cards, error in
    if let error = error {
        print("Error fetching Magic cards: \(error.localizedDescription)")
    } else if let cards = cards {
        for card in cards {
            print("Имя карты: \(card.name)")
            print("Тип: \(card.type)")
            if let manaCost = card.manaCost {
                print("Мановая стоимость: \(manaCost)")
            } else {
                print("Мановая стоимость: N/A")
            }
            print("Название сета: \(card.setName)")
            print("---")
        }
    }
}

