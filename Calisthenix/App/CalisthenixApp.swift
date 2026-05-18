import SwiftUI
import SwiftData

@main
struct CalisthenixApp: App {
    @State private var themeManager = ThemeManager()

    let modelContainer: ModelContainer

    init() {
        let schema = Schema([
            UserStepProgress.self,
            LogEntry.self,
            TrainingPlan.self,
            SplitConfiguration.self
        ])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            modelContainer = try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(modelContainer)
        .environment(themeManager)
    }
}
