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
    
    func toggle() {
        animationIsActive.toggle()
    }
}
