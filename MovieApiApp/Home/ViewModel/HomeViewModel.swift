
import Foundation

protocol HomeViewModelProtocol: AnyObject {
    var homeDetailsIdentifier: String { get }
    var didTapCell: ((_ identifier: String) -> Void)? { get set }
    var api: MovieService { get set }

    init(api: MovieService)

    func goToHomeDetails()
    func didGetMovies()
}

class HomeViewModel: HomeViewModelProtocol {
    var api: MovieService

    required init(api: MovieService) {
        self.api = api
    }

    var homeDetailsIdentifier = "DetailViewController"

    var didTapCell: ((String) -> ())?

    func goToHomeDetails() {
        didTapCell?(homeDetailsIdentifier)
    }

    func didGetMovies() {

        api.getMoviesTopRated(page: 1) { result in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        }
    }
}
