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

struct LinkableMarkdownText: View {
    private let markdown: AttributedString

    init(_ markdown: String, underlined: Bool = true) {
        self.markdown = makeAttributedString(
            from: markdown,
            underlined: underlined
        )
    }

    var body: some View {
        Text(markdown)
    }
}

private func makeAttributedString(
    from markdown: String,
    underlined: Bool
) -> AttributedString {
    var dest: AttributedString
    do {
        // ref. https://zenn.dev/link/comments/40d2073e63d41c
        let options = AttributedString.MarkdownParsingOptions(
            allowsExtendedAttributes: true,
            interpretedSyntax: .inlineOnlyPreservingWhitespace,
            appliesSourcePositionAttributes: true
        )
        dest = try AttributedString(markdown: markdown, options: options)
    } catch {
        return AttributedString(markdown)
    }

    for run in dest.runs where run.link != nil {
        dest[run.range].underlineStyle = underlined ? .single : .none
    }
    return dest
}

#Preview(traits: .sizeThatFitsLayout) {
    VStack(alignment: .leading, spacing: 8.0) {
        LinkableText("Click here.", links: [
            "here": URL(string: "https://www.example.com")!,
        ])
        LinkableText("詳しくはこちら", links: [
            "こちら": URL(string: "https://www.example.com")!,
        ])

        LinkableMarkdownText(
            "Click [here](https://www.example.com).",
            underlined: true
        )

        LinkableMarkdownText(
            "詳しくは[こちら](https://www.example.com).",
            underlined: true
        )
    }
    .tint(.red)
    .padding()
}
