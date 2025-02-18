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
                HStack(spacing: 20) {
                    ForEach(items, id: \.self) { item in
                        VStack {
                            Image(item) // Use your own custom images
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 200, height: 200)
                                .cornerRadius(15)
                                .shadow(radius: 5)
                            Text(item)
                                .font(.headline)
                                .foregroundColor(.primary)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(radius: 10)
                    }
                }
                .padding()
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
