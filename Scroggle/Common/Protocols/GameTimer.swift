//
//  GameTimer.swift
//  Scroggle
//
//  Created by Eric Internicola on 10/21/17.
//  Copyright © 2017 Eric Internicola. All rights reserved.
//

import Foundation

// TODO: Stop using a Game Timer protocol and just use NotificationCenter

@available(*, deprecated, message: "In favor of using NotificationCenter, see Notification+Scroggle.swift for more details")
protocol GameTimerDelegate {

    /// Tells you that time elapsed on the game timer (for a game without a finite amount of time)
    ///
    /// - Parameters:
    ///   - source: The (source) GameTimer that the event came from
    ///   - time: The amount of time that's elapsed.
    func timeDidElapse(_ source: GameTimer, time: Int)

    /// Tells you that time has elapsed on the game timer and there is a finite amount of time left.
    ///
    /// - Parameters:
    ///   - source: The (source) GameTimer that the event came from.
    ///   - time: The amount of time that's elapsed so far.
    ///   - remainingTime: The amount of time that's remaining.
    func timeDidElapse(_ source: GameTimer, time: Int, remainingTime: Int)

    /// Tells you that time has run out on the timer.
    ///
    /// - Parameter source: The (source) GameTimer that the event came from.
    func timeDidRunout(_ source: GameTimer)

}

// MARK: - GameTimer

@available(*, deprecated, message: "In favor of using NotificationCenter, see Notification+Scroggle.swift for more details")
protocol GameTimer {
    /// An optional delegate who will listen for the timer events
    var delegate: GameTimerDelegate? { get set }

    /// The game time type (length of time)
    var timeType: GameTimeType { get set }

    /// The total time that the timer was set for (this doesn't change)
    var totalSeconds: Int { get }

    /// How much longer remains on the timer?
    var remainingSeconds: Int { get }

    /// The String representation for the amount of time elapsed
    var elapsedTimeString: String { get }

    /// The String representation for the amount of time remaining.
    var remainingTimeString: String { get }

    /// Is the timer running?
    var running: Bool { get }

    /// Starts the clock
    func startTimer()

    /// Stops the clock
    func stopTimer()

}


// MARK: - DefaultGameTimer

@available(*, deprecated, message: "In favor of using NotificationCenter, see Notification+Scroggle.swift for more details")
class DefaultGameTimer: GameTimer {

    struct Configuration {
        static var timerIncrementValue: TimeInterval = 1
    }

    public var delegate: GameTimerDelegate? = nil

    /// The Timer "Type" (see GameTimeType)
    public var timeType: GameTimeType = .undefined
    /// The total time that the timer was set for (this doesn't change)
    public var totalSeconds: Int = 0
    /// How much longer remains on the timer?
    public var remainingSeconds: Int = 0
    /// How many seconds have elapsed?
    var elapsedSeconds: Int = 0
    /// The String representation for the amount of time elapsed
    public var elapsedTimeString = ""
    /// The String representation for the amount of time remaining.
    public var remainingTimeString = ""
    /// Is the timer paused?
    var paused = false
    /// Is the timer stopped (meaning its run out of its time)?
    var stopped: Bool {
        return paused || !running
    }
    /// Is the timer running?
    public var running = false

    /**
     Initializes this GameTimer with the specified amount of time.
     - Parameter timeType: The GameTimeType that you want to use as a preset.  Note: This should not be ``GameTimeType.Custom``
     */
    init(timeType: GameTimeType) {
        self.timeType = timeType != .custom ? timeType : .default
        configureByTimeType()
        calculateRemainingTime()
    }

    /**
     Initializes this GameTimer with a custom amount of time.
     - Parameter customTime: The amount of time you want the timer to have.
     */
    init(customTime: Int) {
        timeType = .custom
        setTotalAndRemaining(customTime)
        calculateRemainingTime()
    }

}

// MARK: - API

extension DefaultGameTimer {

    func reset() {
        totalSeconds = 0
        remainingSeconds = 0
        elapsedSeconds = 0
        paused = false
        running = false
    }

    /**
     Starts the clock!
     */
    func startTimer() {
        if !running {
            running = true

            DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + Configuration.timerIncrementValue) {
                self.decrementTimer()
            }
        }
    }

    func decrementTimer() {
        if paused {
            running = false
            paused = false
            return
        }

        if elapsedSeconds == 0 {
            DLog("Timer Started")  // debug
        }
        calculateRemainingTime()
        notifyDelegate()
        if timeType == .infinite || remainingSeconds > 0 {
            DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + Configuration.timerIncrementValue) {
                self.elapsedSeconds += 1
                self.decrementTimer()
            }
        }
    }

    /**
     Stops the clock!/Users/einternicola/Code/Personal/scroggle/Scroggle/Common/Extensions
     */
    func stopTimer() {
        paused = true
    }

    /**
     If the timer is paused, then unpause and resume it.
     */
    func resumeTimer() {
        if stopped {
            DLog("Resuming Timer")
            paused = false
            startTimer()
        }
    }

}

// MARK: - Helper Methods

extension DefaultGameTimer {

    func calculateRemainingTime() {
        if timeType == .infinite {
            remainingTimeString = "∞"
        } else {
            remainingSeconds = totalSeconds - elapsedSeconds
            remainingTimeString = remainingSeconds.timeString
        }
        elapsedTimeString = elapsedSeconds.timeString
    }

    func notifyDelegate() {
        if let delegate = self.delegate {
            if timeType == .infinite {
                delegate.timeDidElapse(self, time: elapsedSeconds)
            } else {
                delegate.timeDidElapse(self, time: elapsedSeconds, remainingTime: remainingSeconds)
                if remainingSeconds <= 0 {
                    remainingSeconds = 0
                    DLog("delegating timeDidRunOut Event")
                    running = false
                    paused = true
                    delegate.timeDidRunout(self)
                }
            }
        } else {
            DLog("No Timer Delegate to notify")
        }
    }

    func setTotalAndRemaining(_ time: Int) {
        totalSeconds = time
        remainingSeconds = time
    }



    /**
     Configures the total and remaining seconds based on the time type.
     */
    func configureByTimeType() {
        switch(timeType) {
        case .infinite:
            setTotalAndRemaining(-1)
            break
        case .custom:
            // nothing to do
            break
        default:
            if let time = timeType.seconds {
                setTotalAndRemaining(time)
            } else {
                setTotalAndRemaining(-1)
            }
            break
        }
    }
}
