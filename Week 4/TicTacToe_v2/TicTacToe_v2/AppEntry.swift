//
//  TicTacToe_v2App.swift
//  TicTacToe_v2
//
//  Created by Het Koradia on 2/10/25.
//

import SwiftUI

@main
struct AppEntry: App {
    
    @StateObject var game = GameService();
    
    var body: some Scene {
        WindowGroup {
            StartView()
                .environmentObject(game)
        }
    }
}
