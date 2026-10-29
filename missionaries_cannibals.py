
from collections import deque

def safe(m, c):
    mr = 3 - m
    cr = 3 - c

    if m < 0 or m > 3 or c < 0 or c > 3:
        return False

    if m > 0 and c > m:
        return False

    if mr > 0 and cr > mr:
        return False

    return True


def solve():
    start = (3, 3, 0)
    goal = (0, 0, 1)

    # (missionaries, cannibals) in the boat
    moves = [(2, 0), (0, 2), (1, 1), (1, 0), (0, 1)]

    queue = deque([start])
    parent = {start: None}
    action = {start: "Initial state"}

    while queue:
        m, c, boat = queue.popleft()

        if (m, c, boat) == goal:
            break

        for dm, dc in moves:
            if boat == 0:
                nxt = (m - dm, c - dc, 1)
                move = f"{dm}M {dc}C left to right"
            else:
                nxt = (m + dm, c + dc, 0)
                move = f"{dm}M {dc}C right to left"

            if dm + dc == 0:
                continue

            if safe(nxt[0], nxt[1]) and nxt not in parent:
                parent[nxt] = (m, c, boat)
                action[nxt] = move
                queue.append(nxt)
    else:
        print("No solution")
        return

    path = []
    state = goal

    while state is not None:
        path.append(state)
        state = parent[state]

    path.reverse()

    for i, state in enumerate(path):
        m, c, boat = state
        print(
            f"Step {i}: {action[state]} | "
            f"Left M={m}, C={c} | "
            f"Right M={3-m}, C={3-c} | "
            f"Boat={'Right' if boat else 'Left'}"
        )

    print("Answer: All crossed safely.")
    print("Total boat trips:", len(path) - 1)


solve()
