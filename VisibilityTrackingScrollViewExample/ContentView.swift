//
//  ContentView.swift
//  VisibilityTrackingScrollViewExample
//
//  Created by Sam Deane on 27/07/2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VisibilityTrackingScrollView {
            VStack {
                ForEach(0..<100, id: \.self) { item in
                    Text("\(item)")
                        .trackVisibility(id: "\(item)")
                }
            }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

class VisibilityTracker<ID: Hashable>: ObservableObject {
    var containerBounds: CGRect = .zero
    var visibleItems: Set<ID> = []
    
    func reportContainerBounds(_ bounds: CGRect) {
        print("container is at \(bounds)")
        containerBounds = bounds
    }
    
    func reportContentBounds(_ bounds: CGRect, id: ID) {
        let isVisible = containerBounds.contains(bounds.origin)
        if visibleItems.contains(id) {
            if !isVisible {
                print("\(id) hidden")
                visibleItems.remove(id)
            }
        } else {
            if isVisible {
                print("\(id) shown")
                visibleItems.insert(id)
            }
        }
    }
}

typealias ExampleViewID = String

struct VisibilityTrackingScrollView<Content>: View where Content: View {
    @ViewBuilder let content: Content
    @State var visibilityTracker = VisibilityTracker<ExampleViewID>()
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                report(content, proxy: proxy)
                    .environmentObject(visibilityTracker)
            }
        }
    }

    func report(_ content: Content, proxy: GeometryProxy) -> Content {
        visibilityTracker.reportContainerBounds(proxy.frame(in: .global))
        return content
    }

}

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
