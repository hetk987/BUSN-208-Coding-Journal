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
            print("\(currPlayer.name) 's turn!")
            print("Place an \(currPlayer.chip.rawValue)")
            let cord = getValidMove()
            if cord != nil {
                
            }
            
        }
        
        //enter where they want to play (row, col)
        //validation
        
        //rules for winning
        //players can store their moves
    }
    
    func printBoard()->Void{
        print("-----")
        for i in board {
            print(i.joined(separator: " | ")) //Combined the list elements with the separator
            print("-----")
        }
    }
    
    func getValidMove() -> (Int, Int)?{
        print("Enter row (0-2) and column (0-2) separated by space:")
                guard let input = readLine()?.split(separator: " ").compactMap({ Int($0) }), //Reads the line from the terminal and then splits it into a list and then converts it to a n int. The guard allows me to have a bunch of checks on it to make sure it is valid. 
                      input.count == 2,
                      input[0] < 3,
                      input[1] < 3,
                      input[0] > 0,
                      input[1] > 0,
                      board[input[0]][input[1]] == " " else {
                    print("Invalid move. Try again.")
                    return nil
                }
                return (input[0], input[1])
    }
}

