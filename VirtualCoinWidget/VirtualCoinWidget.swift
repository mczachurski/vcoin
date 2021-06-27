//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import WidgetKit
import SwiftUI

@main
struct VirtualCoinWidget: Widget {
    let kind: String = "VirtualCoinWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            VirtualCoinWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Virtual coin")
        .description("Shows coin prices")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}
