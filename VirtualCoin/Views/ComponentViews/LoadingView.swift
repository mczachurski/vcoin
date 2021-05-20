//
//  LoadingView.swift
//  VirtualCoin
//
//  Created by Marcin Czachurski on 20/05/2021.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            Spacer()
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
            Spacer()
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
            .previewLayout(.fixed(width: 32, height: 32))
    }
}
