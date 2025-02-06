var board = Array(repeating: Array(repeating: " ", count: 4), count: 4)

func isValidQueen(row: Int, col: Int, board: [[String]]) -> Bool {
    let n = board.count
    var count = 0

    // Check horizontal
    for i in 0..<n {
        if board[row][i] == "Q" {
            count += 1
        }
    }
    
    // Check vertical
    for i in 0..<n {
        if board[i][col] == "Q" {
            count += 1
        }
    }
    
    // Diagonal: top-left to bottom-right
    var i = row, j = col
    while i >= 0 && j >= 0 {
        if board[i][j] == "Q" {
            count += 1
        }
        i -= 1
        j -= 1
    }
    i = row + 1
    j = col + 1
    while i < n && j < n {
        if board[i][j] == "Q" {
            count += 1
        }
        i += 1
        j += 1
    }
    
    // Diagonal: top-right to bottom-left
    i = row
    j = col
    while i >= 0 && j < n {
        if board[i][j] == "Q" {
            count += 1
        }
        i -= 1
        j += 1
    }
    i = row + 1
    j = col - 1
    while i < n && j >= 0 {
        if board[i][j] == "Q" {
            count += 1
        }
        i += 1
        j -= 1
    }
    
    return count == 4 // The queen counts itself in all four checks
}

