# VisibilityTrackingScrollView

This package provides a variant of ScrollView that you can use to track whether views inside it are actually visible.

Usage: 

```swift

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
    
    func handleVisibilityChanged(_ id: String, change: VisibilityChange) {
        switch change {
            case .shown: print("\(id) shown")
            case .hidden: print("\(id) hidden")
        }
    }

```

Any view that you want to track should have the `trackVisibility` modifier applied to it. 

When a tracked view is scrolled into or out of the visible portion of the container, the callback will be called, with the id and new state of the tracked view.

You can use any hashable type for the identifier that you pass to `.trackVisibility`, but it must match the type that the callback is using (in the example above, we're using `String` identifiers).

If you accidentally use a different types in both places, it won't be detected at compile-time, since it's completely valid code. At runtime, however, the trackVisiblity modifier will fail to find the environment object that it is expecting, and you'll get a crash. 

### Example

See the [Extras folder](/Extras) for an example project.

### Background

In an ideal world, this wouldn't be necessary because ScrollView would have some decent support for this kind of thing out-of-the-box.

This particular view came of a discussion about unnecessary refreshes in SwiftUI and how to avoid them. 

A technique like this was being used in an app, but was potentially causing changes to environment objects that also had other purposes, causing more refreshing that was strictly needed. 

I suggested trying to isolate this behaviour, and then realised that I could probably actually package it up as a generic view/modifier pair.

It makes heavy use of `GeometryReader`, which isn't ideal, but realistically is the only way that I know of that works in a timely manner.   
