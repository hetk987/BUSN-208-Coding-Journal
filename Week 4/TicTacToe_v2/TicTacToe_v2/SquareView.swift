//
//  SquareView.swift
//  TicTacToe_v2
//
//  Created by Het Koradia on 2/24/25.
//

import SwiftUI

struct SquareView: View {
    @EnvironmentObject var game:GameService
    let index:Int
    
    var body: some View {
        Button {
            game.makeMove(at: index)
        } label: {
            game.gameBoard[index].image
                .resizable()
                .frame(width: 100, height: 100)
        }
        .disabled(game.gameBoard[index].player != nil)
        .buttonStyle(.bordered)
        .foregroundColor(.primary)

    }
}

#Preview {
    SquareView(index:1)
        .environmentObject(GameService())
}
