//
//  GameView.swift
//  Tic-Tac-Toe
//
//  Created by Balaji Ramasubramanian on 27/09/21.
//

import SwiftUI

struct GameView: View {
    
    @StateObject private var viewModel = GameViewModel()
    
    var body: some View {
        GeometryReader{ geometry in
            VStack{
                Spacer()
                LazyVGrid(columns: viewModel.columns, spacing: 10) {
                    ForEach(0..<9) { i in
                        ZStack{
                            GameCellView(geometryProxy: geometry)
                            PlayerIndicatorView(systemName: viewModel.moves[i]?.Indicator ?? "")
                        }
                        .onTapGesture {
                            viewModel.determinePlayerMove(for: i)
                        }
                    }
                }
                Spacer()
            }
            .disabled(viewModel.isGameboardDisabled)
            .padding()
            .alert(item: $viewModel.alertItem) { alertItem in
                Alert(title: alertItem.title,
                      message: alertItem.message,
                      dismissButton: .default(alertItem.buttonTitle, action: {
                        viewModel.resetGame()
                      }))
            }
        }
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
        GameView()
    }
}

struct GameCellView: View {
    var geometryProxy: GeometryProxy
    var body: some View {
        Circle()
            .foregroundColor(.gray)
            .frame(width: geometryProxy.size.width/3 - 20,
                   height: geometryProxy.size.width/3 - 10)
    }
}

struct PlayerIndicatorView: View {
    var systemName: String
    var body: some View {
        Image(systemName: systemName)
            .resizable()
            .frame(width: 40, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .foregroundColor(.white)
    }
}
