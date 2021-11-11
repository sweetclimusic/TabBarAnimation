//
//  AnimationStateManager.swift
//  TabBarAnimation
//
//  Created by ashlee.muscroft on 10/11/2021.
//

import SwiftUI

class AnimationStateManager {
    enum AnimationState: String, CaseIterable{
        case start
        case opening
        case closing
        
        var height: CGFloat {
            switch self {
                case .closing:
                    return -80 //feels good magic number
                default:
                    return 0.0
            }
        }
    }
    
    var currentState: AnimationState = .start
    var nextState: AnimationState {
        switch currentState {
            case .start:
                currentState = .opening
            case .opening:
                currentState = .closing
            case .closing:
                currentState = .opening
        }
        return currentState
    }
}
