import SwiftUI
import AppQualityAssurance

struct DummyScreen<Presenter: DummyScreenPresenterProtocol>: View, VIPERScreen {
    @ObservedObject var presenter: Presenter

    let logger = Logger<Event>()

    var body: some View {
        Text("DummyScreen")
    }

    enum Event: CategorizedEvents {
        static var categoryName: String {
            "DummyScreen_View"
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

struct DummyScreen_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(MockDummyScreenPresenter.mockPresenters) { presenter in
            BuiltView {
                ViewConstructor.build(
                    DummyScreen.self,
                    presenter: presenter
                )
            }
            .previewDisplayName(presenter.previewName)
        }
    }
}
