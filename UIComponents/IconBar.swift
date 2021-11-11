    //
    //  IconBar.swift
    //  TabBarAnimation
    //
    //  Created by Ashlee Muscroft on 06/08/2021.
    //

import SwiftUI

enum TabIcon: String,CaseIterable {
    case Browse = "folder"
    case Home = "house"
    case LogSupport = "wrench.and.screwdriver"
    case Merge = "arrow.triangle.merge"
    case Share = "square.and.arrow.up"
    case Video = "video"
    case Profile = "person"
    case Chart = "chart.bar.xaxis"
}

struct TabBarButtonStyle: ViewModifier{
    var width: CGFloat
    var height: CGFloat
    var color: Color
    var padding: Edge.Set = .horizontal
    var paddingAmount: CGFloat = 0
    func body(content: Content) -> some View {
        content
            .frame(
                width: width,
                height: height) //set mininum size of Icon frame
            .background(
                Circle()
                    .foregroundColor(color)
                    .shadow(color: .black.opacity(0.8), radius: 1)
            )
            .padding(padding,paddingAmount)
    }
}

struct IconBar: View {
    var items: [TabItem]
    var tabBarButtonStyle: TabBarButtonStyle
    @Binding var selected: String
    var namespace: Namespace.ID
    var body: some View {
        HStack(spacing: 0) {
            ForEach(items, id: \.self) { tab in
                let firstOrLast = [items.first, items.last].contains(tab)
                let index = items.firstIndex(of: tab)!
                TabBarButton(selected: $selected, tabItem: tab)
                    .modifier(tabBarButtonStyle)
                    //matchedGeometryEffect matches the position of a object with the same ID in the animation namespace
                    .matchedGeometryEffect(
                        id: "item\(String(describing: index))",
                        in: namespace
                    )
                    //adjust padding and offset first and last items
                    .padding(.horizontal,
                             firstOrLast ? .zero : iconBarPadding)
                    .offset(y:firstOrLast ? iconBarPadding : .zero )
            }
        }
    }
}

struct IconBar_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
