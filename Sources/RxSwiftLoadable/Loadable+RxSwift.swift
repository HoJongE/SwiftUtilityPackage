//
//  File.swift
//  
//
//  Created by JongHo Park on 2022/12/25.
//

import Loadable
import RxSwift

extension Observable {

    func sinkToLoadable(_ completion: @escaping (Loadable<Element>) -> Void) -> Disposable {
        subscribe(onNext: {
            completion(.loaded($0))
        }, onError: {
            completion(.failed($0))
        })
    }

}
