//
//  VirtualCoinWidgetEntryView.swift
//  VirtualCoinWidgetExtension
//
//  Created by Marcin Czachurski on 07/06/2021.
//

import WidgetKit
import SwiftUI

struct VirtualCoinWidgetEntryView : View {
    @Environment(\.widgetFamily) var family: WidgetFamily

    var entry: Provider.Entry
    
    @ViewBuilder
    var body: some View {
        switch family {
        case .systemSmall: SmallWidgetView(viewModels: entry.viewModels)
        case .systemMedium: MediumWidgetView(viewModels: entry.viewModels)
        case .systemLarge: LargeWidgetView(viewModels: entry.viewModels)
        default: Text("Define favourites")
        }
    }
}
