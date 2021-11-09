//
//  TabBasinView.swift
//  TabBarAnimation
//
//  Created by ashlee.muscroft on 15/10/2021.
//

import SwiftUI

struct TabBasinView: Shape {
    var gutter: CGFloat
    var valley: CGFloat
    var position: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let curveStartX = CGPoint(x: (rect.midX - gutter), y: 0)
        let dipEnd = CGPoint(x: rect.midX + gutter, y: 0)
        let radius = (gutter * 0.5)
        let startX = rect.midX - radius
        let endX = rect.midX + radius
        let dipStart = CGPoint(x: rect.midX, y: valley + position)
        
        //create a dip with a movable apex
        var path = Path()
        // draw a basic rect the size of the frame
        path.addRect(rect)
        // move to center of rect and form a dip by settign the control in the +Y axis, We will animate this apex for the slingshot withAnimatable and using a spring curve.
        path.move(to: curveStartX )
        //didn't like smoothness on QuadCurve,
        //path.addQuadCurve(to: dipEnd, control: control)
        //add two bezierPath
    
        path.addCurve(to: dipStart,
                      control1: CGPoint(x: startX, y: 0),
                      control2: CGPoint(x: startX, y: valley + position))
        path.addCurve(to: dipEnd,
                      control1: CGPoint(x: endX, y: valley + position),
                      control2: CGPoint(x: endX, y: 0))
        return path
    }
    
}


//Shape Animatable Modifier
struct AnimatingPathValley: AnimatableModifier {
    var height: CGFloat = 0
    @State var reset: Bool
    var animatableData: CGFloat {
        get { height }
        set {
            if reset { height = CGFloat.zero }
            else {
                height = newValue
            }
        }
    }
    
    func body(content: Content) -> some View {
        content
            .background(
                TabBasinView(
                    gutter: tabBarButtonHeight * 1.4,
                    valley: tabBarButtonHeight * 0.8,
                    position: height))
            .foregroundColor(Color.white)
    }
}

struct TabBasinView_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}


