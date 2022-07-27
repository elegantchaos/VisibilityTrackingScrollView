// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 27/07/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SwiftUI

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

public extension View {
    func trackVisibility<ID: Hashable>(id: ID) -> some View {
        self
            .modifier(ContentVisibilityTrackingModifier(id: id))
    }
}
