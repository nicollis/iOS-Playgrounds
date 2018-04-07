//
//  CustomFiltersVendor.swift
//  Photorama
//
//  Created by Nicholas Ollis on 3/29/18.
//  Copyright © 2018 Big Nerd Ranch. All rights reserved.
//

import Foundation
import CoreImage

public class CustomFiltersVendor: NSObject, CIFilterConstructor {
    public static let IceSheetFilterName = "IceSheetFilter"
    public static let HazeRemoveFilterName = "HazeRemoveFilter"
    
    public static func registerFilters() {
        let classAttributes = [kCIAttributeFilterCategories: ["CustomFilters"]]
        IceSheetFilter.registerName(IceSheetFilterName, constructor: CustomFiltersVendor(), classAttributes: classAttributes)
        HazeRemoveFilter.registerName(HazeRemoveFilterName, constructor: CustomFiltersVendor(), classAttributes: classAttributes)
    }
    
    public func filter(withName name: String) -> CIFilter? {
        switch name
        {
        case CustomFiltersVendor.IceSheetFilterName:
            return IceSheetFilter()
        case CustomFiltersVendor.HazeRemoveFilterName:
            return HazeRemoveFilter()
        default:
            return nil
        }
    }
    
}
