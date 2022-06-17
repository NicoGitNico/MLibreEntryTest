//
//  Responses.swift
//  MarketLibre
//
//  Created by Nicolas Di Santi on 10/6/22.
//

import Foundation


struct SearchResponse: Codable {
    //var paging: SearchResutPagging
    var results: [SearchResult]
}

struct SearchResult: Codable {
    var id : String
    var title : String
    var price : Double
    var thumbnail: URL
}

struct SearchResutPagging: Codable {
    var total : Int
    var primary_results : Int
    var offset : Int
    var limit: Int
}

struct ItemsResponse: Codable {
    var body: ItemData
}

struct ItemData: Codable {
    var code:Int
    var body:ItemBody
}

struct ItemBody: Codable {
    var title: String
    var subtitle: String?
    var available_quantity:Int
    var sold_quantity:Int
    var condition:String
    var pictures:[ItemPicture]
    var accepts_mercadopago:Bool
    var seller_address:ItemLocation
    var warranty:String?
    var attributes:[ItemAttribute]
}

struct ItemPicture: Codable {
    var secure_url:String
}

struct ItemLocation: Codable {
    var city:ItemValue
    var state:ItemValue
    var country:ItemValue
}

struct ItemValue: Codable {
    var name:String
}

struct ItemAttribute: Codable {
    var name:String
    var value_name:String?
}
