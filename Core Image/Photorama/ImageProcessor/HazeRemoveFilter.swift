//
//  HazeRemoveFilter.swift
//  Photorama
//
//  Created by Nicholas Ollis on 3/27/18.
//  Copyright © 2018 Big Nerd Ranch. All rights reserved.
//

import Foundation
import CoreImage

public class HazeRemoveFilter: CIFilter {
    @objc dynamic var inputImage: CIImage?
    @objc dynamic var inputColor: CIColor = CIColor.white
    @objc dynamic var inputDistance: NSNumber = 0.2
    @objc dynamic var inputSlope: NSNumber = 0
    
    public override var attributes: [String : Any] {
        return [
            kCIAttributeFilterDisplayName: "Remove Haze",
            
            "inputImage": [kCIAttributeIdentity: 0,
                           kCIAttributeClass: "CIImage",
                           kCIAttributeDisplayName: "Image",
                           kCIAttributeType: kCIAttributeTypeImage],
            
            "inputDistance": [kCIAttributeIdentity: 0,
                              kCIAttributeClass: "NSNumber",
                              kCIAttributeDisplayName: "Distance Factor",
                              kCIAttributeDefault: 0.2,
                              kCIAttributeMin: 0,
                              kCIAttributeMax: 1,
                              kCIAttributeSliderMin: 0,
                              kCIAttributeSliderMax: 0.7,
                              kCIAttributeType: kCIAttributeTypeScalar],
            "inputSlope": [kCIAttributeIdentity: 0,
                              kCIAttributeClass: "NSNumber",
                              kCIAttributeDisplayName: "Slope Factor",
                              kCIAttributeDefault: 0.2,
                              kCIAttributeSliderMin: -0.01,
                              kCIAttributeSliderMax: 0.01,
                              kCIAttributeType: kCIAttributeTypeScalar],
            kCIInputColorKey: [
                kCIAttributeDefault: CIColor.white
            ]
        ]
    }
    
    private lazy var hazeRemovalKernal: CIColorKernel? = {
        guard let path = Bundle.main.path(forResource: "HazeRemove", ofType: "cikernel"), let code = try? String(contentsOfFile: path) else { fatalError("Failed to load HazeRemove.cikernel from bundle") }
        let kernel = CIColorKernel(source: code)
        return kernel
    }()
    
    public override var outputImage: CIImage? {
        get {
            if let inputImage = self.inputImage {
                return hazeRemovalKernal?.apply(extent: inputImage.extent, arguments: [
                    inputImage as Any,
                    inputColor,
                    inputDistance,
                    inputSlope
                    ])
            } else {
                return nil
            }
        }
    }
}
