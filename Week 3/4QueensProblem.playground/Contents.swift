var board = Array(repeating: Array(repeating: " ", count: 4), count: 4)

func isValidQueenSpot(row: Int, col: Int, board: [[String]]) -> Bool {
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
    
    return count == 0 // The queen counts itself in all four checks
}

func SolveProblem(col: Int, board: inout [[String]]) -> Bool {
    if col >= board.count {
        return true
    }
    
    for i in 0..<board.count {
        if isValidQueenSpot(row: i, col: col, board: board) {
            board[i][col] = "Q"
            
            if SolveProblem(col: col + 1, board: &board) {
                return true
            }
            board[i][col] = " "
        }
    }
    return false
}

func printBoard(board:[[String]]) {
    print("-----------------")
    for (index, row) in board.enumerated() {
        print("| \(row.joined(separator: " | ")) |")
        if index < 3 {
            print("-----------------")
        }
    }
    print("-----------------")
}

SolveProblem(col: 0, board: &board)
printBoard(board: board)
