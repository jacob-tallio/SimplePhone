//
//  SimpleWidget.swift
//  SimpleWidget
//
//  Created by Jacob Tallio on 2025-10-15.
//

import WidgetKit
import SwiftUI

struct SimpleWidgetEntry: TimelineEntry {
    let date: Date
}

struct SimpleWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleWidgetEntry {
        SimpleWidgetEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleWidgetEntry) -> Void) {
        completion(SimpleWidgetEntry(date: Date()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleWidgetEntry>) -> Void) {
        let entry = SimpleWidgetEntry(date: Date())
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
}

struct AppShortcut: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let urlScheme: String
}

struct SimpleWidgetEntryView: View {
    var entry: SimpleWidgetEntry
    
    let apps: [AppShortcut] = [
        .init(name: "Phone", icon: "phone.fill", urlScheme: "tel://"),
        .init(name: "Messages", icon: "message.fill", urlScheme: "sms://"),
        .init(name: "Mail", icon: "envelope.fill", urlScheme: "mailto://"),
        .init(name: "Maps", icon: "map.fill", urlScheme: "maps://")
    ]
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 8) {
                // Digital clock
                Text(entry.date, style: .time)
                    .font(.system(size: 28, weight: .light, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.bottom, 6)
                
                // App grid
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    ForEach(apps) { app in
                        Link(destination: URL(string: app.urlScheme)!) {
                            VStack(spacing: 4) {
                                Image(systemName: app.icon)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.white)
                                Text(app.name.uppercased())
                                    .font(.system(size: 10, weight: .semibold, design: .rounded))
                                    .foregroundColor(.white.opacity(0.8))
                                    .tracking(0.5)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding(8)
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(12)
                        }
                    }
                }
                .padding(.horizontal, 10)
            }
            .padding()
        }
    }
}

struct SimpleWidget: Widget {
    let kind: String = "SimpleWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: SimpleWidgetProvider()) { entry in
            SimpleWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("SimpleWidget")
        .description("A minimalist dumbphone-style launcher widget.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge, .systemExtraLarge])
    }
}
