import SwiftUI
import Combine

final class SearchUserViewModel: BindableObject {
    var didChange = PassthroughSubject<SearchUserViewModel, Never>()

    var name = "ra1028" {
        didSet { didChange.send(self) }
    }

    private(set) var users = [User]() {
        didSet { didChange.send(self) }
    }

    private(set) var userImages = [User: UIImage]() {
        didSet { didChange.send(self) }
    }

    private var searchCancellable: Cancellable? {
        didSet { oldValue?.cancel() }
    }

    deinit {
        searchCancellable?.cancel()
    }

    func search() {
        guard !name.isEmpty else {
            return users = []
        }

        var urlComponents = URLComponents(string: "https://api.github.com/search/users")!
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: name)
        ]

        var request = URLRequest(url: urlComponents.url!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        searchCancellable = URLSession.shared.send(request: request)
            .decode(type: SearchUserResponse.self, decoder: JSONDecoder())
            .map { $0.items }
            .replaceError(with: [])
            .assign(to: \.users, on: self)
    }

    func fetchImage(for user: User) {
        guard case .none = userImages[user] else {
            return
        }

        let request = URLRequest(url: user.avatar_url)
        _ = URLSession.shared.send(request: request)
            .map { UIImage(data: $0) }
            .replaceError(with: nil)
            .sink(receiveValue: { [weak self] image in
                self?.userImages[user] = image
            })
    }
}
