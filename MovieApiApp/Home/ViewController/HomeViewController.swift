import UIKit

class HomeViewController: UIViewController {

    var viewModel: HomeViewModelProtocol! {
        didSet {
            self.viewModel.didTapCell = { [unowned self] identifier in
                self.performSegue(withIdentifier: identifier, sender: self)
            }
        }
    }

    //deveria popular a movieList com a response da API - está retornando 0
    var movieList = [MovieDTO]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"

        DependencyInjector.load()

        viewModel = HomeViewModel(
            api: DependencyManager.resolve(MovieService.self)
        )

        collectionView.dataSource = self

        viewModel.didGetMovies()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == viewModel.homeDetailsIdentifier {
            let vc = segue.destination as? DetailsViewController
            vc?.movieID = "155"
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
        //return movieList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell

        //let movie = movieList[indexPath.row]

        cell.backgroundColor = .orange

        //cell.movieImage.image = UIImage(contentsOfFile: movie.backdrop_path!)

        return cell
    }


}
