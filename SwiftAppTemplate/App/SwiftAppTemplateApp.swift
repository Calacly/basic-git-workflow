import SwiftUI

@main
struct SwiftAppTemplateApp: App {
    @State private var environment = AppEnvironment()
    @State private var errorCenter = ErrorCenter()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(environment)
                .environment(errorCenter)
                .errorAlert(errorCenter)
        }
    }
}
