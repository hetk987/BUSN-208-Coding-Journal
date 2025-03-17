//
//  Cursor_DemoApp.swift
//  Cursor-Demo
//
//  Created by Het Koradia on 3/17/25.
//

import SwiftUI

@main
struct Cursor_DemoApp: App {
    @StateObject private var habitStore = HabitStore()
    
    var body: some Scene {
        WindowGroup {
            TabView {
                HabitListView()
                    .environmentObject(habitStore)
                    .tabItem {
                        Label("Habits", systemImage: "list.bullet")
                    }
                
                StatsView(habitStore: habitStore)
                    .tabItem {
                        Label("Stats", systemImage: "chart.bar.fill")
                    }
            }
        }
    }
}
