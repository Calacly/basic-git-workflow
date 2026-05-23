import Foundation

/// Minimal `Codable` cache backed by the caches directory. Good for offline
/// snapshots and lightweight persistence; for relational or queryable data,
/// adopt SwiftData instead.
struct FileStore {
    static let shared = FileStore()

    private let directory: URL
    private let fileManager = FileManager.default

    init(directoryName: String = "store") {
        let base = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        directory = base.appendingPathComponent(directoryName, isDirectory: true)
        try? fileManager.createDirectory(at: directory, withIntermediateDirectories: true)
    }

    func save<T: Encodable>(_ value: T, forKey key: String) throws {
        let data = try JSONEncoder().encode(value)
        try data.write(to: url(for: key), options: .atomic)
    }

    func load<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        guard let data = try? Data(contentsOf: url(for: key)) else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }

    func remove(forKey key: String) {
        try? fileManager.removeItem(at: url(for: key))
    }

    private func url(for key: String) -> URL {
        directory.appendingPathComponent(key).appendingPathExtension("json")
    }
}
