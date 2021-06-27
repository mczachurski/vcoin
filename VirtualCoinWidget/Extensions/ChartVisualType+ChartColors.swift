//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//
    
import SwiftUI
import LightChart

extension ChartVisualType {
    static var red: ChartVisualType {
        get {
            ChartVisualType.customFilled(color: .redPastel,
                                         lineWidth: 2,
                                         fillGradient: LinearGradient(gradient: .init(colors: [.redPastel.opacity(0.3), .redPastel.opacity(0.01)]),
                                                                      startPoint: .init(x: 0.5, y: 1),
                                                                      endPoint: .init(x: 0.5, y: 0)))
        }
    }
    
    static var green: ChartVisualType {
        get {
            ChartVisualType.customFilled(color: .greenPastel,
                                         lineWidth: 2,
                                         fillGradient: LinearGradient(gradient: .init(colors: [.greenPastel.opacity(0.3), .greenPastel.opacity(0.01)]),
                                                                      startPoint: .init(x: 0.5, y: 1),
                                                                      endPoint: .init(x: 0.5, y: 0)))
        }
    }
}
