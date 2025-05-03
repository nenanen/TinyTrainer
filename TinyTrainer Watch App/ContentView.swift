import SwiftUI
import WatchKit

struct ContentView: View {
    @ObservedObject var manager = BlobGridManager()
    @EnvironmentObject var healthManager: HealthManager
    @State private var showingInfo = false
    

    var body: some View {
        ZStack {
            // Check if HealthKit is available or denied
            if healthManager.healthKitDenied {
                // Display message if HealthKit permission is denied
                Text("Health data not available.\nPlease enable Health access in Settings.")
                    .multilineTextAlignment(.center)
                    .padding()
                    .foregroundColor(.red)
            } else if !healthManager.healthKitAvailable {
                // Display loading indicator while checking HealthKit permission
                ProgressView("Loading Health Data...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            } else {
                // Show the snake grid once HealthKit is available
                VStack(spacing: 1) {
                    ForEach(0..<16, id: \.self) { y in
                        HStack(spacing: 1) {
                            ForEach(0..<16, id: \.self) { x in
                                Rectangle()
                                    .fill(manager.grid[y][x] == 1 ? Color.green : Color.black)
                                    .frame(width: 8, height: 8)
                            }
                        }
                    }
                }
                .padding(.bottom, 16)
            }

// // uncomment to debug locally
//            VStack {
//                Spacer()
//                HStack {
//                    Spacer()
//                    Button(action: {
//                        showingInfo.toggle()
//                    }) {
//                        Image(systemName: "questionmark")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 15, height: 15)
//                            .padding(6)
//                            .background(Circle().stroke(Color.gray, lineWidth: 2))
//                            .foregroundColor(.gray)
//                    }
//                    .buttonStyle(.plain)
//                    .padding([.bottom, .trailing], 4)
//                    .sheet(isPresented: $showingInfo) {
//                        InfoPanel(manager: manager)
//                    }
//                }
//            }
        }
        .background(Color.black)
    }
}

struct InfoPanel: View {
    @ObservedObject var manager: BlobGridManager

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                Text("Rings Closed Streak")
                    .font(.headline)
//                Text("Days: \(manager.findBlob()?.count ?? 0)")
                Button("Add Day (Test)") {
                    manager.addSegment()
                }
                .buttonStyle(.bordered)
            }
            .padding()
        }
    }
}
