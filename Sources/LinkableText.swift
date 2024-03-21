import Foundation
import SwiftUI

struct LinkableText: View {
    private let text: String
    private let links: [String: URL]
    private let underlined: Bool

    init(_ text: String, links: [String: URL], underlined: Bool = true) {
        self.text = text
        self.links = links
        self.underlined = underlined
    }

    var body: some View {
        Text(makeAttributedString())
    }

    private func makeAttributedString() -> AttributedString {
        var dest = AttributedString(text)
        for (linkText, linkURL) in links {
            guard let range = dest.range(of: linkText) else {
                continue
            }
            dest[range].link = linkURL

            if underlined {
                dest[range].underlineStyle = .single
            }
        }
        return dest
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    VStack(alignment: .leading, spacing: 8.0) {
        LinkableText("Click here.", links: [
            "here": URL(string: "https://www.example.com")!,
        ])
        LinkableText("詳しくはこちら", links: [
            "こちら": URL(string: "https://www.example.com")!,
        ])
    }
    .tint(.red)
    .padding()
}
