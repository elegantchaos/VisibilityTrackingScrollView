//
//  ContentView.swift
//  VisibilityTrackingScrollViewExample
//
//  Created by Sam Deane on 27/07/2022.
//

import SwiftUI
import VisibilityTrackingScrollView

struct ContentView: View {
    var body: some View {
        VisibilityTrackingScrollView(action: handleVisibilityChanged) {
            LazyVStack {
                ForEach(0..<100, id: \.self) { item in
                    Text("\(item)")
                        .trackVisibility(id: "\(item)")
                }
            }
        }
    }
    
    func handleVisibilityChanged(_ id: String, state: VisibilityTracker<String>.State) {
        print("blah")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
