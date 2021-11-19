
import Foundation

protocol HomeDetailViewModelProtocol: AnyObject {
    var api: MovieService { get set }
    var didUpdateView: ((MovieDetailDTO) -> Void)? { get set }
    var didUpdateImageView: ((URL) -> Void)? { get set }

    func didGetMovieDetail(id: String)
}

class DetailViewModel: HomeDetailViewModelProtocol {

    var didUpdateImageView: ((URL) -> Void)?
    var didUpdateView: ((MovieDetailDTO) -> Void)?

    var api: MovieService

    required init() {
        self.api = DependencyManager.resolve(MovieService.self)
    }

    func didGetMovieDetail(id: String) {

        api.getMovieBy(id: id) { [weak self] result in
            switch result {
            case .success(let data):
                self?.didUpdateView?(data)
                self?.didDownloadImage(
                    for: CoreAPIService.defaultImageURL + (data.poster_path ?? "")
                )
            case .failure(let error):
                print(error)
            }
        }
    }

    func didDownloadImage(for path: String) {

        api.downloadImage(imagePath: path) { [weak self] result in
            switch result {
            case .success(let imageURL):
                self?.didUpdateImageView?(imageURL)
            case .failure(let error):
                print(error)
            }

        }
    }
}
