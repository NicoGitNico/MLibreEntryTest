//
//  AsyncImage.swift
//  MarketLibre
//
//  Created by Nicolas Di Santi on 11/6/22.
//
//https://stackoverflow.com/questions/60677622/how-to-display-image-from-a-url-in-swiftui

import Foundation
import Combine
import SwiftUI

var imageCache:[URL:Data] = [:]

final class ImageLoader: ObservableObject {
    var didChange = PassthroughSubject<Data, Never>()
    var url:URL
    var data = Data() {
        didSet {
            didChange.send(data)
        }
    }

    init(urlString:URL) {
        url = urlString
        fetchImage()
    }
    
    func fetchImage() {
        guard imageCache[url] == nil else {
            self.data = imageCache[url]!
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let strongSelf = self else { return }
            guard let data = data else { return }
            imageCache[strongSelf.url] = data
            DispatchQueue.main.async {
                strongSelf.data = data
            }
        }
        task.resume()
    }
    
}

struct AsyncImage: View {
    @ObservedObject var imageLoader:ImageLoader
    
    @State var image:UIImage = UIImage()
    @State var loading:Bool = true
    var size:CGFloat?
    var onLoadedImagePressedAction: ((UIImage) -> ())?

    init(withURL url:URL, size:CGFloat? = nil, onPressedAction: ((UIImage) -> ())? = nil ) {
        imageLoader = ImageLoader(urlString: url)
        onLoadedImagePressedAction = onPressedAction
        self.size = size
    }

    var body: some View {
        ZStack {
            if loading {
                ProgressView()
            } else {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size ?? 44, height: size ?? 44)
                    .onTapGesture {
                        if onLoadedImagePressedAction != nil && !loading {
                            onLoadedImagePressedAction!(self.image)
                        }
                    }       
            }
        }.onReceive(imageLoader.didChange) { data in
            self.image = UIImage(data: data) ?? UIImage()
            self.loading = false
        }.onAppear {
            imageLoader.fetchImage()
        }
    }
}
