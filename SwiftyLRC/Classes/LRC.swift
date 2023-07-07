//
//  LRC.swift
//  SwiftyLRC
//
//  Created by Mahmoud HodaeeNia on 7/7/23.
//

import Foundation
import RegexBuilder


// MARK: LyRiCs
open class LRC {
    public let lines: [Line]
    public let tags: [Tag]
    
    public init(lines: [Line], tags: [Tag]) {
        self.lines = lines.sorted(by: { $0.time < $1.time })
        self.tags = tags
    }
    
    public convenience init(lines: [Content]) {
        let liveLines = lines.compactMap({ $0 as? LRC.Line })
        let tags = lines.compactMap({ $0 as? LRC.Tag })
        self.init(lines: liveLines, tags: tags)
    }
    
    
    open func getLineIndex(for time: TimeInterval) -> Int? {
        guard let nextIndex = self.lines.firstIndex(where: { $0.time > time }) else {
            return nil
        }
        return max(0, nextIndex - 1)
    }
    
    open func getLine(for time: TimeInterval) -> Line? {
        guard let currentIndex = self.getLineIndex(for: time) else {
            return nil
        }
        return self.getLine(atIndex: currentIndex)
    }
    
    open func getLine(atIndex index: Int) -> Line? {
        guard index >= .zero, index < self.lines.count else { return nil }
        return self.lines[index]
    }
    
    open func getTag(withName name: String) -> Tag? {
        self.tags.first(where: { $0.name == name })
    }
}

// MARK: LRC.Content
extension LRC {
    open class Content {}
}

// MARK: LRC.Line
extension LRC {
    open class Line: Content {
        public let time: TimeInterval
        public let text: String
        
        init(time: TimeInterval, text: String) {
            self.time = time
            self.text = text
        }
    }
}

// MARK: LRC.Tag
extension LRC {
    open class Tag: Content {
        public let name: String
        public let content: String
        
        init(name: String, content: String) {
            self.name = name
            self.content = content
        }
    }
}
