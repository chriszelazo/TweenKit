//
//  Easing.swift
//  TweenKit
//
//  Created by Steve Barnegren on 17/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import Foundation

public let kPERIOD: Double = 0.3
public let M_PI_X_2: Double = Double.pi * 2.0

public struct Easing {
    public var curve: EasingCurve
    public var mode: EasingMode
    
    public init(curve: EasingCurve = .linear, mode: EasingMode = .easeInOut) {
        self.curve = curve
        self.mode = mode
    }
    
    public func apply(_ t: Double) -> Double {
        return curve.function(with: mode)(t)
    }
}

public enum EasingMode: String, CaseIterable {
    case easeIn    = "In"
    case easeOut   = "Out"
    case easeInOut = "In Out"
}

public enum EasingCurve: String, CaseIterable {
    case linear = "Linear"
    case sine = "Sine"
    case quadratic = "Quad"
    case cubic = "Cubic"
    case quartic = "Quart"
    case quintic = "Quint"
    case exponential = "Expo"
    case circular = "Circ"
    case back = "Back"
    case elastic = "Elastic"
    case bounce = "Bounce"
    
    public func function(with mode: EasingMode) -> (Double) -> Double {
        switch self {
        case .linear:
            switch mode {
            case .easeIn:    fallthrough
            case .easeOut:   fallthrough
            case .easeInOut: return linear
            }
        case .sine:
            switch mode {
            case .easeIn:    return sineIn
            case .easeOut:   return sineOut
            case .easeInOut: return sineInOut
            }
        case .quadratic:
            switch mode {
            case .easeIn:    return quadraticIn
            case .easeOut:   return quadraticOut
            case .easeInOut: return quadraticInOut
            }
        case .cubic:
            switch mode {
            case .easeIn:    return cubicIn
            case .easeOut:   return quadraticOut
            case .easeInOut: return quadraticInOut
            }
        case .quartic:
            switch mode {
            case .easeIn:    return quarticIn
            case .easeOut:   return quarticOut
            case .easeInOut: return quarticInOut
            }
        case .quintic:
            switch mode {
            case .easeIn:    return quinticIn
            case .easeOut:   return quinticOut
            case .easeInOut: return quinticInOut
            }
        case .exponential:
            switch mode {
            case .easeIn:    return exponentialIn
            case .easeOut:   return exponentialOut
            case .easeInOut: return exponentialInOut
            }
        case .circular:
            switch mode {
            case .easeIn:    return circularIn
            case .easeOut:   return circularOut
            case .easeInOut: return circularInOut
            }
        case .back:
            switch mode {
            case .easeIn:    return backIn
            case .easeOut:   return backOut
            case .easeInOut: return backInOut
            }
        case .elastic:
            switch mode {
            case .easeIn:    return elasticIn
            case .easeOut:   return elasticOut
            case .easeInOut: return elasticInOut
            }
        case .bounce:
            switch mode {
            case .easeIn:    return bounceIn
            case .easeOut:   return bounceOut
            case .easeInOut: return bounceInOut
            }
        }
    }
    
    // MARK: - Linear
    
    private func linear(t: Double) -> Double {
        return t
    }
    
    // MARK: - Sine
    
    private func sineIn(t: Double) -> Double {
        return -1.0 * cos(t * (Double.pi/2)) + 1.0
    }
    
    private func sineOut(t: Double) -> Double {
        return sin(t * (Double.pi/2))
    }
    
    private func sineInOut(t: Double) -> Double {
        return -0.5 * (cos(Double.pi*t) - 1.0)
    }
    
    // MARK: - Quadratic
    
    private func quadraticIn(t: Double) -> Double {
        return t * t
    }
    
    private func quadraticOut(t: Double) -> Double {
        return -t * (t - 2)
    }
    
    private func quadraticInOut(t: Double) -> Double {
        if t < 1 / 2 {
            return 2 * t * t
        } else {
            return (-2 * t * t) + (4 * t) - 1
        }
    }
    
    // MARK: - Cubic
    
    private func cubicIn(t: Double) -> Double {
        return t * t * t
    }
    
    private func cubicOut(t: Double) -> Double {
        let p = t - 1
        return  p * p * p + 1
    }
    
    private func cubicInOut(t: Double) -> Double {
        if t < 1 / 2 {
            return 4 * t * t * t
        } else {
            let f = 2 * t - 2
            return 1 / 2 * f * f * f + 1
        }
    }
    
    // MARK: - Quartic
    
    private func quarticIn(t: Double) -> Double {
        return t * t * t * t
    }
    
    private func quarticOut(t: Double) -> Double {
        let p = t - 1
        return  p * p * p * (1 - t) + 1
    }
    
    private func quarticInOut(t: Double) -> Double {
        if t < 1 / 2 {
            return 8 * t * t * t * t
        } else {
            let f = t - 1
            return -8 * f * f * f * f + 1
        }
    }
    
    // MARK: - Quintic
    
    private func quinticIn(t: Double) -> Double {
        return t * t * t * t * t
    }
    
    private func quinticOut(t: Double) -> Double {
        let f = t - 1
        return f * f * f * f * f + 1
    }
    
    private func quinticInOut(t: Double) -> Double {
        if t < 1 / 2 {
            return 16 * t * t * t * t * t
        } else {
            let f = 2 * t - 2
            return 1 / 2 * f * f * f * f * f + 1
        }
    }
    
    // MARK: - Exponential
    
    private func exponentialIn(t: Double) -> Double {
        return (t == 0.0) ? 0.0 : pow(2.0, 10.0 * (t / 1.0 - 1.0)) - 1.0 * 0.001
    }
    
    private func exponentialOut(t: Double) -> Double {
        return (t == 1.0) ? 1.0 : (-pow(2.0, -10.0 * t / 1.0) + 1.0)
    }
    
    private func exponentialInOut(t: Double) -> Double {
        var t = t
        t /= 0.5
        if t < 1.0 {
            t = 0.5 * pow(2.0, 10.0 * (t - 1.0))
        } else {
            t = 0.5 * (-pow(2.0, -10.0 * (t - 1.0) ) + 2.0)
        }
        return t
    }
    
    // MARK: - Circular
    
    private func circularIn(t: Double) -> Double {
        return 1 - sqrt(1 - t * t)
    }
    
    private func circularOut(t: Double) -> Double {
        return sqrt((2 - t) * t)
    }
    
    private func circularInOut(t: Double) -> Double {
        if t < 1 / 2 {
            let h = 1 - sqrt(1 - 4 * t * t)
            return 1 / 2 * h
        } else {
            let f = -(2 * t - 3) * (2 * t - 1)
            let g = sqrt(f)
            return 1 / 2 * (g + 1)
        }
    }
    
    // MARK: - Back
    
    private func backIn(t: Double) -> Double {
        let overshoot = 1.70158
        return t * t * ((overshoot + 1.0) * t - overshoot)
    }
    
    private func backOut(t: Double) -> Double {
        let overshoot = 1.70158
        var t = t
        t = t - 1.0
        return t * t * ((overshoot + 1.0) * t + overshoot) + 1.0
    }
    
    private func backInOut(t: Double) -> Double {
        let overshoot = 1.70158 * 1.525
        var t = t
        t = t * 2.0
        if (t < 1.0) {
            return (t * t * ((overshoot + 1.0) * t - overshoot)) / 2.0
        } else {
            t = t - 2.0
            return (t * t * ((overshoot + 1.0) * t + overshoot)) / 2.0 + 1.0
        }
    }
    
    // MARK: - Elastic
    
    private func elasticIn(t: Double) -> Double {
        var newT = 0.0
        if (t == 0.0 || t == 1.0) {
            newT = t
        } else {
            var t = t
            let s = kPERIOD / 4.0
            t = t - 1;
            newT = -pow(2, 10 * t) * sin( (t-s) * M_PI_X_2 / kPERIOD)
        }
        return newT
    }
    
    private func elasticOut(t: Double) -> Double {
        var newT = 0.0
        if (t == 0.0 || t == 1.0) {
            newT = t
        } else {
            let s = kPERIOD / 4
            newT = pow(2.0, -10.0 * t) * sin( (t-s) * M_PI_X_2 / kPERIOD) + 1
        }
        return newT
    }
    
    private func elasticInOut(t: Double) -> Double {
        var newT = 0.0
        
        if (t == 0.0 || t == 1.0) {
            newT = t
        } else {
            var t = t
            t = t * 2.0
            let s = kPERIOD / 4
            
            t = t - 1.0
            if (t < 0) {
                newT = -0.5 * pow(2, 10.0 * t) * sin((t - s) * M_PI_X_2 / kPERIOD)
            } else {
                newT = pow(2, -10.0 * t) * sin((t - s) * M_PI_X_2 / kPERIOD) * 0.5 + 1.0
            }
        }
        return newT
    }
    
    // MARK: - Bounce
    
    private func bounceIn(t: Double) -> Double {
        var newT = t
        if (t != 0.0 && t != 1.0) {
            newT = 1.0 - bounceTime(t: 1.0 - t)
        }
        return newT
    }
    
    private func bounceOut(t: Double) -> Double {
        var newT = t
        if (t != 0.0 && t != 1.0) {
            newT = bounceTime(t: t)
        }
        return newT
    }
    
    private func bounceInOut(t: Double) -> Double {
        let newT: Double
        if (t == 0.0 || t == 1.0) {
            newT = t
        } else if (t < 0.5) {
            var t = t
            t = t * 2.0
            newT = (1.0 - bounceTime(t: 1.0-t) ) * 0.5
        } else {
            newT = bounceTime(t: t * 2.0 - 1.0) * 0.5 + 0.5
        }
        
        return newT
    }
    
    private func bounceTime(t: Double) -> Double {
        var t = t
        
        if (t < 1.0 / 2.75) {
            return 7.5625 * t * t
        } else if (t < 2.0 / 2.75) {
            t -= 1.5 / 2.75
            return 7.5625 * t * t + 0.75
        } else if (t < 2.5 / 2.75) {
            t -= 2.25 / 2.75
            return 7.5625 * t * t + 0.9375
        }
        
        t -= 2.625 / 2.75
        return 7.5625 * t * t + 0.984375
    }
}
