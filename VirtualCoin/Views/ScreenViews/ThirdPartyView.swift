//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
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
        Group {
            NavigationView {
                ThirdPartyView()
            }
            .preferredColorScheme(.dark)
            
            NavigationView {
                ThirdPartyView()
            }
            .preferredColorScheme(.light)
        }
    }
}
