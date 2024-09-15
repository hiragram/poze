import Foundation

@MainActor protocol DummyScreenPresenterProtocol: ObservableObject, PresenterProtocol where Interactor: DummyScreenInteractorProtocol, Router: DummyScreenRouterProtocol {

}

@MainActor final class DummyScreenPresenter<Interactor: DummyScreenInteractorProtocol, Router: DummyScreenRouterProtocol>: DummyScreenPresenterProtocol {
    var interactor: Interactor
    var router: Router

    init(interactor: Interactor, router: Router) {
        self.interactor = interactor
        self.router = router
    }

    let logger = Logger<Event>()

    enum Event: CategorizedEvents {
        static var categoryName: String {
            "DummyScreen_Presenter"
        }

        var eventName: String {
            fatalError()
        }

        var parameters: [String: CustomStringConvertible] {
            fatalError()
        }

        var logLevel: LogLevel {
            fatalError()
        }

        var content: LogMessage {
            fatalError()
        }
    }
}

struct DummyScreenEntity {

}

@MainActor final class MockDummyScreenPresenter: DummyScreenPresenterProtocol, MockPresenterProtocol, Identifiable {

    let id = UUID()

    var previewName: String?

    var interactor = MockDummyScreenInteractor()
    var router = MockDummyScreenRouter()

    init() {}

    static let mockPresenters: [MockDummyScreenPresenter] = [
        .default,
    ]

    static let `default`: MockDummyScreenPresenter = MockDummyScreenPresenter.with({ p in 
    
    })
}
