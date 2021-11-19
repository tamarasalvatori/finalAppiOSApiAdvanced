import Foundation
import Alamofire

protocol MovieService {

    func getMoviesTopRated(page: Int, completion: @escaping (Result<MoviesDTO, APIError>) -> Void)
    func getMovieBy(id: String, completion: @escaping (Result<MovieDetailDTO, AFError>) -> Void)
    func downloadImage(imagePath: String, completion: @escaping (Result<URL, AFError>) -> Void)
}

final class LiveMovieService: CoreAPIService, MovieService {

    func getMoviesTopRated(
        page: Int,
        completion: @escaping (Result<MoviesDTO, APIError>) -> Void
    ) {

        let request = makeRequest(
            path: "/3/movie/top_rated",
            httpMethod: HTTPMethod.GET.rawValue,
            query: [URLQueryItem(name: "page", value: "\(page)")]
        )

        perform(request: request, completion: completion)
    }

    func getMovieBy(
        id: String,
        completion: @escaping (Result<MovieDetailDTO, AFError>) -> Void
    ) {
        let request = makeRequest(
            path: "/3/movie/" + id,
            httpMethod: HTTPMethod.GET.rawValue
        )

        AF.request(request).responseDecodable(completionHandler: { response in
            completion(response.result)
        })
    }

    func downloadImage(
        imagePath: String,
        completion: @escaping (Result<URL, AFError>) -> Void
    ) {
        AF.download(imagePath).responseURL { response in
            completion(response.result)
        }
    }
}
