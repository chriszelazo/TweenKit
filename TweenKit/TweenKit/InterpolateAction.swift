//
//  InterpolateAction.swift
//  TweenKit
//
//  Created by Steve Barnegren on 17/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import Foundation

public enum TweeningOption {
    case none
    case yoyo
    case reset
}

fileprivate enum TweenableValue<T: Tweenable> {
    case constant(T)
    case dynamic( () -> (T) )
    
    internal func getValue() -> T {
        switch self {
        case .constant(let value):
            return value
        case .dynamic(let closure):
            return closure()
        }
    }
}

public enum TweenableMotion {
    case curve(Easing)
    case spring(DampedHarmonicSpring)
    
    internal func apply(_ t: TimeInterval) -> Double {
        switch self {
        case .curve(let easing):
            return easing.apply(t)
        case .spring(let spring):
            return Double(spring.position(at: t))
        }
    }
    
    public var easing: Easing? {
        guard case .curve(let easing) = self else {
            return nil
        }
        return easing
    }
    
    public var spring: DampedHarmonicSpring? {
        guard case .spring(let spring) = self else {
            return nil
        }
        return spring
    }
    
    public var description: String {
        switch self {
        case .curve(let easing):
            return "\(easing.curve.rawValue), \(easing.mode.rawValue)"
        case .spring(_):
            return "Spring"
        }
    }
}

/** Action to animate between two values */
public class InterpolationAction<T: Tweenable>: FiniteTimeAction, SchedulableAction {

    // MARK: - Public

    public var onBecomeActive: () -> () = {}
    public var onBecomeInactive: () -> () = {}
    public var motion: TweenableMotion
    
    /**
     Create action to interpolate between two values
     - Parameter startValue: The value to animate from
     - Parameter endValue: The value to animate to
     - Parameter duration: The duration of the animation
     - Parameter easing: The easing function to use
     - Parameter update: Callback with the interpolated value
     */
    public init(from startValue: T,
                to endValue: T,
                duration: Double,
                motion: TweenableMotion,
                update: @escaping (_: T) -> ()) {
        
        self.duration = duration
        self.updateHandler = update
        self.motion = motion
        
        self.startTweenableValue = .constant(startValue)
        self.endTweenableValue = .constant(endValue)
    }
    
    /**
     Create action to interpolate between two values
     - Parameter startValue: Closure that supplies the value to animation from (called just before the animation will begin)
     - Parameter endValue: The value to animate to
     - Parameter duration: The duration of the animation
     - Parameter easing: The easing function to use
     - Parameter update: Callback with the interpolated value
     */
    public init(from startValue: @escaping () -> (T),
                to endValue: T,
                duration: Double,
                motion: TweenableMotion,
                update: @escaping (_: T) -> ()) {
        
        self.duration = duration
        self.updateHandler = update
        self.motion = motion
        
        self.startTweenableValue = .dynamic(startValue)
        self.endTweenableValue = .constant(endValue)
    }
    
    /**
     Create action to interpolate between two values
     - Parameter startValue: The value to animate from
     - Parameter endValue: The value to animate to
     - Parameter speed: The speed of the animation
     - Parameter easing: The easing function to use
     - Parameter update: Callback with the interpolated value
     */
    public init(from startValue: T,
                to endValue: T,
                speed: Double,
                motion: TweenableMotion,
                update: @escaping (_: T) -> ()) {

        var distance = startValue.distanceTo(other: endValue)
        if distance < 0 {
            assert(true, "Distance returned from distanceTo(other:) in \(type(of: startValue)) must be positive.")
            distance = -distance
        }

        self.motion = motion
        self.duration = distance / speed
        self.updateHandler = update
        self.startTweenableValue = .constant(startValue)
        self.endTweenableValue = .constant(endValue)
    }
    
    
    // MARK: - Properties
    
    public var reverse = false
    public var duration = Double(0)

    private var startTweenableValue: TweenableValue<T>
    private var endTweenableValue: TweenableValue<T>

    private var startValue: T!
    private var endValue: T!
    
    var updateHandler: (_: T) -> () = {_ in}

    // MARK: - Methods
    
    public func willBecomeActive() {
        
        if startValue == nil {
            startValue = startTweenableValue.getValue()
        }
        
        if endValue == nil {
            endValue = endTweenableValue.getValue()
        }
        
        onBecomeActive()
    }
    
    public func didBecomeInactive() {
        onBecomeInactive()
    }
    
    public func willBegin() {
    }
    
    public func didFinish() {
        self.update(t: reverse ? 0.0 : 1.0)
    }
    
    public func update(t: Double) {
        
        // Apply easing
        var t = t
        t = motion.apply(t)
        
        // Calculate value
        let newValue = startValue.lerp(t: t, end: endValue)
        
        // Call the update handler
        updateHandler(newValue)
    }
    
}
 

