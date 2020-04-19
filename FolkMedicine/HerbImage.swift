//
//  HerbImage.swift
//  FolkMedicine
//
//  Created by Minho Choi on 2020/04/19.
//  Copyright © 2020 Minho Choi. All rights reserved.
//

import SwiftUI

struct HerbImage: View {
    
    var herbData = herbDetail()
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                AsyncImage(url: URL(string: herbData.ImgUrl1)!, placeholder: Image(systemName: "photo")).scaledToFit().cornerRadius(10)
                AsyncImage(url: URL(string: herbData.ImgUrl2)!, placeholder: Image(systemName: "photo")).scaledToFit().cornerRadius(10)
            }.frame(height: 200)
        }
    }
}

struct HerbImage_Previews: PreviewProvider {
    static var previews: some View {
        HerbImage(herbData: herbDetail())
    }
}
