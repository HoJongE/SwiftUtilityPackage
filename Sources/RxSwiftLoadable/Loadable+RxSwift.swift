//
//  File.swift
//  
//
//  Created by JongHo Park on 2022/12/25.
//

import Loadable
import RxSwift
import RxRelay

public extension Observable {

    func sinkToLoadable(_ completion: @escaping (Loadable<Element>) -> Void) -> Disposable {
        subscribe(onNext: {
            completion(.loaded($0))
        }, onError: {
            completion(.failed($0))
        })
    }

    func bindLoadable(to relay: PublishRelay<Loadable<Element>>) -> Disposable {
        sinkToLoadable {
            relay.accept($0)
        }
    }

    func bindLoadable(to relay: BehaviorRelay<Loadable<Element>>) -> Disposable {
        sinkToLoadable {
            relay.accept($0)
        }
    }

}
