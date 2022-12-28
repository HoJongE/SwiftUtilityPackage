//
//  File.swift
//  
//
//  Created by JongHo Park on 2022/12/28.
//

import UIKit

public protocol ImageProcessor {
    func processing(_ image: CIImage) -> CIImage
}

public extension ImageProcessor where Self == ContrastProcessor {

    static func contrast(_ contrast: Double) -> Self {
        ContrastProcessor(value: contrast)
    }

}

public extension ImageProcessor where Self == ExposureProcessor {

    static func exposure(_ exposure: Double) -> Self {
        ExposureProcessor(value: exposure)
    }

}
