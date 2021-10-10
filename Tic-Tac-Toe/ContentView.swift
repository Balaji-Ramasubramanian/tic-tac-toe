//
//  ContentView.swift
//  Tic-Tac-Toe
//
//  Created by Balaji Ramasubramanian on 27/09/21.
//

import SwiftUI

struct ContentView: View {
    
    var columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    @State private var moves: [Move?] = Array(repeating: nil, count: 9)
    @State private var isGameboardDisabled = false
    @State private var isHumansTurn = true
    @State private var alertItem: AlertItem?
    
    var body: some View {
        GeometryReader{ geometry in
            VStack{
                Spacer()
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(0..<9) { i in
                        ZStack{
                            Circle()
                                .foregroundColor(.gray)
                                .frame(width: geometry.size.width/3 - 20, height: geometry.size.width/3 - 10)
                            
                            Image(systemName: moves[i]?.Indicator ?? "")
                                .resizable()
                                .frame(width: 40, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                .foregroundColor(.white)
                        }
                        .onTapGesture {
                            if isCellOccupied(in: moves, forIndex: i){ return }
                            moves[i] = Move(player: .human, boardIndex: i)
                            
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
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                var computerPosition = getComputerMovePosition(in: moves)
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
                    }
                }
                Spacer()
            }
            .disabled(isGameboardDisabled)
            .padding()
            .alert(item: $alertItem) { alertItem in
                Alert(title: alertItem.title,
                      message: alertItem.message,
                      dismissButton:  .default(alertItem.buttonTitle, action: {
                        resetGame()
                      }))
            }
        }
    }
    
    func isCellOccupied(in moves: [Move?], forIndex index: Int ) -> Bool {
        return moves.contains(where: { $0?.boardIndex == index})
    }
    
    func getComputerMovePosition(in moves:[Move?]) -> Int {
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

enum Player{
    case human, computer
}

struct Move {
    let player: Player
    let boardIndex: Int
    
    var Indicator : String {
        return (player == Player.human) ? "xmark" : "circle"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
