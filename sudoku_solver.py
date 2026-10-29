
def print_grid(grid):
    for row in grid:
        print(*row)


def is_valid(grid, row, col, num):
    # Check row
    for c in range(9):
        if grid[row][c] == num:
            return False

    # Check column
    for r in range(9):
        if grid[r][col] == num:
            return False

    # Check 3x3 subgrid
    start_row = (row // 3) * 3
    start_col = (col // 3) * 3

    for r in range(start_row, start_row + 3):
        for c in range(start_col, start_col + 3):
            if grid[r][c] == num:
                return False

    return True


def solve_sudoku(grid):
    for row in range(9):
        for col in range(9):
            if grid[row][col] == 0:
                for num in range(1, 10):
                    if is_valid(grid, row, col, num):
                        grid[row][col] = num

                        if solve_sudoku(grid):
                            return True

                        grid[row][col] = 0  # Backtrack

                return False

    return True


print("Enter Sudoku: 9 rows, 9 numbers each")
grid = []

for i in range(9):
    row = list(map(int, input().split()))

    if len(row) != 9 or any(n < 0 or n > 9 for n in row):
        raise ValueError("Each row must contain 9 digits from 0 to 9")

    grid.append(row)

if solve_sudoku(grid):
    print("Solved Sudoku:")
    print_grid(grid)
else:
    print("No solution exists")
