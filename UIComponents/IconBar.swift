//
//  IconBar.swift
//  TabBarAnimation
//
//  Created by Ashlee Muscroft on 06/08/2021.
//

import SwiftUI

enum TabIcon: String {
    case Browse = "folder"
    case Home = "house"
    case LogSupport = "wrench.and.screwdriver"
    case Merge = "arrow.triangle.merge"
    case Share = "square.and.arrow.up"
    case Video = "video"
    case Profile = "person"
    case none
}

struct TabBarButtonStyle: ViewModifier{
    var width: CGFloat
    var height: CGFloat
    var color: Color
    var padding: Edge.Set = .horizontal
    var paddingAmount: CGFloat = 0
    func body(content: Content) -> some View {
        content
            .frame(width: width, height: height)//set mininum size of Icon frame
            .background(Circle().foregroundColor(color)
                            .shadow(color: .black, radius: 1)
            )
            .padding(padding,paddingAmount)
    }
    
}

struct IconBar: View {
    var items: [TabItem]
    var tabBarButtonStyle: TabBarButtonStyle
    @Binding var selected: String
    //StateObject
    //ObservedObject
    var body: some View {
        HStack(spacing: 0){
            ForEach(items, id: \.self) { tab in
                TabBarButton(selected: $selected, tabItem: tab)
                //Add a Spacer to the HStack so long as we have tab items
                if tab != items.last {
                    Spacer(minLength: 0)
                }
            }
            .modifier(tabBarButtonStyle)
        }
    }
}

struct IconBar_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
