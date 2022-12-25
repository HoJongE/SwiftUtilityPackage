//
//  File.swift
//  
//
//  Created by JongHo Park on 2022/12/25.
//

import Combine

import Loadable

@available(iOS 13.0, macOS 10.15, *)
public extension Publisher {

    func sinkToLoadable(_ completion: @escaping (Loadable<Output>) -> Void) -> AnyCancellable {
        sink { result in
            switch result {
            case .failure(let error):
                completion(.failed(error))
            case .finished:
                break
            }
        } receiveValue: { value in
            completion(.loaded(value))
        }
    }

}
