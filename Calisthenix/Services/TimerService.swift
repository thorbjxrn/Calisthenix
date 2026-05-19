import SwiftUI

@Observable
@MainActor
final class TimerService {
    private(set) var remainingSeconds: Int = 0
    private(set) var isRunning: Bool = false
    private var timer: Timer?

    var formattedTime: String {
        let m = remainingSeconds / 60
        let s = remainingSeconds % 60
        return String(format: "%d:%02d", m, s)
    }

    func start(seconds: Int) {
        remainingSeconds = seconds
        isRunning = true
        timer?.invalidate()
        let t = Timer(timeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.tick()
            }
        }
        RunLoop.main.add(t, forMode: .common)
        timer = t
    }

    func stop() {
        timer?.invalidate()
        timer = nil
        isRunning = false
    }

    func skip() {
        stop()
        remainingSeconds = 0
    }

    private func tick() {
        guard remainingSeconds > 0 else {
            stop()
            return
        }
        remainingSeconds -= 1
        if remainingSeconds == 0 {
            stop()
        }
    }
}
