import Foundation

enum ChipType: String {
    case X = "X"
    case O = "O"
}

struct Player {
    var name: String
    var chip: ChipType
}

class TicTacToe {
    private var board: [[String]]
    private var currPlayer: Player
    private let player1: Player
    private let player2: Player
    
    init() {
        self.board = Array(repeating: Array(repeating: " ", count: 3), count: 3)
        self.player1 = Player(name: "Player 1", chip: .X)
        self.player2 = Player(name: "Player 2", chip: .O)
        self.currPlayer = player1
    }
    
    func play_game() {
        let maxMoves = 9
        var numMoves = 0
        
        while numMoves < maxMoves {
            printBoard()
            print("\(currPlayer.name)'s turn! Place an \(currPlayer.chip.rawValue)")
            
            if let (row, col) = getValidMove() {
                setPiece(row: row, col: col)
                numMoves += 1
                
                if checkWinCondition(player: currPlayer) {
                    print("\(currPlayer.name) WINS!!!")
                    printBoard()
                    return
                }
                
                currPlayer = (currPlayer.chip == .X) ? player2 : player1
            }
        }
        
        printBoard()
        print("Game Over! It's a draw!")
    }
    
    private func printBoard() {
        print("-------------")
        for (index, row) in board.enumerated() {
            print("| \(row.joined(separator: " | ")) |")
            if index < 2 {
                print("-------------")
            }
        }
        print("-------------")
    }
    
    private func getValidMove() -> (Int, Int)? {
        while true {
            print("Enter row (0-2) and column (0-2) separated by space:")
            guard let input = readLine() else {
                print("Invalid input. Please try again.")
                continue
            }
            
            let parts = input.split(separator: " ").compactMap { Int($0) }
            guard parts.count == 2 else {
                print("Please enter two numbers separated by a space.")
                continue
            }
            
            let row = parts[0]
            let col = parts[1]
            
            guard (0...2).contains(row), (0...2).contains(col) else {
                print("Row and column must be between 0 and 2.")
                continue
            }
            
            guard board[row][col] == " " else {
                print("That position is already taken. Choose another.")
                continue
            }
            
            return (row, col)
        }
    }
    
    private func setPiece(row: Int, col: Int) {
        board[row][col] = currPlayer.chip.rawValue
    }
    
    private func checkWinCondition(player: Player) -> Bool {
        let chip = player.chip.rawValue
        
        // Check rows and columns
        for i in 0..<3 {
            if (board[i][0] == chip && board[i][1] == chip && board[i][2] == chip) ||
               (board[0][i] == chip && board[1][i] == chip && board[2][i] == chip) {
                return true
            }
        }
        
        // Check diagonals
        if (board[0][0] == chip && board[1][1] == chip && board[2][2] == chip) ||
           (board[0][2] == chip && board[1][1] == chip && board[2][0] == chip) {
            return true
        }
        
        return false
    }
}

let game = TicTacToe()
game.play_game()
