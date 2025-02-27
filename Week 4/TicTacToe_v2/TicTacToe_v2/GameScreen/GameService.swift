//
//  GameService.swift
//  TicTacToe_v2
//
//  Created by Het Koradia on 2/17/25.
//

import Foundation
import SwiftUI

class GameService:ObservableObject{
    @Published var player1 = Player(name:"Player 1", gamePiece: .X)
    @Published var player2 = Player(name:"Player 2", gamePiece: .O)
    
    @Published var possibleMoves = Moves.all
    
    @Published var gameOver = false
    
    @Published var gameBoard: [GameSquare] = GameSquare.reset

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
    
    func reset(){
        
        player1.isTurn=false
        player2.isTurn=false
        
        player1.moves.removeAll()
        player2.moves.removeAll()
        
        gameOver = false
        
        possibleMoves = Moves.all
        
        gameBoard = GameSquare.reset
    }
    
    func updateMoves(index: Int){
        if player1.isTurn {
            player1.moves.append(index+1)
            gameBoard[index].player = player1
        }
        else{
            player2.moves.append(index+1)
            gameBoard[index].player = player2
        }
    }
    
    func checkIfWinner(){
        if player1.isWinner() || player2.isWinner() {
            gameOver = true
        }
    }
    
    func toggleCurrent(){
        player1.isTurn.toggle()
        player2.isTurn.toggle()
    }
    
    func makeMove(at index:Int){
        if gameBoard[index].player == nil {
            withAnimation{
                updateMoves(index:index)
            }
            checkIfWinner()
            
            if !gameOver{
                if let matchingIndex = possibleMoves.firstIndex(where: {$0 == (index+1)}){
                    possibleMoves.remove(at:matchingIndex)
                }
                toggleCurrent()
                
            }
            
            if possibleMoves.isEmpty{
                gameOver = true
            }
        }
    }
}
