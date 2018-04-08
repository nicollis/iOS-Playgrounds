//
//  Locked.swift
//  Wordalysis
//
//  Created by Nicholas Ollis on 3/28/18.
//  Copyright © 2018 Big Nerd Ranch. All rights reserved.
//

import Foundation

class Locked<Content> {
    private var content: Content
    private let semaphore = DispatchSemaphore(value: 1)
    
    init(_ content: Content) {
        self.content = content
    }
    
    func withLock<Return>(_ workItem: (inout Content) throws -> Return, timeout: DispatchTime) rethrows -> Return? {
        let result = semaphore.wait(timeout: timeout)
        guard result == .success else { return nil }
        let retVal = try workItem(&content)
        semaphore.signal()
        return retVal
    }
}
