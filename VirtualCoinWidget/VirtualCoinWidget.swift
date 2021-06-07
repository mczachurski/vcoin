//
//  VirtualCoinWidget.swift
//  VirtualCoinWidget
//
//  Created by Marcin Czachurski on 06/06/2021.
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
