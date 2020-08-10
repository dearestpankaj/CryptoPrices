//
//  CryptoService.swift
//  CryptoPrice Viewer
//
//  Created by Pankaj Sachdeva on 08/08/20.
//  Copyright © 2020 Pankaj Sachdeva. All rights reserved.
//

import Foundation
import Combine

final class CryptoService {
    var urlComponents: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.coinranking.com"
        components.path = "/v1/public/coins"
        components.queryItems = [URLQueryItem(name: "base", value: "USD"), URLQueryItem(name: "timePeriod", value: "24h")]
        return components
    }
    
    func fetchCoins() -> AnyPublisher<CryptoDataContainer, Error> {
        return URLSession.shared.dataTaskPublisher(for: urlComponents.url!)
            .map{$0.data}
            .decode(type: CryptoDataContainer.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

struct CryptoDataContainer: Decodable {
    let status: String
    let data: CryptoData
    
}

struct CryptoData: Decodable {
    let coins: [Coin]
}

struct Coin: Decodable, Hashable {
    let name: String
    let price: String
}
