//
//  LRCParser.swift
//  SwiftyLRC
//
//  Created by Mahmoud HodaeeNia on 7/7/23.
//

import Foundation
import RegexBuilder

// MARK: LRC.Parser
extension LRC {
    open class Parser {
//        static let syncedLineRegexLegacy = /(\[([0-9]{1}|[0-9]{2})\:[0-9]{2}(\.[0-9]{2})?\])+(.*)/
//        static let tagRegexLegacy = /(.*)/
        private static let gmtTimeZone: TimeZone = .init(secondsFromGMT: .zero)!
        private static let usLocale: Locale = Locale(identifier: "en_US_POSIX")
        
        
        private static let syncedLineRegex: Regex = Regex {
            Capture {
                // One or more time (more in case of repetition)
                OneOrMore {
                    // Open bracket
                    /\[/
                    
                    // Capturing it as a date, will convert it to TimeStamp later on
                    Capture {
                        One(
                            .date(
                                format: "\(minute: .twoDigits):\(second: .twoDigits).\(secondFraction: .fractional(2))",
                                locale: usLocale,
                                timeZone: gmtTimeZone
                            )
                        )
                    }
                    
                    
                    // Close bracket
                    /\]/
                }
            }
            
            // The Lyric itself :)
            Capture {
                OneOrMore {
                    CharacterClass.any
                }
            }
        }.asciiOnlyDigits()
        
        
        private static let tagsRegex: Regex = Regex {
            // Open bracket
            /\[/
            
            // Tag name
            Capture {
                /ar|a|al|ti|au|by|length|re|ve/
            }
            
            // Separator
            /\:/
            
            // Tag data
            Capture {
                OneOrMore {
                    NegativeLookahead { /\]/ }
                    CharacterClass.any
                }
            }
            
            // Close bracket
            /\]/
        }
        
        
        private static func parse(lrcLine: String) -> LRC.Content? {
            if let match = lrcLine.wholeMatch(of: Self.syncedLineRegex) {
                // Timestamps
                let timestamp = match.output.2.timeIntervalSince1970
                
                let content = match.output.3
                    .map({ String($0) })
                    .reduce("", +)
                
                return LRC.Line(time: timestamp, text: content)
                
                
            } else if let match = lrcLine.wholeMatch(of: Self.tagsRegex) {
                let name = match.output.1
                    .map({ String($0) })
                    .reduce("", +)
                
                let content = match.output.2
                    .map({ String($0) })
                    .reduce("", +)
                
                return LRC.Tag(name: name, content: content)
            }
            
            return nil
        }
        
        
        open class func parse(lrcString: String) -> LRC? {
            .init(lines: lrcString.lines
                    .map({ String($0) })
                    .compactMap(parse(lrcLine:))
            )
        }
    }
}



fileprivate extension StringProtocol {
    var lines: [SubSequence] { split(whereSeparator: \.isNewline) }
}

