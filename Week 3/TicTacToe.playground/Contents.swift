import Foundation

enum ChipType:String{
    case X = "X"
    case O = "O"
}

struct Player{
    var name:String
    var chip:ChipType
}

class TicTacToe{
    private var board:[[String]]
    private var currPlayer:Player
    private let player1:Player
    private let player2:Player
    
    init() {
        self.board = Array(repeating:Array(repeating: " ", count: 3), count: 3)
        self.player1 = Player(name:"Player 1", chip: .X)
        self.player2 = Player(name:"Player 2", chip: .O)
        self.currPlayer = player1
    }
    
    func play_game(){
        let max_moves:Int = 9
        var num_move:Int = 0
        
        //logic to continue game
        //num_move <= max_moves
        while (num_move < max_moves){
            printBoard()
            print(currPlayer.name + "\'s turn!")
            print("Place a piece")
                    
        }
        
        //enter where they want to play (row, col)
        //validation
        
        //rules for winning
        //players can store their moves
    }
    
    func printBoard(){
        print("-----")
        for i in board {
            print(i.joined(separator: " | "))
            print("-----")
        }
    }
}
