//
//  AsyncImageView.swift
//  
//
//  Created by JongHo Park on 2022/12/26.
//

import Combine
import UIKit

import Loadable
import CombineLoadable

public final class AsyncImageView: UIImageView {

    public var retryCountWhenFail: Int

    private var lastSubscription: AnyCancellable?
    private var cancelBag: Set<AnyCancellable> = []
    private let imageState: PassthroughSubject<Loadable<UIImage>, Never> = .init()

    private let imageLoader: ImageLoader = .shared

    private var progressView: UIActivityIndicatorView?
    private var errorView: UIView?

    public init(
        frame: CGRect = .zero,
        contentMode: ContentMode = .scaleAspectFit,
        retryCountWhenFail: Int = 0
    ) {
        self.retryCountWhenFail = retryCountWhenFail
        super.init(frame: frame)
        self.contentMode = contentMode
        setObservers()
    }

    public required init?(coder: NSCoder) {
        fatalError()
    }

}

// MARK: - Public API
public extension AsyncImageView {

    func setImage(
        from url: URL,
        options: [ImageProcessor] = []
    ) {
        image(
            from: url,
            options: options
        )
    }

    func setImage(
        fromURL url: String,
        options: [ImageProcessor] = []
    ) {
        guard let url = URL(string: url) else {
            return
        }
        setImage(
            from: url,
            options: options
        )
    }

}

// MARK: - Implementation
private extension AsyncImageView {

    func setObservers() {

        // UIImage를 바인딩함
        imageState
            .map(\.value)
            .removeDuplicates()
            .assign(to: \.image, on: self)
            .store(in: &cancelBag)

        // 로딩 이벤트를 처리
        imageState
            .map(\.isLoading)
            .removeDuplicates()
            .sink { [weak self] isLoading in
                guard let self else { return }
                if isLoading {
                    self.showProgressView()
                    return
                }
                self.removeProgressView()
            }
            .store(in: &cancelBag)
    }

    func showProgressView() {
        progressView = UIActivityIndicatorView(style: .large)
        addSubview(progressView!)
        progressView!.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            progressView!.centerXAnchor.constraint(equalTo: centerXAnchor),
            progressView!.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        progressView!.startAnimating()
    }

    func removeProgressView() {
        progressView?.removeFromSuperview()
        progressView = nil
    }

    func image(
        from url: URL,
        options: [ImageProcessor]) {
            cancelPreviousLoading()
            loadImageFromLoader(from: url, options: options)
        }

    func cancelPreviousLoading() {
        imageState.send(.notRequested)
        lastSubscription?.cancel()
    }

    func loadImageFromLoader(
        from url: URL,
        options: [ImageProcessor]) {
            imageState.send(.isLoading(last: image))
            lastSubscription = imageLoader
                .image(of: url, options: options)
                .retry(retryCountWhenFail)
                .receive(on: DispatchQueue.main)
                .bindLoadable(to: imageState)
        }
}
