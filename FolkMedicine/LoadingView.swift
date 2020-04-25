//
//  LoadingView.swift
//  FolkMedicine
//
//  Created by Minho Choi on 2020/04/25.
//  Copyright © 2020 Minho Choi. All rights reserved.
//

import SwiftUI

struct LoadingView: View {
    
    @State var rotation = 0.0
    @State private var size: Double = 4
    static var shouldAnimate = true

    var body: some View {
        ZStack {
            Color.white
                .edgesIgnoringSafeArea(.all)
            
            Image(systemName: "slowmo")
                .foregroundColor(Color.blue)
                .frame(width: 200, height: 200)
                .imageScale(.large)
                .scaleEffect(CGFloat(size))
                .animation(Animation.easeInOut(duration:1).delay(1).repeatForever(autoreverses: true))
                .rotationEffect(.degrees(rotation))
                .animation(Animation.easeInOut(duration:3 ).delay(0).repeatForever(autoreverses: false))
                .onAppear {
                    self.rotation += 1080
                    self.size = 4.8
            }
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
