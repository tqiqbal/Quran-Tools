//
//  HTMLParser.swift
//  Quran Tools
//
//  Created by Tanveer Iqbal on 16/11/2025.
//

import Foundation

class HTMLParser {
    static func parseEarabContent(html: String) -> (title: String, cards: [String]) {
        var title = ""
        var cards: [String] = []

        // Extract title with id="e3rab"
        if let titleRange = html.range(of: #"<[^>]*id="e3rab"[^>]*>(.*?)</[^>]*>"#, options: .regularExpression) {
            let titleHTML = String(html[titleRange])
            title = stripHTMLTags(titleHTML)
        }

        // Extract cards with class "card mt-3"
        let cardPattern = #"<div[^>]*class="[^"]*card mt-3[^"]*"[^>]*>(.*?)</div>\s*</div>"#
        let regex = try? NSRegularExpression(pattern: cardPattern, options: [.dotMatchesLineSeparators])

        if let regex = regex {
            let nsString = html as NSString
            let matches = regex.matches(in: html, options: [], range: NSRange(location: 0, length: nsString.length))

            // Get first two cards
            for match in matches.prefix(2) {
                if let range = Range(match.range(at: 1), in: html) {
                    let cardContent = String(html[range])
                    let cleanContent = cleanCardContent(cardContent)
                    cards.append(cleanContent)
                }
            }
        }

        return (title, cards)
    }

    private static func stripHTMLTags(_ html: String) -> String {
        var result = html
        // Remove HTML tags
        result = result.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
        // Decode HTML entities
        result = decodeHTMLEntities(result)
        return result.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private static func cleanCardContent(_ html: String) -> String {
        var result = html

        // Remove script tags and their content
        result = result.replacingOccurrences(of: "<script[^>]*>.*?</script>", with: "", options: [.regularExpression, .caseInsensitive])

        // Remove style tags
        result = result.replacingOccurrences(of: "<style[^>]*>.*?</style>", with: "", options: [.regularExpression, .caseInsensitive])

        // Replace <br> with newlines
        result = result.replacingOccurrences(of: "<br[^>]*>", with: "\n", options: [.regularExpression, .caseInsensitive])

        // Replace </p> and </div> with newlines
        result = result.replacingOccurrences(of: "</p>", with: "\n", options: .caseInsensitive)
        result = result.replacingOccurrences(of: "</div>", with: "\n", options: .caseInsensitive)

        // Remove remaining HTML tags
        result = result.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)

        // Decode HTML entities
        result = decodeHTMLEntities(result)

        // Clean up excessive whitespace
        result = result.replacingOccurrences(of: "\n\n+", with: "\n\n", options: .regularExpression)
        result = result.replacingOccurrences(of: "[ \t]+", with: " ", options: .regularExpression)

        return result.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private static func decodeHTMLEntities(_ string: String) -> String {
        var result = string
        let entities = [
            "&nbsp;": " ",
            "&lt;": "<",
            "&gt;": ">",
            "&amp;": "&",
            "&quot;": "\"",
            "&apos;": "'",
            "&#39;": "'",
            "&rsquo;": "'",
            "&lsquo;": "'",
            "&rdquo;": "\"",
            "&ldquo;": "\"",
        ]

        for (entity, replacement) in entities {
            result = result.replacingOccurrences(of: entity, with: replacement)
        }

        // Decode numeric entities
        let numericPattern = "&#(\\d+);"
        if let regex = try? NSRegularExpression(pattern: numericPattern, options: []) {
            let nsString = result as NSString
            let matches = regex.matches(in: result, options: [], range: NSRange(location: 0, length: nsString.length))

            var offset = 0
            for match in matches {
                if let numberRange = Range(match.range(at: 1), in: result) {
                    let numberString = String(result[numberRange])
                    if let number = Int(numberString), let scalar = UnicodeScalar(number) {
                        let character = String(Character(scalar))
                        let fullRange = Range(match.range(at: 0), in: result)!
                        let startIndex = result.index(fullRange.lowerBound, offsetBy: offset)
                        let endIndex = result.index(fullRange.upperBound, offsetBy: offset)
                        result.replaceSubrange(startIndex..<endIndex, with: character)
                        offset += character.count - (fullRange.upperBound.utf16Offset(in: result) - fullRange.lowerBound.utf16Offset(in: result))
                    }
                }
            }
        }

        return result
    }
}
