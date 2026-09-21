/*
 
 MIT License

 Copyright (c) 2026 ★ Install Package Files

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 
*/

import Foundation

@available(iOS 13.0, *)
final class RESTful {
    
    //MARK: - Enums
    enum HTTPMethod: String { case get }
    
    //MARK: - Singelton
    static let shared = RESTful()
    
    //MARK: - Initializers
    private init() {}
    
    //MARK: - Functions
    func download(at url: URL, completion: @escaping (Result<Data, Error>) -> Void) throws {
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard error == nil else { completion(.failure(error!)); return }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { completion(.failure(NSError(domain: "ResponseError", code: 1, userInfo: [NSLocalizedDescriptionKey: "The response is invalid or doesn't have a statusCode = 200!"]))); return }
            guard let data = data else { completion(.failure(NSError(domain: "DataError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Error retrieving data from task. No data has been found!"]))); return }
            completion(.success(data))
        }.resume()
    }
    
    //MARK: - Unfortunately this doesn't work on iOS 14 and iOS 15.1
    /*
    func fetch<T: Decodable>(path: String, header: [String: String] = ["Content-Type": "application/json"], with method: HTTPMethod, type: T.Type) async throws -> T {
        let (data, response) = try await URLSession.shared.data(for: urlRequest(path: path, with: header, for: method))
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw NSError(domain: "ResponseError", code: 1, userInfo: [NSLocalizedDescriptionKey: "The response is invalid or doesn't have a statusCode = 200!"]) }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(type, from: data)
    }
    
    func download(at url: URL) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw NSError(domain: "ResponseError", code: 1, userInfo: [NSLocalizedDescriptionKey: "The response is invalid or doesn't have a statusCode = 200!"]) }
        return data
    }
    
    private func urlRequest(path: String, with header: [String: String]? = nil, for method: HTTPMethod) throws -> URLRequest {
        guard let url = URL(string: path) else { throw NSError(domain: "URLError", code: 1, userInfo: [NSLocalizedDescriptionKey: "The url is invalid!"]) }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue.uppercased()
        header?.forEach({ request.setValue($0.value, forHTTPHeaderField: $0.key) })
        return request
    }
    */
}
