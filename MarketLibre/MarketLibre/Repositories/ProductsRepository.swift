//
//  ProductsRepository.swift
//  MarketLibre
//
//  Created by Nicolas Di Santi on 9/6/22.
//

import Foundation
import Alamofire


enum ServiceError: Error {
    case unSuccesfulResponse
    case parsingError
    case unexpected(description:String?)
}

struct ProductsRepository {
    
    private static let baseUrl:String = "https://api.mercadolibre.com"
    
    private static func buildSearchQuery(query:String) -> String{
        return "/sites/MLA/search?q=\(query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "" )"
    }
    
    private static func buildItemQuery(itemId:String) -> String{
        return "/items?ids=\(itemId)"
    }
    
    private static func doRequest<T:Codable>(requestParams:String, onSuccess : @escaping (T) -> (), onError : @escaping (Error) -> ()) {
        AF.request(self.baseUrl + requestParams, method: .get).response { response in
            if  response.response?.statusCode == 200 {
                let decoder = JSONDecoder()
                do {
                    if let realData = response.data {
                        let parsedData = try decoder.decode(T.self, from: realData)
                        onSuccess(parsedData)
                    } else {
                        onError(ServiceError.parsingError)
                    }
                } catch {
                    print (error)
                    onError(ServiceError.parsingError)
                }
            } else {
                onError(ServiceError.unSuccesfulResponse)
            }
        }
    }
    
    static func search(value:String, onSuccess : @escaping ([SearchResult]) -> (), onError : @escaping (Error) -> ()) {
        
        let successWrapped:(SearchResponse) -> () = { genericResponse in
            onSuccess(genericResponse.results)
        }
        
        doRequest(requestParams: buildSearchQuery(query: value), onSuccess: successWrapped, onError: onError)
    }
    
    static func getItem(itemId:String, onSuccess : @escaping ([ItemData]) -> (), onError : @escaping (Error) -> ()) {
        doRequest(requestParams: buildItemQuery(itemId: itemId), onSuccess: onSuccess, onError: onError)
    }
}
