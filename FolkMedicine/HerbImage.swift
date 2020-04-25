//
//  HerbImage.swift
//  FolkMedicine
//
//  Created by Minho Choi on 2020/04/19.
//  Copyright © 2020 Minho Choi. All rights reserved.
//

import SwiftUI

struct HerbImage: View {
    
    var imgURL: [String]
    
    var body: some View {
        
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                ForEach(trimArray(inputArray: imgURL), id: \.self) { url in
                    AsyncImage(url: URL(string: url)!, placeholder: Image(systemName: "photo")).scaledToFit().cornerRadius(10)
                }
            }.frame(height: 200)
        }
    }
}

func trimArray(inputArray: [String]) -> [String] {
    
    var array: [String] = ["", "", "", "", "", ""]
    
    for i in 0...5 {
        if inputArray[5-i] == "0" {
            array.remove(at: 5-i)
        }
        else {
            array[5-i] = inputArray[5-i]
        }
    }
    return array
}
