//
//  HerbList.swift
//  FolkMedicine
//
//  Created by Minho Choi on 2020/04/18.
//  Copyright © 2020 Minho Choi. All rights reserved.
//

import SwiftUI


struct HerbRow: View {
    
    let item: herbItem

    var body: some View {
        
        HStack {
            AsyncImage(url: URL(string: item.thumbImgUrl)!, placeholder: Image(systemName: "photo")).scaledToFit()
            .clipShape(Circle())
            VStack(alignment: .leading) {
                HStack {
                    Text("\(item.korName)")
                    Spacer()
                    Text("\(item.sciName) ")
                    .italic()
                    .lineLimit(1)
                        .font(.custom("Didot", size: 12))
                        .minimumScaleFactor(0.5)
                    }
                Text("\(item.chnName)")
                    .foregroundColor(.gray)
            }
            Spacer()
        }.frame(height: 60)
    }
}

struct HerbRow_Previews: PreviewProvider {
    static var previews: some View {
        HerbRow(item: herbItem())
    }
}
