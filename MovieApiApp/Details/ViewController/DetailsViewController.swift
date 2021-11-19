
import UIKit

class DetailsViewController: UIViewController {

    var viewModel: HomeDetailViewModelProtocol! {
        didSet {
            self.viewModel.didUpdateView = { [weak self] model in
                self?.didUpdateView(with: model)
            }

            self.viewModel.didUpdateImageView = { [weak self] imageURL in
                self?.movieImageView.image = UIImage(contentsOfFile: imageURL.path)
            }
        }
    }

    var movieID: String?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = DetailViewModel()
        viewModel.didGetMovieDetail(id: movieID ?? String())
    }

    func didUpdateView(with model: MovieDetailDTO) {
        titleLabel.text = model.title
    }
}
