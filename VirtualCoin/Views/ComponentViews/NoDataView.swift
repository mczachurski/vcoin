//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//
    

import SwiftUI

struct NoDataView: View {
    var title: String
    var subtitle: String
    var action: (() -> Void)?

    @State var opacity: CGFloat = 0
    
    public init(title: String, subtitle: String) {
        self.title = title
        self.subtitle = subtitle
    }
    
    public init(title: String, subtitle: String, action: @escaping () -> Void) {
        self.title = title
        self.subtitle = subtitle
        self.action = action
    }
    
    var body: some View {
        VStack {
            Text(title)
                .font(.title)
                .foregroundColor(.gray)
            
            if let action = self.action {
                Button(action: action, label: {
                    Text(subtitle)
                        .foregroundColor(Color.white)
                        .padding()
                })
                .frame(height: 40)
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(Color.main)
                )
            } else {
                Text(subtitle)
                    .foregroundColor(.gray)
            }
        }
        .opacity(self.opacity)
        .animate {
            self.opacity = 1
        }
    }
}

struct NoDataView_Previews: PreviewProvider {
    static var previews: some View {
        NoDataView(title: "No data", subtitle: "Please add new favourite") {
        }
    }
}
