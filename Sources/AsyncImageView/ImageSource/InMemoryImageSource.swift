//
//  File.swift
//  
//
//  Created by JongHo Park on 2022/12/26.
//

import Combine
import UIKit

final class InMemoryImageSource: CacheableImageSource {

    private let cacheSource: NSCache<NSString, UIImage> = .init()

    init() { }

    func image(of url: URL) -> AnyPublisher<UIImage, Error> {
        let key = NSString(string: convertURLToKey(url))
        guard let image = cacheSource.object(forKey: key) else {
            return Fail<UIImage, Error>(error: ImageSourceError.notExistInCache)
                .eraseToAnyPublisher()
        }

        return Just(image)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func saveToCache(_ image: UIImage, forKey key: URL) {
        let key = NSString(string: convertURLToKey(key))
        cacheSource.setObject(image, forKey: key)
    }
}
