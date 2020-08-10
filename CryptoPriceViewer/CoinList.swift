//
//  ContentView.swift
//  CryptoPrice Viewer
//
//  Created by Pankaj Sachdeva on 08/08/20.
//  Copyright © 2020 Pankaj Sachdeva. All rights reserved.
//

import SwiftUI
import Combine

struct CoinList: View {
    @ObservedObject private var viewModel = CoinListViewModel()
    
    var body: some View {
        ZStack(alignment: .center) {
            NavigationView {
            List(viewModel.coinViewModel, id: \.self) { coinViewModel in
                Text(coinViewModel.displayText)
            }.onAppear {
                self.viewModel.fetchCoins()
                }.navigationBarTitle("Crypto Prices")
            }
            ActivityIndicator(isAnimating: .constant(self.viewModel.loading), style: .large, color: .gray)
        }
    }
}

struct CoinList_Previews: PreviewProvider {
    static var previews: some View {
        CoinList()
    }
}

class CoinListViewModel: ObservableObject {
    private let cryptoService = CryptoService()
    @Published var coinViewModel = [CoinViewModel]()
    @Published var loading = true
    var cancellable: AnyCancellable?
    
    func fetchCoins() {
        cancellable = cryptoService.fetchCoins().sink(receiveCompletion: {_ in
            
        }, receiveValue: { cryptoContainer in
            self.coinViewModel = cryptoContainer.data.coins.map{
                CoinViewModel($0)
            }
            self.loading = false
        })
    }
}

struct CoinViewModel: Hashable {
    private let coin: Coin
    
    var name: String {
        return coin.name
    }
    
    var formattedPrice: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        guard let price = Double(coin.price), let formattedPrice = numberFormatter.string(from: NSNumber(value: price)) else {
            return ""
        }
        return formattedPrice
    }
    
    var displayText: String {
        return name + " - " + formattedPrice
    }
    
    init(_ coin: Coin) {
        self.coin = coin
    }
}


