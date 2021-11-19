
class DependencyManager {
    private static var registeredEntries: [String: Any] = [:]

    public static func clean() {
        registeredEntries = [:]
    }

    public static func register<T>(_ type: T.Type, provider: @escaping () -> T) {
        let key = String(describing: type)
        registeredEntries[key] = provider
    }

    public static func resolve<T>(_ type: T.Type) -> T {
        let key = String(describing: type)
        guard let providerResolution = registeredEntries[key] as? () -> T else {
            fatalError("Tried to resolve for a dependency which has no providers: \(key)")
        }
        return providerResolution()
    }
}
