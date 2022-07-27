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
            VStack {
                ForEach(0..<100, id: \.self) { item in
                    Text("\(item)")
                        .trackVisibility(id: "\(item)")
                }
            }
            }
    }
    
    func handleVisibilityChanged(_ id: ExampleViewID, state: VisibilityTracker<ExampleViewID>.State) {
        print("blah")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

typealias ExampleViewID = String


struct ContentVisibilityTrackingModifier<ID: Hashable>: ViewModifier {
    @EnvironmentObject var visibilityTracker: VisibilityTracker<ID>
    
    let id: ID
    
    func body(content: Content) -> some View {
        GeometryReader { proxy in
            report(content, proxy: proxy)
        }
    }
    
    func report(_ content: Content, proxy: GeometryProxy) -> some View {
        visibilityTracker.reportContentBounds(proxy.frame(in: .global), id: id)
        return content
            .id(id)
    }
}

extension View {
    func trackVisibility<ID: Hashable>(id: ID) -> some View {
        self
            .modifier(ContentVisibilityTrackingModifier(id: id))
    }
}
