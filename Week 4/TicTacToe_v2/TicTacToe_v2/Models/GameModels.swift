//
//  GameModels.swift
//  TicTacToe_v2
//
//  Created by Het Koradia on 2/10/25.
//

import SwiftUI

enum GameType{
    case single, bot, peer, undetermined
    
    var description:String{
        switch self {
        case .single:
            return "Share your device with a friend to play."
        case .bot:
            return "Play with a bot."
        case .peer:
            return "Invite someone on the network to play wtih."
        case .undetermined:
            return ""
        }
    }
}

enum GamePiece:String{
    case X, O
    
    var img:Image{
        Image(self.rawValue)
    }
}

enum Moves {
    static let all = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    
    static let winningMoves = [
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9],
        [1, 4, 7],
        [2, 5, 8],
        [3, 6, 9],
        [1, 5, 9],
        [3, 5, 7]
    ]
    
    
    
    
}

struct Player {
    var name: String
    var gamePiece: GamePiece
    var isTurn: Bool = false
    var moves: [Int] = []
    
    func isWinner() -> Bool {
        for winningMove in Moves.winningMoves {
            if Set(winningMove).isSubset(of: Set(self.moves)) {
                return true
            }
        }
        return false
    }
}
