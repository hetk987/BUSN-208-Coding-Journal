import Foundation

enum type{
    case X, O
}

struct Player{
    var chip: type
}

class TicTacToe{
    private var board:[[String]]
    private var currPlayer: String
    
    init() {
        self.board = Array(repeating:Array(repeating: " ", count: 3), count: 3)
        self.currPlayer = "o"
    }
    
    func play_game(){
        var max_moves:Int
        let num_move
        
        //logic to continue game
        //num_move <= max_moves
        
        //enter where they want to play (row, col)
        //validation
        
        //rules for winning
        //players can store their moves
    }
}
