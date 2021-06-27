//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: TimelineProvider {
    typealias Entry = WidgetEntry

    func placeholder(in context: Context) -> WidgetEntry {
        return WidgetEntry(date: Date(), viewModels: PreviewData.getWidgetViewModels())
    }

    func getSnapshot(in context: Context, completion: @escaping (WidgetEntry) -> ()) {
        let entry = WidgetEntry(date: Date(), viewModels: PreviewData.getWidgetViewModels())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        let dataFetcher = DataFetcher()
        dataFetcher.getCoins { widgetViewModelsResult in
            var entries: [WidgetEntry] = []
            let currentDate = Date()

            switch widgetViewModelsResult {
            case .success(let widgetViewModels):
                entries.append(WidgetEntry(date: currentDate, viewModels: widgetViewModels))
                break
            case .failure:
                break
            }
            
            let nextUpdateDate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)!
            let timeline = Timeline(entries: entries, policy: .after(nextUpdateDate))
            completion(timeline)
        }
    }
}
