//
//  AsyncImage.swift
//  nes
//
//  Created by Minho Choi on 2020/03/25.
//  Copyright © 2020 Minho Choi. All rights reserved.
//

import SwiftUI
import Combine
import Foundation

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    private var cancellable: AnyCancellable?
    deinit {
        cancellable?.cancel()
    }
    
    func load() {
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data)}
        .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
        
    }
    func cancel() {
        cancellable?.cancel()
    }
}

struct AsyncImage<Placeholder: View>: View {
    @ObservedObject private var loader: ImageLoader
    private let placeholder: Placeholder?
    
    init(url: URL, placeholder: Placeholder? = nil) {
        loader = ImageLoader(url: url)
        self.placeholder = placeholder
    }
    var body: some View {
        image
            .onAppear(perform: loader.load)
            .onDisappear(perform: loader.cancel)
    }
    
    private var image: some View {
        Group {
            if loader.image != nil {
                Image(uiImage: loader.image!)
                    .resizable()
            }
            else {
                placeholder
            }
        }
    }
}

