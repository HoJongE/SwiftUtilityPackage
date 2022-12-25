//
//  Loadable.swift
//  
//
//  Created by JongHo Park on 2022/12/25.
//

import Foundation

public enum Loadable<Value> {
    case notRequested
    case isLoading(last: Value?)
    case loaded(Value)
    case failed(Error)
}

// MARK: - toString
extension Loadable: CustomStringConvertible where Value: CustomStringConvertible {

    public var description: String {
        switch self {
        case .notRequested:
            return "\(Value.self) is not requested yet"
        case .isLoading(let last):
            return "\(Value.self) is loading... last value was \(String(describing: last))"
        case .loaded(let value):
            return "data loaded: \(value.description)"
        case .failed(let error):
            return "fail to load: \(error.localizedDescription)"
        }
    }

}

// MARK: - Equatable
extension Loadable: Equatable where Value: Equatable {

    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.notRequested, .notRequested):
            return true
        case (.isLoading(let first), .isLoading(let second)):
            return first == second
        case (.loaded(let first), .loaded(let second)):
            return first == second
        default:
            return false
        }
    }

}

// MARK: - Property
public extension Loadable {

    var isLoading: Bool {
        switch self {
        case .isLoading:
            return true
        default:
            return false
        }
    }

    var value: Value? {
        switch self {
        case .isLoading(let last):
            return last
        case .loaded(let value):
            return value
        default:
            return nil
        }
    }

    var error: Error? {
        switch self {
        case .failed(let error):
            return error
        default:
            return nil
        }
    }

}

// MARK: - Utility
public extension Loadable {

    func map<V>(_ transform: (Value) throws -> V) -> Loadable<V> {
        do {
            switch self {
            case .notRequested:
                return .notRequested
            case .isLoading(let last):
                return .isLoading(last: try last.map(transform))
            case .loaded(let value):
                return .loaded(try transform(value))
            case .failed(let error):
                return .failed(error)
            }
        } catch {
            return .failed(error)
        }
    }

}
