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
    var position: CGFloat = 0
    @Binding var animate: Bool
    @State private var pct: CGFloat = 0
    var animatableData: AnimatablePair<CGFloat,CGFloat> {
        get{
            pct = animate ? 1 : 0
            return AnimatablePair(position,pct)
        }
        set{
            position  = newValue.first
                // track the stages of our animation
            pct  = newValue.second
        }
    }
    
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

struct Basin: View {
    var positionY: CGFloat
    @State var active: Bool
    var body: some View {
        ZStack {
            
            TabBasinView(gutter: 50, valley: 35, position: positionY,animate: $active)
                .frame(
                    width: .infinity,
                    height: 150,
                    alignment: .center)
                .foregroundColor(
                    Color(.red)
                )
            
        }.ignoresSafeArea(.all)
    }
}

struct TabBasinView_Previews: PreviewProvider {
    static var previews: some View {
        Basin(positionY: 0.0, active: true )
    }
}


