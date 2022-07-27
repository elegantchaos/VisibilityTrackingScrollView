// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 27/07/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SwiftUI

public class VisibilityTracker<ID: Hashable>: ObservableObject {
    var containerBounds: CGRect
    var visibleItems: Set<ID>
    var action: Action
    public enum Change {
        case hidden
        case shown
    }

    public typealias Action = (ID, Change) -> ()

    public init(action: @escaping Action) {
        self.containerBounds = .zero
        self.visibleItems = []
        self.action = action
    }
    

    public func reportContainerBounds(_ bounds: CGRect) {
        containerBounds = bounds
    }
    
    public func reportContentBounds(_ bounds: CGRect, id: ID) {
        let topLeft = bounds.origin
        let size = bounds.size
        let bottomRight = CGPoint(x: topLeft.x + size.width, y: topLeft.y + size.height)
        let isVisible = containerBounds.contains(topLeft) || containerBounds.contains(bottomRight)
        if visibleItems.contains(id) {
            if !isVisible {
                visibleItems.remove(id)
                action(id, .hidden)
            }
        } else {
            if isVisible {
                visibleItems.insert(id)
                action(id, .shown)
            }
        }
    }
}

