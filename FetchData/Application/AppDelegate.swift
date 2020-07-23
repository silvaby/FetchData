import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
}

final class ServiceLocator {
    /// A shared singleton object.
    static let shared = ServiceLocator()
    lazy var personsManager = PersonsManager()
}
