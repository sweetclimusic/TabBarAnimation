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
    @State var resetAnimation: Bool
    var namespace: Namespace.ID
    
    var body: some View {
        HStack(spacing: 0){
            ForEach(tabItems.indices, id: \.self) { index in
                TabBarButton(selected: $selected, tabItem: tabItems[index])
                    //Add a Spacer to the HStack so long as we have tab items
                    .matchedGeometryEffect(
                        id: "item\(String(describing: index))",
                        in: namespace)
                    .transition(.opacity)
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
        .modifier(AnimatingPathValley(height: value, resetAnimation ))
        .onAppear{
            withAnimation(
                .interactiveSpring(
                    response: 0.45,
                    dampingFraction: 0.35,
                    blendDuration: coreAnimationDuration)) {
                        self.value = animationProgress.animationIsActive ? 0 : -100
                        self.resetAnimation =
                        abs(self.value)
                            .truncatingRemainder(dividingBy: 100) == 0
                        ? true : false
                    }
        }
        .ignoresSafeArea()
        
    }
}

struct MenuBarView_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
