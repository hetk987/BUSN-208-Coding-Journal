//
//  GameService.swift
//  TicTacToe_v2
//
//  Created by Het Koradia on 2/17/25.
//

import Foundation

class GameService:ObservableObject{
    @Published var player1 = Player(name:"Player 1", gamePiece: .X)
    @Published var player2 = Player(name:"Player 2", gamePiece: .O)
    
    @Published var possibleMoves = Moves.all
    
    //we need to build the board
    @Published var gameOver = false
    
    var gameType = GameType.single
    
    var currentPlayer:Player{
        if player1.isTurn{
            return player1
        }
        else {
            return player2
        }
    }
    
    var gameStart:Bool{
        return player1.isTurn || player2.isTurn
    }
    
    var boardDisabled:Bool{
        return !gameStart || gameOver
    }
    
    func setupGame(gameType:GameType, player1Name:String, player2Name:String){
        switch gameType {
        case .single:
            self.gameType = .single
            player2.name = player2Name
        case .bot:
            self.gameType = .bot
        case .peer:
            self.gameType = .peer
        case .undetermined:
            self.gameType = .undetermined
            break
        }
        player1.name = player1Name
    }
}
