//
//  HomeViewModel.swift
//  MarketLibre
//
//  Created by Nicolas Di Santi on 10/6/22.
//

import Foundation

final class HomeViewModel : ObservableObject {
    
    enum ViewState {
        case empty
        case loading
        case showingData
        case error
    }
    
    struct ProductViewObject : Identifiable {
        var id: String
        var title : String
        var price : Double
        var thumbnail: URL
    }
    
    @Published var viewState:HomeViewModel.ViewState = .empty
    @Published var products:[ProductViewObject] = []
    @Published var error:Error?
    
    func fetchProducts(searchQuery:String) {
        viewState = .loading
        ProductsRepository.search(value: searchQuery) { [unowned self] results in
            self.products = results.map {
                ProductViewObject(id: $0.id, title: $0.title, price: $0.price, thumbnail: $0.thumbnail)
            }
            viewState = .showingData
            
            
        } onError: { [unowned self] error in
            self.viewState = .error
        }

    }
}
