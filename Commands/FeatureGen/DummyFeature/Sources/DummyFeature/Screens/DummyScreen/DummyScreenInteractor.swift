import Foundation
import AppQualityAssurance

protocol DummyScreenInteractorProtocol: InteractorProtocol {

}

final class DummyScreenInteractor: DummyScreenInteractorProtocol {
    let logger = Logger<Event>()

    enum Event: CategorizedEvents {
        static var categoryName: String {
            "DummyScreen_Interactor"
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

final class MockDummyScreenInteractor: DummyScreenInteractorProtocol {

}
