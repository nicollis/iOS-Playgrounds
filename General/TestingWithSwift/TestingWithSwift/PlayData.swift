//
//  PlayData.swift
//  TestingWithSwift
//
//  Created by Nic Ollis on 1/18/18.
//  Copyright © 2018 Ollis. All rights reserved.
//

import Foundation

class PlayData {
    var allWords = [String]()
    private(set) var filteredWords = [String]()
    var wordCounts: NSCountedSet!
    
    init() {
        if let path = Bundle.main.path(forResource: "plays", ofType: "txt") {
            if let plays = try? String(contentsOfFile: path) {
                allWords = plays.components(separatedBy: CharacterSet.alphanumerics.inverted)
                allWords = allWords.filter{ $0 != "" }
                
                wordCounts = NSCountedSet(array: allWords)
                let sorted = wordCounts.allObjects.sorted { wordCounts.count(for: $0) > wordCounts.count(for: $1)}
                allWords = sorted as! [String]
                
                applyUser(filter: "swift")
            }
        }
    }
    
    func applyUser(filter input: String) {
        if let userNumber = Int(input) {
            filteredWords = allWords.filter { self.wordCounts.count(for: $0) >= userNumber }
        } else {
            filteredWords = allWords.filter { $0.range(of: input, options: .caseInsensitive) != nil }
        }
    }
}
