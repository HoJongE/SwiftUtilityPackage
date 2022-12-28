//
//  File.swift
//  
//
//  Created by JongHo Park on 2022/12/26.
//

import Combine
import UIKit

struct NetworkImageSource: ImageSource {

    private let session: URLSession = URLSession(configuration: .ephemeral)

    func image(of url: URL) -> AnyPublisher<UIImage, Error> {
        session
            .dataTaskPublisher(for: url)
            .map(\.data)
            .tryMap {
                guard let image = UIImage(data: $0) else {
                    throw ImageSourceError.badData
                }

                return image
            }
            .eraseToAnyPublisher()
    }
}
