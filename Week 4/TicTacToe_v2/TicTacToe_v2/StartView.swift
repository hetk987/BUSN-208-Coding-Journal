//
//  ContentView.swift
//  TicTacToe_v2
//
//  Created by Het Koradia on 2/10/25.
//

import SwiftUI


struct StartView: View {
    @State private var gameType:GameType = .undetermined
    @State private var name:String = ""
    @State private var opponentName:String = ""
    @FocusState private var focus: Bool
    @State private var startGame = false
    
    var body: some View {
        NavigationStack {
            
            VStack {
                Picker("Select the game", selection: $gameType){
                    Text("Select Game Type").tag(GameType.undetermined)
                    Text("Two sharing a device").tag(GameType.single)
                    Text("Challenge your device").tag(GameType.bot)
                    Text("Challenge a friend").tag(GameType.peer)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .colorInvert()
                
                
                Text(gameType.description)
                    .padding()
                
                VStack{
                    switch gameType {
                    case .single:
                        TextField("Your Name", text:$name)
                        TextField("Your Opponent's name", text: $opponentName)
                    case .bot:
                        TextField("Your Name", text:$name)
                        
                    case .peer:
                        EmptyView()
                    case .undetermined:
                        EmptyView()
                    }
                }
                .padding()
                .textFieldStyle(.roundedBorder)
                .focused($focus)
                .frame(width:350)
                
                if gameType != GameType.undetermined{
                    Button("Start Game"){
                        //setup game
                        focus = false
                        startGame.toggle()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(gameType == GameType.undetermined || (gameType == GameType.single || gameType==GameType.bot) && name=="" || (gameType == GameType.single) && opponentName=="")
                    
                    
                    Image("welcomeScreen")
                }
            }
            .padding()
            .navigationTitle("Tic-Tac-Toe")
        }
    }
        
}

#Preview {
        StartView()
    
}

