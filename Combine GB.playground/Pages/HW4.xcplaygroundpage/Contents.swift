
import Foundation
import Combine

let baseURL = "https://rickandmortyapi.com/api"
let charactersPath = "/character"
let locationsPath = "/location"
let episodesPath = "/episode"

enum Error: LocalizedError {
    case unreachableAddress(url: URL)
    case invalidResponse
    var errorDescription: String? {
        switch self {
            case .unreachableAddress(let url): return "\(url.absoluteString) is unreachable"
            case .invalidResponse: return "Response with mistake" }
        }
}

// MARK: - Character
struct Characters: Codable {
    let info: Info
    let results: [Character]
}

// MARK: - Info
struct Info: Codable {
    let count, pages: Int
    let next: String
}

// MARK: - Result
struct Character: Codable {
    let id: Int
    let name, status, species, type: String
    let gender: String
    let origin, location: Place
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

// MARK: - Location
struct Place: Codable {
    let name: String
    let url: String
}

struct Locations: Codable {
    let info: Info
    let results: [Location]
}

// MARK: - Result
struct Location: Codable {
    let id: Int
    let name, type, dimension: String
    let residents: [String]
    let url: String
    let created: String
}

// MARK: - Episodes
struct Episodes: Codable {
    let info: Info
    let results: [Episode]
}

// MARK: - Result
struct Episode: Codable {
    let id: Int
    let name, airDate, episode: String
    let characters: [String]
    let url: String
    let created: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case airDate = "air_date"
        case episode, characters, url, created
    }
}

let charactersURL = URL(string: "\(baseURL)" + "\(charactersPath)")!
let locationsURL = URL(string: "\(baseURL)" + "\(locationsPath)")!
let episodesURL = URL(string: "\(baseURL)" + "\(episodesPath)")!

var subscriptions: Set<AnyCancellable> = []

let charactersSubscription = URLSession.shared
    .dataTaskPublisher(for: charactersURL)
    .map(\.data)
    .mapError({ error -> Error in
        switch error {
        case is URLError:
            return Error.unreachableAddress(url: charactersURL)
        default:
            return Error.invalidResponse }
    })
    .decode(type: Characters.self, decoder: JSONDecoder())
    .sink(receiveCompletion: { completion in if case .failure(let err) = completion {
        print("Retrieving data failed with error \(err)") }
    }, receiveValue: { object in
        print("Retrieved object \(object)")
    })
    .store(in: &subscriptions)

let locationsSubscription = URLSession.shared
    .dataTaskPublisher(for: locationsURL)
    .map(\.data)
    .mapError({ error -> Error in
        switch error {
        case is URLError:
            return Error.unreachableAddress(url: charactersURL)
        default:
            return Error.invalidResponse }
    })
    .decode(type: Locations.self, decoder: JSONDecoder())
    .sink(receiveCompletion: { completion in if case .failure(let err) = completion {
        print("Retrieving data failed with error \(err)") }
    }, receiveValue: { object in
        print("Retrieved object \(object)")
    })
    .store(in: &subscriptions)

let episodesSubscription = URLSession.shared
    .dataTaskPublisher(for: episodesURL)
    .map(\.data)
    .mapError({ error -> Error in
        switch error {
        case is URLError:
            return Error.unreachableAddress(url: charactersURL)
        default:
            return Error.invalidResponse }
    })
    .decode(type: Episodes.self, decoder: JSONDecoder())
    .sink(receiveCompletion: { completion in if case .failure(let err) = completion {
        print("Retrieving data failed with error \(err)") }
    }, receiveValue: { object in
        print("Retrieved object \(object)")
    })
    .store(in: &subscriptions)
