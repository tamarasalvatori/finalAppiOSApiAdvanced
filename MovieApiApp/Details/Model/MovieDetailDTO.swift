import Foundation

struct MovieDetailDTO: Decodable {
    let id: Int?
    let title: String?
    let imdb_id: String?
    let poster_path: String?
    let original_title: String?
    let overview: String?
}
