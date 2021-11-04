//
//  TabBasinView.swift
//  TabBarAnimation
//
//  Created by ashlee.muscroft on 15/10/2021.
//

import SwiftUI

struct TabBasinView: Shape {
    var gutter: CGFloat
    @State var apex: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let curveStartX = CGPoint(x: (rect.midX - apex), y: 0)
        let dipEnd = CGPoint(x: rect.midX + apex, y: 0)
        let radius = (apex * 0.5)
        let startX = rect.midX - radius
        let endX = rect.midX + radius
        let dipStart = CGPoint(x: rect.midX, y: gutter)
        
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
                      control2: CGPoint(x: startX, y: gutter))
        path.addCurve(to: dipEnd,
                      control1: CGPoint(x: endX, y: gutter),
                      control2: CGPoint(x: endX, y: 0))
        return path
    }
    
}

struct TabBasinView_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

