//
//  SwiftUIView.swift
//  FolkMedicine
//
//  Created by Minho Choi on 2020/04/19.
//  Copyright © 2020 Minho Choi. All rights reserved.
//

import SwiftUI

struct HerbDetail: View {
    
    var herbData = herbDetail()
    
    var body: some View {
        
        ScrollView {
            VStack(alignment: .leading, spacing: 5) {
                HStack(alignment: .firstTextBaseline) {
                    Text("\(herbData.korName)").font(.largeTitle)
                    Text("\(herbData.sciName)").font(.custom("Didot", size: 18))
                        .italic()
                        .minimumScaleFactor(0.6)
                }

                Rectangle().frame(height: 1).foregroundColor(.black)
                VStack(alignment: .leading) {
                Text("생약명 : \(herbData.chnName)")
                Text("이용 부위 : \(herbData.useRegn)")
                }.font(.headline).foregroundColor(.gray)
                
                HerbImage(herbData: herbData)
                    .padding(.bottom, 10)
                
                Text("형태").bold().font(.system(size: 20))
                Rectangle().frame(height: 1).foregroundColor(.gray)
                Text("\(herbData.stle)")
                    .padding(.bottom, 10)
                
                Text("민간 요법").bold().font(.system(size: 20))
                Rectangle().frame(height: 1).foregroundColor(.gray)
                Text("\(herbData.therapy)")

            }.padding(10)
        }
    }
}

struct HerbDetail_Previews: PreviewProvider {
    static var previews: some View {
        HerbDetail(herbData: herbDetail())
    }
}

