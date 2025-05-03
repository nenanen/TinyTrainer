// BlobGridManager.swift
import Foundation
import SwiftUI

struct Pixel: Hashable {
    var x: Int
    var y: Int

    func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }

    static func == (lhs: Pixel, rhs: Pixel) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}
class BlobGridManager: ObservableObject {
    @Published var grid: [[Int]] = Array(repeating: Array(repeating: 0, count: 16), count: 16)
    private var timer: Timer?
    private var speed: Speed = .medium
    private var snake: [Pixel] = []

    enum Speed {
        case slow, medium, fast
        var interval: TimeInterval {
            switch self {
            case .slow: return 1.0
            case .medium: return 0.5
            case .fast: return 0.25
            }
        }
    }

    init() {
        let startX = Int.random(in: 0..<16)
        let startY = Int.random(in: 0..<16)
        let start = Pixel(x: startX, y: startY)
        grid[start.y][start.x] = 1
        snake = [start]
        startTimer()
    }

    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: speed.interval, repeats: true) { _ in
            self.moveSnake()
        }
    }

    func moveSnake() {
        guard let head = snake.last else { return }

        let headNeighbors = getNeighbors(of: head).filter { grid[$0.y][$0.x] == 0 }

        if let next = headNeighbors.randomElement() {
            // Move normally
            grid[next.y][next.x] = 1
            snake.append(next)

            let tail = snake.removeFirst()
            grid[tail.y][tail.x] = 0
            return
        }

        // 🛑 Snake is stuck — try reversing
        guard let tail = snake.first else { return }

        let tailNeighbors = getNeighbors(of: tail).filter { grid[$0.y][$0.x] == 0 }

        if let altNext = tailNeighbors.randomElement() {
            // Reverse the snake
            snake.reverse()

            // Move again, now from the other end
            grid[altNext.y][altNext.x] = 1
            snake.append(altNext)

            let oldTail = snake.removeFirst()
            grid[oldTail.y][oldTail.x] = 0
        }
    }

    func addSegment() {
        // Adds a new segment without removing the tail (snake grows)
        guard let head = snake.last else { return }
        let neighbors = getNeighbors(of: head).filter { grid[$0.y][$0.x] == 0 }

        if let next = neighbors.randomElement() {
            grid[next.y][next.x] = 1
            snake.append(next)
        }
    }

    private func getNeighbors(of pixel: Pixel) -> [Pixel] {
        let deltas = [(-1, 0), (1, 0), (0, -1), (0, 1)]
        return deltas.compactMap {
            let newX = pixel.x + $0.0
            let newY = pixel.y + $0.1
            return (0..<16).contains(newX) && (0..<16).contains(newY) ? Pixel(x: newX, y: newY) : nil
        }
    }
}
