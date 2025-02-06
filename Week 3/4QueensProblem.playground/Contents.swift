var board = Array(repeating: Array(repeating: " ", count: 4), count: 4)

func isValidQueen(row:Int, col:Int, board:[[String]]) -> Bool{
    var n:Int = board.count
    var count = 0

    // Check horizontal
    for i in 0...n {
        if board[row][i] == "Q" {
            count += 1
        }
    }
    
    // Check vertical
    for i in 0...n {
        if board[i][col] == "Q" {
            count += 1
        }
    }
    
    // Diagonal: right to left
    for i in 0...(n-col) {
        if board[i][col] == "Q" {
            count += 1
        }
    }
    
    // Diagonal: left to right
    for i in 0...(n-col) {
        if board[i][col] == "Q" {
            count += 1
        }
    }
    
    
    return count <= 4
}
