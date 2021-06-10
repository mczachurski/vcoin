//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski. All rights reserved.
//

import SwiftUI
import VirtualCoinKit

struct AppView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    @State private var selectedFolder: String? = "favourites"
    
    var body: some View {
        if horizontalSizeClass == .compact {
            TabsView()
        } else {
            NavigationView {
                SideBarsView(selectedFolder: $selectedFolder)
                Text("Primary view")
            }
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
