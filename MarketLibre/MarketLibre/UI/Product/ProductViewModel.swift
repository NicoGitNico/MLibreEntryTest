//
//  ProductViewModel.swift
//  MarketLibre
//
//  Created by Nicolas Di Santi on 12/6/22.
//

import Foundation
import UIKit

struct ItemPictureViewObject : Identifiable {
    let id:UUID = UUID()
    var string:URL
}

struct ItemAttributeViewObject {
    var name:String
    var value:String?
}

struct ItemLocationViewObject {
    var city:ItemValueViewObject
    var state:ItemValueViewObject
    var country:ItemValueViewObject
}

struct ItemValueViewObject{
    var name:String
}

struct ProductInfoRow : Identifiable {
    let id: UUID = UUID()
    let name:String
    let value: String?
}


final class ProductViewModel : ObservableObject {
    
    enum ViewState {
        case loading
        case showingFullScreenImage
        case ready
        case error(String)
    }
    
    let productId:String
    
    @Published var viewState:ProductViewModel.ViewState = .loading
    @Published var images:[ItemPictureViewObject] = []
    @Published var infoRows:[ProductInfoRow] = []
    @Published var zoomedImage:UIImage? = nil
    
    init(pId:String) {
        self.productId = pId
        ProductsRepository.getItem(itemId: productId) {[unowned self] items in
            
            if let data = items.first?.body {
                images = data.pictures.map{ ItemPictureViewObject(string: URL(string: $0.secure_url)!) }
                processProductIntoRows(product: data)
                self.viewState = .ready
            } else {
                self.viewState = .error("Error interpretando respuesta del servidor")
            }
        } onError: { [unowned self] e in
            self.viewState = .error("Error obteniendo detalles del producto")
        }
    }
    
    private func appendNonEmptyRow(_ row:ProductInfoRow){
        guard let _ = row.value else { return }
        infoRows.append(row)
    }
    
    private func processProductIntoRows(product:ItemBody) {
        
        appendNonEmptyRow(ProductInfoRow(name: "Titulo", value: product.title))
        appendNonEmptyRow(ProductInfoRow(name: "Subtitulo", value: product.subtitle))
        appendNonEmptyRow(ProductInfoRow(name: "# Disponibles", value: String(product.available_quantity)))
        appendNonEmptyRow(ProductInfoRow(name: "# Vendidos", value: String(product.sold_quantity)))
        appendNonEmptyRow(ProductInfoRow(name: "Condición", value: product.condition))
        appendNonEmptyRow(ProductInfoRow(name: "Garantía", value: product.warranty))
        
        let address = product.seller_address
        let composeFullAddress = [address.state.name, address.city.name, address.country.name].joined(separator: ", ")
        appendNonEmptyRow(ProductInfoRow(name: "Ubicación", value: composeFullAddress ))
        
        product.attributes.forEach { [unowned self] att in
            self.appendNonEmptyRow(ProductInfoRow(name: att.name, value: att.value_name ))
        }
    }
    
    func toogleZoomedImage() {
        if case .showingFullScreenImage = viewState  {
            viewState = .ready
        } else {
            viewState = .showingFullScreenImage
        }
    }
}
