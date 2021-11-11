//
//  AnimationProgress.swift
//  TabBarAnimation
//
//  Created by ashlee.muscroft on 09/11/2021.
//

import SwiftUI

class AnimationProgress: ObservableObject {
    @Published var animationYProsition: CGFloat = 0.0
    @Published var animationPercentage: CGFloat = 0.0
    @Published var animationIsActive: Bool = false
    @Published var animationState: AnimationStateManager = AnimationStateManager()
    
    func toggle() {
        animationIsActive.toggle()
        toggleState()
    }
    
    func animationStateHeight() -> CGFloat{
        animationState.currentState.height
    }
    
    func nextState(_ to: AnimationStateManager.AnimationState? = nil) {
        if let to = to {
            animationState.currentState = to
        } else {
        _ = animationState.nextState
        }
    }
    
    private func toggleState() {
        switch animationState.currentState {
            case .opening:
                animationState.currentState = .closing
            case .closing,.start:
                animationState.currentState = .opening
        }
    }
}
