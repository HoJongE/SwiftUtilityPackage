//
//  File.swift
//  
//
//  Created by JongHo Park on 2022/12/28.
//

import UIKit

public struct ContrastProcessor: ImageProcessor {

    private let value: Double

    public init(value: Double) {
        self.value = value
    }

    public func processing(_ image: CIImage) -> CIImage {
        image.applyingFilter("CIColorControls", parameters: [
            kCIInputContrastKey: NSNumber(value: value)
        ])
    }

}
