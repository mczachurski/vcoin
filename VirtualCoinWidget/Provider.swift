//
//  Provider.swift
//  VirtualCoinWidgetExtension
//
//  Created by Marcin Czachurski on 07/06/2021.
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
        let entry: WidgetEntry

        if context.isPreview {
            entry = WidgetEntry(date: Date(), viewModels: PreviewData.getWidgetViewModels())
        } else {
            entry = WidgetEntry(date: Date(), viewModels: PreviewData.getWidgetViewModels())
        }
        
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [WidgetEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = WidgetEntry(date: entryDate, viewModels: PreviewData.getWidgetViewModels())
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}
