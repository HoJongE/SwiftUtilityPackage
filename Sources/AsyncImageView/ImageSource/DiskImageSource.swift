//
//  File.swift
//  
//
//  Created by JongHo Park on 2022/12/26.
//

import Combine
import UIKit

struct DiskImageSource: CacheableImageSource {

    func image(of url: URL) -> AnyPublisher<UIImage, Error> {
        guard let cacheURL = cacheURL(of: url) else {
            return Fail(outputType: UIImage.self, failure: ImageSourceError.badURL)
                .eraseToAnyPublisher()
        }

        do {
            let data: Data = try Data(contentsOf: cacheURL)
            guard let uiImage: UIImage = UIImage(data: data) else {
                return Fail(outputType: UIImage.self, failure: ImageSourceError.badURL)
                    .eraseToAnyPublisher()
            }

            return Just(uiImage)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()

        } catch {
            return Fail(outputType: UIImage.self, failure: error)
                .eraseToAnyPublisher()
        }
    }

    func saveToCache(_ image: UIImage, forKey key: URL) {
        guard let cacheURL = cacheURL(of: key) else {
            return
        }

        guard let data = image.pngData() else {
            return
        }

        do {
            try data.write(to: cacheURL, options: .atomic)
        } catch {
            #if DEBUG
            print(error)
            #endif
        }
    }

    private func cacheURL(of url: URL) -> URL? {
        guard let baseURL = FileManager
            .default
            .urls(for: .cachesDirectory, in: .userDomainMask)
            .first
        else {
            return nil
        }
        let key = convertURLToKey(url)

        createCacheDirectoryIfNotExist()

        if #available(iOS 16, macOS 13, *) {
            return baseURL
                .appending(path: "ImageCache", directoryHint: .isDirectory)
                .appending(path: key, directoryHint: .notDirectory)
        } else {
            return baseURL
                .appendingPathComponent("ImageCache", isDirectory: true)
                .appendingPathComponent(key, isDirectory: false)
        }
    }

    private func createCacheDirectoryIfNotExist() {
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return
        }

        let fileManager: FileManager = FileManager.default
        let folderPath: URL
        if #available(iOS 16, macOS 13, *) {
            folderPath = url.appending(path: "ImageCache", directoryHint: .isDirectory)
            if !fileManager.fileExists(atPath: folderPath.path()) {
                try? fileManager.createDirectory(at: folderPath, withIntermediateDirectories: false)
            }
        } else {
            folderPath = url.appendingPathComponent("ImageCache", isDirectory: true)
            if !fileManager.fileExists(atPath: folderPath.path) {
                try? fileManager.createDirectory(at: folderPath, withIntermediateDirectories: false)
            }
        }
    }

}
