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
    @State private var isHumansTurn = true
    
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
                            
                            moves[i] = Move(player: isHumansTurn ? .human : .computer, boardIndex: i)
                            isHumansTurn.toggle()
                        }
                    }
                }
                Spacer()
            }
            .padding()
        }
    }
    
    func isCellOccupied(in moves: [Move?], forIndex index: Int ) -> Bool {
        return moves.contains(where: { $0?.boardIndex == index})
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
