//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski. All rights reserved.
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
