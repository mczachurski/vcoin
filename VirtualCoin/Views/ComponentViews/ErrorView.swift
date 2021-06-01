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
            Image(systemName: "exclamationmark.triangle.fill")
                .resizable()
                .foregroundColor(.accentColor)
                .frame(width: 64, height: 64, alignment: .center)
                
            Text("\(error.localizedDescription)")
                .multilineTextAlignment(.center)
            if let action = refreshAction {
                Button("Refresh", action: action)
                    .padding(.top, 10)
            }
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    
    enum PreviewError: Error, LocalizedError {
        case unknown
        
        public var errorDescription: String? {
            switch self {
            case .unknown:
                return NSLocalizedString("Bad URL to coincap.io API.", comment: "")
            }
        }
    }
    
    static var previews: some View {
        ErrorView(error: PreviewError.unknown) {
        }
        .previewLayout(.fixed(width: 360, height: 200))
    }
}