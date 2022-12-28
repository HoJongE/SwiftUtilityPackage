//
//  File.swift
//  
//
//  Created by JongHo Park on 2022/12/26.
//

import Combine
import UIKit

final class ImageLoader {

    static let shared: ImageLoader = .init()
    private let networkImageSource: some ImageSource = NetworkImageSource()
    private let diskImageSource: some CacheableImageSource = DiskImageSource()
    private let inMemoryImageSource: some InMemoryImageSource = InMemoryImageSource()

    private init() { }

    func image(
        of url: URL,
        options: [ImageProcessor]) -> AnyPublisher<UIImage, Error> {
        inMemoryImageSource
            .image(of: url)
            .catch { [diskImageSource, inMemoryImageSource] _ in
                diskImageSource
                    .image(of: url)
                    .handleEvents(receiveOutput: {
                        inMemoryImageSource.saveToCache($0, forKey: url)
                    })
            }
            .catch { [diskImageSource, inMemoryImageSource, networkImageSource] _ in
                networkImageSource
                    .image(of: url)
                    .handleEvents(receiveOutput: {
                        inMemoryImageSource.saveToCache($0, forKey: url)
                        diskImageSource.saveToCache($0, forKey: url)
                    })
            }
            .map { [weak self] image in
                return self?.processing(image: image, options: options) ?? image
            }
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .eraseToAnyPublisher()
    }

    func image(
        of url: String,
        options: [ImageProcessor]) -> AnyPublisher<UIImage, Error> {
        guard let url = URL(string: url) else {
            return Fail(outputType: UIImage.self, failure: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        return image(of: url, options: options)
    }
}

private extension ImageLoader {

    func processing(image: UIImage, options: [ImageProcessor]) -> UIImage {
        guard var ciImage: CIImage = image.ciImage ?? CIImage(image: image) else {
            return image
        }

        for option in options {
            ciImage = option.processing(ciImage)
        }

        return UIImage(ciImage: ciImage)
    }

}
