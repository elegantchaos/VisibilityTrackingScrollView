# VisibilityTrackingScrollView

This package provides a variant of ScrollView that you can use to track whether views inside it are actually visible.

Usage: 

```swift

    var body: some View {
        VisibilityTrackingScrollView(action: handleVisibilityChanged) {
            LazyVStack {
                ForEach(0..<100, id: \.self) { item in
                    Text("\(item)")
                        .background(Color.random())
                        .trackVisibility(id: "\(item)")
                }
            }
        }
    }
    
    func handleVisibilityChanged(_ id: String, state: VisibilityTracker<String>.Change) {
        switch state {
            case .shown: print("\(id) shown")
            case .hidden: print("\(id) hidden")
        }
    }


```

Any view that you want to track should have the `trackVisibility` modifier applied to it. 

You can use any hashable type for the identifier.

When a tracked view is scrolled into or out of the visible portion of the container, the callback will be called, with the id and new state of the tracked view.


