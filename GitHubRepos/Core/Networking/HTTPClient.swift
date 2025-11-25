//
//  HTTPClient.swift
//  GitHubRepos
//
//  Created by Predrag Jevtic on 24. 11. 2025..
//

import Foundation

struct HTTPClient {

    enum HTTPError: Error, LocalizedError {
        case badStatus(Int)
        case decoding(Error)
        case transport(Error)

        var errorDescription: String? {
            switch self {
            case .badStatus(let code): return "Bad status: \(code)"
            case .decoding(let err): return "Decoding error: \(err.localizedDescription)"
            case .transport(let err): return "Network error: \(err.localizedDescription)"
            }
        }
    }

    var session: URLSession = {
        let cfg = URLSessionConfiguration.default
        cfg.timeoutIntervalForRequest = 30
        cfg.httpAdditionalHeaders = ["Accept": "application/vnd.github+json"]
        return URLSession(configuration: cfg)
    }()

    func get<T: Decodable>(_ url: URL) async throws -> T {
        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        do {
            let (data, resp) = try await session.data(for: req)
            guard let http = resp as? HTTPURLResponse, 200..<300 ~= http.statusCode else {
                throw HTTPError.badStatus((resp as? HTTPURLResponse)?.statusCode ?? -1)
            }
            let dec = JSONDecoder()
            dec.keyDecodingStrategy = .convertFromSnakeCase
            return try dec.decode(T.self, from: data)
        } catch let err as HTTPError {
            throw err
        } catch let err as DecodingError {
            throw HTTPError.decoding(err)
        } catch {
            throw HTTPError.transport(error)
        }
    }
}

extension HTTPClient: HTTPClientProtocol {}
