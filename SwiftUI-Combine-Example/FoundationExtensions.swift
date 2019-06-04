import SwiftUI
import Combine

enum RequestError: Error {
    case request(code: Int, error: Error?)
    case unknown
}

extension URLSession {
    func send(request: URLRequest) -> Publishers.Future<(data: Data, response: HTTPURLResponse), RequestError> {
        Publishers.Future { fulfill in
            let task = self.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    let httpReponse = response as? HTTPURLResponse
                    if let data = data, let httpReponse = httpReponse, 200..<300 ~= httpReponse.statusCode {
                        fulfill(.success((data, httpReponse)))
                    }
                    else if let httpReponse = httpReponse {
                        fulfill(.failure(.request(code: httpReponse.statusCode, error: error)))
                    }
                    else {
                        fulfill(.failure(.unknown))
                    }
                }
            }

            task.resume()

            // Can't cancel ...?
            // AnyCancellable(task.resume)
        }
    }
}

extension JSONDecoder: TopLevelDecoder {}
