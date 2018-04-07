//
//  ImageProcessingRequest.swift
//  Photorama
//
//  Created by Nicholas Ollis on 3/27/18.
//  Copyright © 2018 Big Nerd Ranch. All rights reserved.
//

import Foundation

public class ImageProcessingRequest {
    private var operation: ImageProcessingOperation
    private let queue: OperationQueue
    
    public var priority: ImageProcessor.Priority = .low {
        didSet(oldPriority) {
            guard priority != oldPriority else { return }
            guard !operation.isExecuting else { return }
            let newOp = ImageProcessingOperation(operation: operation, priority: priority)
            operation.cancel()
            operation = newOp
            queue.addOperation(newOp)
        }
    }
    
    init(operation: ImageProcessingOperation, queue: OperationQueue) {
        self.operation = operation
        self.queue = queue
    }
    
    public func cancel() {
        operation.cancel()
    }
}
