//
//  ImageLoader.swift
//  GitHubRepos
//
//  Created by Predrag Jevtic on 24. 11. 2025..
//

import UIKit

final class ImageLoader {
    
    static let shared = ImageLoader()
    private let cache = NSCache<NSURL, UIImage>()
    private let session: URLSession

    private init(session: URLSession = .shared) {
        self.session = session
    }

    func loadImage(from url: URL) async throws -> UIImage {
        if let cached = cache.object(forKey: url as NSURL) {
            return cached
        }
        let (data, response) = try await session.data(from: url)
        guard let http = response as? HTTPURLResponse, 200..<300 ~= http.statusCode else {
            throw URLError(.badServerResponse)
        }
        guard let image = UIImage(data: data) else {
            throw URLError(.cannotDecodeContentData)
        }
        cache.setObject(image, forKey: url as NSURL)
        return image
    }
}
