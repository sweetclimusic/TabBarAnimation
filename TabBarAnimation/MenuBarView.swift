    //
    //  MenuBarView.swift
    //  TabBarAnimation
    //
    //  Created by ashlee.muscroft on 05/11/2021.
    //

import SwiftUI

struct MenuBarView: View {
    let tabItems: [TabItem] = [
        TabItem(tabIcon: .Home, "Home"),
        TabItem(tabIcon: .Share, "Share"),
        TabItem(tabIcon: .Merge, "Merge"),
        TabItem(tabIcon: .Profile, "Profile")
    ]
    @Binding var animatePath: Bool
    @Binding var buttonPosition: CGFloat
    @Binding var selected: String
    @State var endAnimation: Bool
    var namespace: Namespace.ID
    
    var body: some View {
        HStack(spacing: 0){
            ForEach(tabItems.indices, id: \.self) { index in
                TabBarButton(selected: $selected, tabItem: tabItems[index])
                    //Add a Spacer to the HStack so long as we have tab items
                    .matchedGeometryEffect(
                        id: "item\(String(describing: index))",
                        in: namespace)
                if tabItems[index] != tabItems.last {
                    Spacer()
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 26)
            .frame(height: tabBarButtonHeight * 2,
                   alignment: .bottom)//set mininum size of Icon frame
                                      //.background(Color.white)
            
            
        }
        .background(
            TabBasinView(gutter: tabBarButtonHeight * 1.4,
                         valley:  tabBarButtonHeight * 0.8,
                         position: animatePath ? -100 : 0,
                         buttonPosition: $buttonPosition,
                         animate: $endAnimation)
                .foregroundColor(Color.white)
        )
        .ignoresSafeArea()
    }
}

struct MenuBarView_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
