//
//  File.swift
//  
//
//  Created by JongHo Park on 2022/12/25.
//

import Combine

import Loadable

public extension Publisher {

    @available(iOS 13.0, macOS 10.15, *)
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

    @available(iOS 13.0, macOS 10.15, *)
    func bindLoadable<S: Subject>(to subject: S) -> AnyCancellable where S.Output == Loadable<Output>, S.Failure == Never {
        sinkToLoadable {
            subject.send($0)
        }
    }

    @available(iOS 14.0, macOS 11, *)
    func bindLoadable(to published: inout Published<Loadable<Output>>.Publisher) {
        map {
            Loadable<Output>.loaded($0)
        }
        .catch {
            Just(Loadable.failed($0))
        }
        .assign(to: &published)
    }

}
