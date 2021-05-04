//
//  ThirdPartyView.swift
//  VirtualCoin
//
//  Created by Marcin Czachurski on 04/05/2021.
//

import SwiftUI

struct ThirdPartyView: View {
    var body: some View {
        List {
            VStack(alignment: .leading) {
                Link("https://coincap.io",
                     destination: URL(string: "https://coincap.io")!)
                Spacer()
                Text("API for cryptocurrency pricing.")
                    .font(.footnote)
            }
            
            VStack(alignment: .leading)  {
                Link("https://github.com/pichukov/LightChart",
                     destination: URL(string: "https://github.com/pichukov/LightChart")!)
                Spacer()
                Text("Lightweight SwiftUI package with line charts implementation.")
                    .font(.footnote)
            }
            
            VStack(alignment: .leading)  {
                Link("https://github.com/dmytro-anokhin/url-image",
                     destination: URL(string: "https://github.com/dmytro-anokhin/url-image")!)
                Spacer()
                Text("SwiftUI view that displays an image downloaded from provided URL. ")
                    .font(.footnote)
            }
        }
        .navigationBarTitle(Text("Third party"), displayMode: .inline)
    }
}

struct ThirdPartyView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ThirdPartyView()
        }
    }
}
