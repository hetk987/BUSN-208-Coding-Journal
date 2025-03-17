//
//  GameView.swift
//  TicTacToe_v2
//
//  Created by Het Koradia on 2/24/25.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var game:GameService
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                if !game.player1.isTurn && !game.player2.isTurn {
                    Text("Select a player to start the game")
                }
                
                HStack {
                    Button(game.player1.name){
                        game.player1.isTurn = true
                        game.player2.isTurn = false
                        print(game.gameStart)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(RoundedRectangle(cornerRadius: 10)
                        .fill(game.player1.isTurn ? Color.green : Color.gray)
                    )
                    .foregroundColor(.white)
                    
                    
                    Button(game.player2.name){
                        game.player2.isTurn = true
                        game.player1.isTurn = false
                        print(game.gameStart)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(RoundedRectangle(cornerRadius: 10)
                        .fill(game.player2.isTurn ? Color.green : Color.gray)
                    )
                    .foregroundColor(.white)
                }
                .disabled(game.gameStart)
                .padding()
                
                
                VStack{
                    HStack{
                        ForEach(0...2, id: \.self){
                            index in SquareView(index: index)
                        }
                    }
                    HStack{
                        ForEach(3...5, id: \.self){
                            index in SquareView(index: index)
                        }
                    }
                    HStack{
                        ForEach(6...8, id: \.self){
                            index in SquareView(index: index)
                        }
                    }
                }
                .disabled(game.boardDisabled)
            }
           
            
            VStack{
                if game.gameOver{
                    Text("Game Over!")
                    
                    if game.possibleMoves.isEmpty{
                        Text("It's a Draw!")
                    }
                    else{
                        Text("\(game.currentPlayer.name) wins" )
                    }
                    
                    Button("New Game"){
                        game.reset()
                    }
                }
            
            }
            Spacer()
        }
        .toolbar{
            ToolbarItem(placement: .topBarTrailing){
                Button("End Game"){
                    dismiss()
                }.buttonStyle(.bordered)
            }
        }.navigationTitle("TicTacToe")
            .onAppear{
                game.reset()
            }
    }
}

#Preview {
    GameView()
        .environmentObject(GameService())
}
