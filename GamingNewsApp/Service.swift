import Foundation
import SwiftyJSON

class Service {
    
    enum Error: Swift.Error {
        case invalidJson(message: String)
        case missingJsonProperty(name: String)
        case missingResponseData
        case noNetwork
        case unexpectedStatusCode(code: Int, expected: Int)
        case other(Swift.Error)
    }
    
    static let shared = Service()
    
    private let url: URL
    private let session: URLSession
    
    private init() {
        let path = Bundle.main.path(forResource: "Properties", ofType: "plist")!
        let properties = NSDictionary(contentsOfFile: path)!
        url = URL(string: properties["baseUrl"] as! String)!
        session = URLSession(configuration: .ephemeral)
    }
    
    func loadDataTask(completionHandler: @escaping (Result<[Post]>) -> Void) -> URLSessionTask {
        return session.dataTask(with: url) {
            data, response, error in
            
            // Wrap the completionHandler so it runs on the main queue.
            let completionHandler: (Result<[Post]>) -> Void = {
                result in
                DispatchQueue.main.async {
                    completionHandler(result)
                }
            }
            
            guard let response = response as? HTTPURLResponse else {
                completionHandler(.failure(.noNetwork))
                return
            }
            guard response.statusCode == 200 else {
                completionHandler(.failure(.unexpectedStatusCode(code: response.statusCode, expected: 200)))
                return
            }
            guard let data = data else {
                completionHandler(.failure(.missingResponseData))
                return
            }
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []),
                let results = json as? [[String: Any]] else {
                    completionHandler(.failure(.invalidJson(message: "data does not contain an array of objects")))
                    return
            }
            do {
                let posts = try results.map {
                        try Post(json: $0)
                }
                completionHandler(.success(posts))
            } catch let error as Error {
                completionHandler(.failure(error))
            } catch {
                completionHandler(.failure(.other(error)))
            }

        }
    }
}
