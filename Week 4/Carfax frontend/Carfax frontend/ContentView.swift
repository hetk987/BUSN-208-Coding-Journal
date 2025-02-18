//
//  ContentView.swift
//  Carfax frontend
//
//  Created by Het Koradia on 2/17/25.
//

import SwiftUI

struct CaravanView: View {
    let items = [
        "Untitled1", "Untitled2", "Untitled" // Your custom image names
    ]

    var body: some View {
        NavigationView {
            ScrollView(.horizontal, showsIndicators: false) {
                
            }
            .navigationTitle("Caravan View")
        }
    }
}

struct CaravanView_Previews: PreviewProvider {
    static var previews: some View {
        CaravanView()
    }
}
