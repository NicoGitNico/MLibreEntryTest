//
//  ProductView.swift
//  MarketLibre
//
//  Created by Nicolas Di Santi on 12/6/22.
//

import SwiftUI

struct ProductView: View {
    
    @StateObject var viewModel:ProductViewModel
    
    var body: some View {
        VStack{
            switch (viewModel.viewState) {
            case.loading:
                ProgressView()
            case.error(let string):
                Text(string)
            case.showingFullScreenImage:
                ZStack {
                    VStack (alignment: .trailing) {
                        Button {
                            viewModel.toogleZoomedImage()
                        } label: {
                            Image(systemName: "xmark.circle")
                        }
                        
                        if let image = viewModel.zoomedImage {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                        Spacer()
                    }
                }
            case .ready:
                ContentView(viewModel: viewModel)
            }
        }
    }
}


struct ContentView : View {
    
    var viewModel:ProductViewModel
    
    var body: some View {
        Text(viewModel.infoRows.first?.value ?? "")
            .padding()
        ScrollView(.horizontal) {
            HStack(alignment:.center) {
                ForEach(viewModel.images, id: \.id) { image in
                    AsyncImage(withURL: image.string, size: 90) { image in
                        viewModel.zoomedImage = image
                        viewModel.toogleZoomedImage()
                    }
                    .border(.gray, width: 1)
                    .padding()
                    .accessibilityLabel("ProductPicture")
                }
            }.padding()
        }
        List() {
            ForEach(viewModel.infoRows, id: \.id) { row in
                HStack (alignment: .center){
                    Text(row.name + ":")
                    Spacer()
                    Text(row.value ?? "")
                }.padding(1)
            }
        }.listStyle(.plain)
        .shadow(color: .black, radius: 3, x: 0, y: -5 )
    }
}
