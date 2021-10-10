//
//  Alerts.swift
//  Tic-Tac-Toe
//
//  Created by Balaji Ramasubramanian on 10/10/21.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
}

struct AlertContents {
    static let humanWins = AlertItem(title: Text("You Win!"), message: Text("Wow, you seems to be a champion!"), buttonTitle: Text("Play Again"))
    static let computerWins = AlertItem(title: Text("You Lost!"), message: Text("Dont lose hope. Wanna try again?"), buttonTitle: Text("Try Again"))
    static let draw = AlertItem(title: Text("Match Draw!"), message: Text("Good match! Ready for a rematch?"), buttonTitle: Text("Rematch"))
}
