//
//  GameSquare.swift
//  TicTacToe_v2
//
//  Created by Het Koradia on 2/24/25.
//

import SwiftUI

struct GameSquare{
    var id:Int
    var player:Player?
    
    var image:Image{
        
        if let player = player{
            return player.gamePiece.img
        }
        else{
            return Image("None")
        }
    }
    
    static var reset:[GameSquare]{
        var squares = [GameSquare]()
        
        for index in 1...9{
            squares.append(GameSquare(id: index))
        }
        
        return squares
    }
}
