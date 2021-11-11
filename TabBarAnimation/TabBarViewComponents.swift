    //
    //  TabBarViewComponents.swift
    //  TabBarAnimation
    //
    //  Created by Ashlee Muscroft on 03/08/2021.
    //

import SwiftUI

struct TabBarButton: View {
    @Binding var selected: String
    var tabItem: TabItem
    var body: some View {
        Button(
            action: {
                withAnimation(.easeInOut(duration: coreAnimationDuration)){
                    selected = tabItem.name
                }
            },label: {
                tabItem.image
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 28, height: 28)
                    .foregroundColor(selected == tabItem.name ? .pink : .gray)
            })
    }
}

struct NewMediaButton: View {
    var buttonSize: CGFloat = 56
    @EnvironmentObject var animationProgress: AnimationProgress
    @Binding var rotation: Double
    @Binding var positionY: CGFloat
    @Binding var active: Bool
    @State private var pct: CGFloat = 0
    
        /// Holy animatable transforms Batman! what's going on here?
        /// animatableData is a property of Shape, it is used to track the changes of the type
        /// before and after SwiftUI renders the view.
        /// when explictedly animating with "withAnimation" SwiftUI know how to animate things like opacity and scale internally.
        /// It does not know how to do colors, text or your own properties.
        /// by defining animatableData you are now able to animate your views how you like.
        /// this is done by defining what values are to be tracked over time and incremented by the SwiftUI render frame by frame.
        /// You define a var animatableData: <some VectorArithmetic Type> eg. Double, Int, CGFloat
        /// If you require multiple VectorArithmetic Types animating, a AnimatablePair <first, second> is required.
        /// Here I have to track Rotation <Double>, Position<CGFloat> and percentage<CGFloat>. I have to nest AnimatablePair to represent this.
        /// Since I only needed to track the Y position of the button there is only one additional nesting. but if your requirement were to track the CGPoint, both x and y. You would then have to nest an additional AnimatablePair to represent the CGPoint such  as  AnimatablePair<CGFloat, AnimatablePair<CGFloat,
        /// AnimatablePair<CGFloat,CGFloat>>>
    typealias AnimatableTransformData = AnimatablePair<Double, AnimatablePair<CGFloat,CGFloat>>
    var animatableData: AnimatableTransformData {
        get{ AnimatableTransformData(rotation,AnimatablePair(positionY,pct)) }
        set{
                //MARK: CodeSmell
                //anything more complicated and AnimatableTransformData would need to be a Object with apporiate getter methods instead of accessing by "newValue.second.first"
                //aka. AnimatableTransformData.AnimatablePair.CGFloat == newValue.second.first
            rotation = newValue.first
            positionY  = newValue.second.first
                // track the stages of our animation
            animationProgress.animationYProsition = newValue.second.first
            animationProgress.animationPercentage = newValue.second.second
            pct  = newValue.second.second
        }
    }
    
    var body: some View {
        let drop = tabBarButtonHeight * 0.5
        Button(action: {
            withAnimation(
                // .interactiveSpring(response: 0.4, dampingFraction: 0.41, blendDuration: 0.8):
                //  .spring(response: 0.21, dampingFraction: 1, blendDuration: 0.8):
                // MARK: these magic numbers brought to you by https://cubic-bezier.com/#1,.64,0,1.45 when you need a cubic-bezier animation, use https://cubic-bezier.com
                active ?
                    .timingCurve(1, 0.64, 0, 2.75, duration: 0.8):
                        .easeOut(duration: coreAnimationDuration)
            ){
                active.toggle()
                animationProgress.toggle()
                rotation = active ? 135 : -270
                positionY = active ? (drop * 3) : -(drop)
                    //Spring didn't quite fit, so manually reset to start position
                pct = active ? 1 : 0
                updatePosition(percentage: pct, duration: coreAnimationDuration)
            }
        }, label: {
            Image(systemName: "plus")
                .rotationEffect(
                    .degrees( rotation ))
                .font(.title)
                .foregroundColor(.white)
        }).background(
            Circle()
                .frame(width: buttonSize, height: buttonSize,
                       alignment: .center)
                .foregroundColor(.pink)
        )
            .offset(y: positionY)
    }
        /// I use this to monitor the completion percentage on the  animation along its timeline of the newbutton Y transform. When it has ended I set the position to Y and allow SwiftUI to render the animation transition.
    func updatePosition(percentage pct: CGFloat, duration: Double) {
            // Sneak back to p1. This is a code smell but I couldn't get it to work without this.
        if pct == 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + duration
            ) {
                positionY = 0
            }
        }
    }
    
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
