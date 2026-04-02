import SwiftUI
import CoreMotion
import Combine

class SlapDetector: ObservableObject {
    private let motionManager = CMMotionManager()

    // Tune this to change how hard the slap needs to be:
    //   2.0 → light tap on the back
    //   2.5 → firm slap (default)
    //   3.5 → really hard hit
    private let slapThreshold: Double = 2.5

    // Prevents one slap from firing multiple times
    private var lastSlapTime: Date = .distantPast
    private let cooldown: TimeInterval = 0.6

    var onSlap: (() -> Void)?

    func start() {
        guard motionManager.isAccelerometerAvailable else { return }
        motionManager.accelerometerUpdateInterval = 1.0 / 100.0  // 100 Hz
        motionManager.startAccelerometerUpdates(to: .main) { [weak self] data, _ in
            guard let self, let data else { return }
            self.process(data)
        }
    }

    func stop() {
        motionManager.stopAccelerometerUpdates()
    }

    private func process(_ data: CMAccelerometerData) {
        let a = data.acceleration
        // Total magnitude — resting phone reads ~1 G (gravity)
        let magnitude = sqrt(a.x * a.x + a.y * a.y + a.z * a.z)
        let impact = abs(magnitude - 1.0)  // subtract gravity baseline

        guard impact > slapThreshold else { return }

        let now = Date()
        guard now.timeIntervalSince(lastSlapTime) > cooldown else { return }
        lastSlapTime = now

        onSlap?()
    }
}

// SwiftUI view modifier
struct SlapModifier: ViewModifier {
    @StateObject private var detector = SlapDetector()
    let action: () -> Void

    func body(content: Content) -> some View {
        content
            .onAppear {
                detector.onSlap = action
                detector.start()
            }
            .onDisappear {
                detector.stop()
            }
    }
}

extension View {
    func onSlap(perform action: @escaping () -> Void) -> some View {
        modifier(SlapModifier(action: action))
    }
}
