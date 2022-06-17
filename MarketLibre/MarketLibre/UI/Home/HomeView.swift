//
//  ContentView.swift
//  MarketLibre
//
//  Created by Nicolas Di Santi on 9/6/22.
//

import SwiftUI

struct HomeView: View {
    
    @State var searchText:String = ""
    @StateObject var model = HomeViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                HomeViewSearchBar(searchText: $searchText) {
                    onSearchButtonPressed()
                }
                List {
                    switch (model.viewState) {
                    case .loading:
                        LoadingView()
                    case .showingData:
                        ForEach(model.products, id: \.id) { product in
                            NavigationLink {
                                ProductView(viewModel: ProductViewModel(pId: product.id))
                            } label: {
                                ProductCell(value: product)
                                    .padding(0)
                                    .accessibilityLabel("ProductCell")
                            }
                        }
                    case .empty:
                        HStack(alignment: .center) {
                            Spacer()
                            Image(systemName: "cart")
                            .resizable()
                                .frame(width: 50, height: 50, alignment: .center)

                            Spacer()
                        }
                    case .error:
                        ErrorView(error: model.error?.localizedDescription ?? "Error Desconocido")
                    }
                    
                }.listStyle(.plain)
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            }.background(.white)
            .navigationBarHidden(true)
        }
    }
    
    func onSearchButtonPressed() {
        model.fetchProducts(searchQuery: searchText)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

struct LoadingView: View {
    var body: some View {
        HStack (spacing: 10 ) {
            ProgressView()
            Text("Cargando.. por favor espere")
        }
    }
}

struct ErrorView: View {
    var error:String
    var body: some View {
        VStack{
            Image(systemName: "person.fill.xmark")
            Text(error)
        }
    }
}

struct ProductCell: View {
    
    let value:HomeViewModel.ProductViewObject
    
    var body: some View {
        HStack (spacing: 5) {
            AsyncImage(withURL: value.thumbnail)
                .frame(width: 50, height: 60)
            VStack(alignment: .leading) {
                Text("$ " + formatPrice(value: value.price))
                    .bold()
                Text(value.title)
                    .font(.system(size: 12))
                    .lineLimit(3)
            }
            
            Spacer()
        }.padding()
        
    }
}
