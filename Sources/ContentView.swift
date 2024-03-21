import SwiftUI

public struct ContentView: View {
    public init() {}

    public var body: some View {
        VStack(spacing: 8.0) {
            LinkableText(
                "Click here.",
                links: ["here": URL(string: "https://www.apple.com")!]
            )

            Text("Click [here](https://www.apple.com).")

            HStack(spacing: 0.0) {
                Text("Click ")
                Link(destination: URL(string: "https://www.apple.com")!) {
                    Text("here")
                        .underline()
                }
                Text(".")
            }
        }
        .tint(.red)
        .environment(\.openURL, OpenURLAction { url in
            print("Open \(url)")
            return .systemAction(url)
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
