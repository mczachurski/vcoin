//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import Foundation
import SwiftUI

struct InitialsPlaceholder: View {
    var text: String

    var body: some View {
        ZStack {
            Circle()
                .strokeBorder(Color.main,lineWidth: 2)
                .background(Circle().foregroundColor(Color.main(opacity: 0.4)))
                .frame(width: 32, height: 32)
            Text(String(text.first ?? "?") )
                .foregroundColor(.white)
        }
    }
}

struct InitialsPlaceholder_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            InitialsPlaceholder(text: "Bitcoin")
                .preferredColorScheme(.dark)
            InitialsPlaceholder(text: "DegeCoin")
                .preferredColorScheme(.light)
        }
        .previewLayout(.fixed(width: 32, height: 32))
    }
}
