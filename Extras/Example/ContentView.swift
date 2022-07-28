// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 28/07/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SwiftUI
import VisibilityTrackingScrollView

public extension Color {
    
    static func random(randomOpacity: Bool = false) -> Color {
        Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            opacity: randomOpacity ? .random(in: 0...1) : 1
        )
    }
}

struct ContentView: View {
    var body: some View {
        VisibilityTrackingScrollView(action: handleVisibilityChanged) {
            LazyVStack {
                ForEach(0..<100, id: \.self) { item in
                    Text("\(item)")
                        .frame(width: 100, height: CGFloat.random(in: 20...60))
                        .background(Color.random())
                        .trackVisibility(id: "\(item)")
                }
            }
        }
    }
    
    func handleVisibilityChanged(_ id: String, change: VisibilityChange) {
        switch change {
            case .shown: print("\(id) shown")
            case .hidden: print("\(id) hidden")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
