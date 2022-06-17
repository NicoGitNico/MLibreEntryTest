//
//  HomeViewSearchBar.swift
//  MarketLibre
//
//  Created by Nicolas Di Santi on 12/6/22.
//

import SwiftUI

struct HomeViewSearchBar: View {
    
    @Binding var searchText:String
    var onSearch:() -> ()
    
    var body: some View {
        HStack{
            Spacer()
            TextField("Que tenés ganas de buscar?", text: $searchText)
                .textFieldStyle(.roundedBorder)
                .accessibilityLabel("SearchText")
                
            Button {
                onSearch()
            } label: {
                Text("Buscar").foregroundColor(.blue)
            }.accessibilityLabel("Search")
            Spacer()
        }.background(.clear)
    }
    
}
