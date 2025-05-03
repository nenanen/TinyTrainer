import HealthKit
import Foundation

class HealthManager: ObservableObject {
    private var healthStore = HKHealthStore()
    @Published var successDays: Int = 0
    @Published var healthKitAvailable = false
    @Published var healthKitDenied = false


    init() {
        requestAuthorization()
    }
    
    func requestAuthorization() {
        let typesToRead: Set = [HKObjectType.activitySummaryType()]

        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { success, error in
            DispatchQueue.main.async {
                if success {
                    self.healthKitAvailable = true
                    self.checkExerciseRing()
                } else {
                    self.healthKitAvailable = false
                    self.healthKitDenied = true
                }
            }
        }
    }


    func checkExerciseRing() {
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.year, .month, .day], from: Date())
        dateComponents.calendar = calendar

        let predicate = HKQuery.predicateForActivitySummary(with: dateComponents)
        let query = HKActivitySummaryQuery(predicate: predicate) { _, summaries, _ in
            guard let summary = summaries?.first else { return }

            let exerciseGoal = summary.appleExerciseTimeGoal.doubleValue(for: .minute())
            let exercise = summary.appleExerciseTime.doubleValue(for: .minute())

            DispatchQueue.main.async {
                if exercise >= exerciseGoal {
                    self.successDays += 1
                }
            }
        }
        healthStore.execute(query)
    }
}
