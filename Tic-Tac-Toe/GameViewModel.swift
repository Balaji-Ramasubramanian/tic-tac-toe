//
//  GameViewModel.swift
//  Tic-Tac-Toe
//
//  Created by Balaji Ramasubramanian on 11/10/21.
//

import SwiftUI

final class GameViewModel: ObservableObject {
    var columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    @Published var isGameboardDisabled = false
    @Published var isHumansTurn = true
    @Published var alertItem: AlertItem?
    
    func determinePlayerMove(for position: Int) {
        if isCellOccupied(in: moves, forIndex: position){ return }
        moves[position] = Move(player: .human, boardIndex: position)
        
        if(checkWinCondition(for: .human, in: moves)){
            alertItem = AlertContents.humanWins
            return;
        }
        // Check for Draw Condition
        if checkDrawCondition(in: moves) {
            alertItem = AlertContents.draw
            return
        }
        isGameboardDisabled = true
        
        // computer move
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            let computerPosition = getComputerMovePosition(in: moves)
            moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
            isGameboardDisabled = false
            if(checkWinCondition(for: .computer, in: moves)){
                alertItem = AlertContents.computerWins
                return;
            }
        }
        
        // Check for Draw Condition
        if checkDrawCondition(in: moves) {
            alertItem = AlertContents.draw
            return
        }
    }
    
    func isCellOccupied(in moves: [Move?], forIndex index: Int ) -> Bool {
        return moves.contains(where: { $0?.boardIndex == index})
    }
    
    func getComputerMovePosition(in moves:[Move?]) -> Int {
        // If there is win position for AI and return it
        let winPatterns: Set<Set<Int>> = [[0,1,2], [0,3,6], [0,4,8], [1,4,7], [2,5,8], [2,4,6], [3,4,5], [6,7,8]]
        let computerMoves = moves.compactMap{$0}.filter{$0.player == .computer}
        let computerPositions = Set(computerMoves.map{$0.boardIndex})
        
        for pattern in winPatterns {
            let winPosition = pattern.subtracting(computerPositions)
            if(winPosition.count == 1){
                let isAvailable = !isCellOccupied(in: moves, forIndex: winPosition.first!)
                if isAvailable{ return winPosition.first!}
            }
        }
        
        // If there is win position for player, block that position
        let playerMoves = moves.compactMap{$0}.filter{$0.player == .human}
        let playerPositions = Set(playerMoves.map{$0.boardIndex})
        for pattern in winPatterns {
            let winPosition = pattern.subtracting(playerPositions)
            if(winPosition.count == 1){
                let isAvailable = !isCellOccupied(in: moves, forIndex: winPosition.first!)
                if isAvailable{ return winPosition.first!}
            }
        }
        
        // If middle square is not occupied, return it
        let centerCellPosition = 4
        let isMiddleCellAvailable = !isCellOccupied(in: moves, forIndex: centerCellPosition)
        if (isMiddleCellAvailable) { return centerCellPosition }
        
        // Return random position
        var movePosition = Int.random(in: 0..<9)
        while (isCellOccupied(in: moves, forIndex: movePosition)) {
            movePosition = Int.random(in: 0..<9)
        }
        return movePosition
    }
    
    func checkWinCondition(for player: Player, in moves: [Move?]) -> Bool {
        let winPatterns: Set<Set<Int>> = [[0,1,2], [0,3,6], [0,4,8], [1,4,7], [2,5,8], [2,4,6], [3,4,5], [6,7,8]] // All possible win patterns
        
        let playerMoves = moves.compactMap{$0}.filter{$0.player == player}
        let playerPositions = Set(playerMoves.map{$0.boardIndex})
        
        for pattern in winPatterns where pattern.isSubset(of: playerPositions) {return true} // Check if player position has any win patterns
        
        return false;
    }
    
    func checkDrawCondition(in moves: [Move?]) -> Bool {
        return moves.compactMap{$0}.count==9
    }
    
    func resetGame() {
        moves = Array(repeating: nil, count: 9)
    }
}
