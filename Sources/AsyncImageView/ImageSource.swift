//
//  File.swift
//  
//
//  Created by JongHo Park on 2022/12/26.
//

import Combine
import Foundation
import UIKit

protocol ImageSource {
    func image(of url: URL) -> AnyPublisher<UIImage, Error>
}

protocol CacheableImageSource: ImageSource {
    func saveToCache(_ image: UIImage, forKey key: URL)
}

extension ImageSource {

    func convertURLToKey(_ url: URL) -> String {
        return url.absoluteString.components(separatedBy: CharacterSet.punctuationCharacters).joined(separator: "")
    }

}
