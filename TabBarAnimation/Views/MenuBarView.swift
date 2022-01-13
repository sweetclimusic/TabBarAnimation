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
    @EnvironmentObject var animationProgress: AnimationProgress
    @Binding var selected: String
    @State var value: CGFloat = 0
    var namespace: Namespace.ID
    
    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                ForEach(tabItems.indices, id: \.self) { index in
                    TabBarButton(selected: $selected, tabItem: tabItems[index])
                        //Add a Spacer to the HStack so long as we have tab items
                    if tabItems[index] != tabItems.last {
                        Spacer()
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 26)
                .frame(height: tabBarButtonHeight * 2,
                       alignment: .bottom)
            }
            .foregroundColor(Color.white)
            .modifier(AnimatingPathValley(
                height: value,
                completion: {
                    DispatchQueue.main.async {
                        value = 0.0
                    }
                }
            ))
            .animation(
                .spring(
                    response: 0.5,
                    dampingFraction: 0.35,
                    blendDuration: 0.25).delay(0.25)
            )
            .onAppear{
                value = animationProgress.animationStateHeight()
            }
            .ignoresSafeArea()
            //MARK: Phathom elements for GeometryMatching
            HStack(spacing: 0){
                ForEach(tabItems.indices, id: \.self) { index in
                    Circle()
                        .frame(width: 28, height: 28)
                        .opacity(0)
                        .matchedGeometryEffect(
                            id: "item\(String(describing: index))",
                            in: namespace)
                    if tabItems[index] != tabItems.last {
                        Spacer()
                    }
                }
            }
            .padding(.horizontal, 28)
                .padding(.bottom, 26)
                .frame(height: tabBarButtonHeight * 2,
                       alignment: .bottom)
        }
    }
}

struct MenuBarView_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
