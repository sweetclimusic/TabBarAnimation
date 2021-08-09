//
//  HomeView.swift
//  TabBarAnimation
//
//  Created by Ashlee Muscroft on 03/08/2021.
//

import SwiftUI
/// We must set our TabItem to Hashable to use in the ForEach/.map/.filter etc..
/// The image type does not conform to Hasable
/// to allow the image type to conform to Hasable
/// 1) we can either ignore image and define the func hash
/// 2) create a computed property of the image, thus we add the additional property imageName.
struct TabItem: Hashable {
    let id: UUID
    var image: Image{
        Image(systemName: imageName)
    }
    let name: String
    let imageName: String
    let tabIcon: TabIcon
    
    init(systemImageName image: String,systemImageName icon: TabIcon = TabIcon.none, _ name: String) {
        self.id = UUID()
        self.imageName = image
        self.name = name
        self.tabIcon = icon
    }
    
    func fill() -> String {
        "\(tabIcon.rawValue).fill"
    }
    func imageWithFallBack(primary: TabIcon, fallback: TabIcon) -> Image {
        var image = Image(systemName: primary.rawValue)
        if image != nil {
            image = Image(systemName: fallback.rawValue)
        }
        return  image
    }
}
struct Home: View {
    let tabItems: [TabItem] = [
        TabItem(systemImageName: "house", "Home"),
        TabItem(systemImageName: "square.and.arrow.up", "Share"),
        TabItem(systemImageName: "arrow.triangle.merge", "Merge")]
    @State private var selected:String = "Home"
    @State var showNewMediaItems: Bool = false
    @State var buttonRotation: Double = 0
    @State var buttonPosition: CGFloat = 0
    //Defined to hide the default tabbar yet allows programmable switching between tabitems
    init() {
        UITabBar.appearance().isHidden = true
    }
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $selected){
                // accepted type for a Tabviews are Text and Image. All other types are assigned but not reneder
                // We can use our custom type to allow programmable switching of tabs
                SolidTabView(color: .white, tab: tabItems[0].name)
                SolidTabView(color: .purple, tab: tabItems[1].name)
                SolidTabView(color: .yellow, tab: tabItems[2].name)
                
            }.overlay(
            //MARK: Things I want from Geometry Reader I want to get the bottom of the Tab view or the top of the custom Tabbar and it's mid point to place the NewMedia Button relative to it
            GeometryReader{ reader in
                let globalCoord = reader.frame(in: .global)
                /// positioning the Plus button correctly requires a ZStack
                /// to layer the new button on top of the tab bar
                /// 
                ZStack (alignment:.bottom) {
                NewMediaButton(rotation:$buttonRotation,
                               positionY: $buttonPosition,
                               active: $showNewMediaItems
                )
                
                .frame(width: tabBarButtonHeight,
                        height: tabBarButtonHeight)
                .position(x:globalCoord.width * 0.5,
                    y:globalCoord.maxY * 0.75)
                    
                }
            }.frame(width: tabBarButtonHeight,
                    height: tabBarButtonHeight,
                    alignment: .bottom)
          )
            if showNewMediaItems {
                HStack(spacing: 0){
                    ForEach(tabItems, id: \.self) { tab in
                        TabBarButton(selected: $selected, tabItem: tab)
                        //Add a Spacer to the HStack so long as we have tab items
                        if tab != tabItems.last {
                            Spacer(minLength: 0)
                        }
                    }
                    .frame(width: 70, height: tabBarButtonHeight)//set mininum size of Icon frams
                    
                }.padding(.horizontal, 25)
                .padding(.top)
                //7 add a background and shadow to show a distance tabBar
                // the shadow is added to the icons as well
                // next the HStack and apply the background and shadow to the parent HStack if you wanted flat icons
                .background(Color.white)
                .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/.opacity(0.1), radius: 2,
                        x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/,
                        y: -1)
            } else {
                SubBarView()
                    .offset(y:-180)
                .padding(.horizontal, 10)
                .padding(.top)
            }
            
        }.ignoresSafeArea(.all, edges: .bottom)
    }
}


struct SolidTabView: View {
    let color: Color
    let tab: String
    var body: some View {
        color
            .tag(tab)
            .ignoresSafeArea(.all, edges: .vertical)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
