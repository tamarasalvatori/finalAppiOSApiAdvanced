
class DependencyInjector {
    static func load() {
        DependencyManager.register(MovieService.self) {
            LiveMovieService()
        }
    }
}
