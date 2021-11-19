import Foundation

private let defaultBaseURL: URL = URL(string: "https://api.themoviedb.org")!

class CoreAPIService {
    static var defaultImageURL: String = "https://image.tmdb.org/t/p/w500"

    let networking: Networking
    let baseURL: URL

    init(networking: Networking = URLSession.shared, baseURL: URL = defaultBaseURL) {
        self.networking = networking
        self.baseURL = baseURL
    }

    func perform<T: Decodable>(request: URLRequest,
                               completion: @escaping (Result<T, APIError>) -> Void) {

        func callback(_ result: Result<T, APIError>) {
            DispatchQueue.main.sync { completion(result) }
        }

        networking.perform(with: request) { (data, response, error) in
            if let error = error {
                let apiError = APIError.network(error)
                let result: Result<T, APIError> = .failure(apiError)
                callback(result)
                return
            }
            guard let data = data else {
                let apiError = APIError.noData(response)
                let result: Result<T, APIError> = .failure(apiError)
                callback(result)
                return
            }

            let validStatusCodes = 200..<300

            guard let httpResponse = response as? HTTPURLResponse,
                validStatusCodes.contains(httpResponse.statusCode) else {
                    let apiError = APIError.server(response)
                    let result: Result<T, APIError> = .failure(apiError)
                    callback(result)
                    return
            }

            do {
                let decoder = JSONDecoder()
                let value = try decoder.decode(T.self, from: data)
                let result: Result<T, APIError> = .success(value)
                callback(result)
            } catch {
                let apiError = APIError.decoding(error)
                let result: Result<T, APIError> = .failure(apiError)
                callback(result)
            }
        }
    }

    enum RequiredKey: String {
        case apiKey = "api_key"
    }

    func makeRequest(path: String, httpMethod: String, query: [URLQueryItem] = []) -> URLRequest {
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)!
        urlComponents.path = path

//        let location = Bundle.main.path(forResource: "config", ofType: "txt") ?? ""
//        let key = try? String(
//            contentsOf: URL(fileURLWithPath: location),
//            encoding: .utf8
//        )
        let apiKeyV3 = "396aa785169ed778a7132e7a8dedc31f"
        //let apiKeyV3 = key

        var queryItems = query
        queryItems.append(URLQueryItem(name: RequiredKey.apiKey.rawValue, value: apiKeyV3))
        urlComponents.queryItems = queryItems

        let url = urlComponents.url!

        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        return request
    }
}
