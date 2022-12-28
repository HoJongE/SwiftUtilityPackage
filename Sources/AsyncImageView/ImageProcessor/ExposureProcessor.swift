//
//  File.swift
//  
//
//  Created by JongHo Park on 2022/12/28.
//

import UIKit

public struct ExposureProcessor: ImageProcessor {

    private let value: Double

    public init(value: Double) {
        self.value = value
    }

    public func processing(_ image: CIImage) -> CIImage {
        image.applyingFilter("CIExposureAdjust", parameters: [
            kCIInputEVKey: NSNumber(value: value)
        ])
    }

}
