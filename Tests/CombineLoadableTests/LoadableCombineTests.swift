//
//  LoadableCombineTests.swift
//  
//
//  Created by JongHo Park on 2022/12/25.
//

import Combine
import XCTest

import Loadable
import CombineLoadable

final class LoadableCombineTests: XCTestCase {

    final class SomeClass {
        let stringSubject: CurrentValueSubject<Loadable<String>, Never> = .init(.notRequested)
        @Published private (set) var age: Loadable<Int> = .notRequested
        private var cancelBag: Set<AnyCancellable> = []

        func sendValue() {
            stringSubject.send(.isLoading(last: nil))
            Just("Hello world")
                .bindLoadable(to: stringSubject)
                .store(in: &cancelBag)
        }

        func sendAgeValue() {
            age = .isLoading(last: nil)
            if #available(iOS 14.0, *) {
                Fail(outputType: Int.self, failure: URLError.init(.badURL))
                    .bindLoadable(to: &$age)
            }
        }

        deinit {
            print("Deinited!")
        }
    }

    func test() {
        var someClass: SomeClass? = SomeClass()
        let subscription = someClass?.stringSubject
            .sink(receiveValue: { value in
                print(value.description)
            })
        someClass?.sendValue()
        someClass = nil
    }

    func testAssign() {
        var someClass: SomeClass? = SomeClass()
        let subscription: AnyCancellable? = someClass?
            .$age
            .sink {
                print($0)
            }
        someClass?.sendAgeValue()
        someClass = nil
    }
}
