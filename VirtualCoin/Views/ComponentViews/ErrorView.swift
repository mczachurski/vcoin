//
//  ErrorView.swift
//  VirtualCoin
//
//  Created by Marcin Czachurski on 20/05/2021.
//

import SwiftUI

struct ErrorView: View {
    public var error: Error
    public var refreshAction: (() -> Void)?
        
    var body: some View {
        VStack {
            Text("ERROR: \(error.localizedDescription)")
            if let action = refreshAction {
                Button("Refresh", action: action)
            }
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    
    enum PreviewError: Error {
        case unknown
    }
    
    static var previews: some View {
        ErrorView(error: PreviewError.unknown)
            .previewLayout(.fixed(width: 360, height: 200))
    }
}
