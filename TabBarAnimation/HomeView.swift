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
    //  TODO: look into @viewbuilder if this qualifies as something that should now be viewbuilder
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
    
}
struct Home: View {
    let tabItems: [TabItem] = [
        TabItem(systemImageName: "house", "Home"),
        TabItem(systemImageName: "square.and.arrow.up", "Share"),
        TabItem(systemImageName: "arrow.triangle.merge", "Merge"),
        TabItem(systemImageName: "person", "Profile")
    ]
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
                // MARK: Note
                /// accepted type for a Tabviews are Text and Image. All other types are assigned but not reneder
                /// We can use our custom type to allow programmable switching of tabs
            GeometryReader{ reader in
                let globalCoord = reader.frame(in: .global)
                let tabBarTop = globalCoord.maxY
                ZStack {
                    HStack(spacing: 0) {
                        TabView(selection: $selected){
                            SolidTabView(color: .gray,
                                         tab: tabItems[0].name)
                            SolidTabView(color: .purple,
                                         tab: tabItems[1].name)
                            SolidTabView(color: .yellow,
                                         tab: tabItems[2].name)
                            SolidTabView(color: .blue,
                                         tab: tabItems[3].name)
                        }
                    }
                    
                    HStack {
                        NewMediaButton(rotation:$buttonRotation,
                                       positionY: $buttonPosition,
                                       active: $showNewMediaItems
                        )
                        
                            .frame(width: tabBarButtonHeight,
                                   height: tabBarButtonHeight)
                            .position(x:globalCoord.width * 0.5,
                                      y:tabBarTop * 0.9)
                    }
                }
            }
            if showNewMediaItems {
                    // offset and opacity not currently tracked as animatable
                withAnimation{
                    SubBarView()
                        .offset(y: buttonPosition < 50 ? -200 : 0)
                        .padding(.horizontal, 10)
                        .padding(.top)
                        .opacity(buttonPosition < 50 ? 1:0)
                        .transition(<#T##t: AnyTransition##AnyTransition#>)
                }
            } else {
                HStack(spacing: 0){
                    ForEach(tabItems, id: \.self) { tab in
                        TabBarButton(selected: $selected, tabItem: tab)
                            //Add a Spacer to the HStack so long as we have tab items
                        if tab != tabItems.last {
                            Spacer()
                        }
                    }
                    .padding(.horizontal, 16)
                    .frame(width: .infinity ,height: tabBarButtonHeight,
                           alignment: .bottom)//set mininum size of Icon frame
                    
                    
                }
                .frame(height: tabBarButtonHeight, alignment: .bottom)
                    // padding on devices with no safe area
                .padding(.horizontal, 0)
                .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom == 0 ? 10 : 0)
                    //7 add a background and shadow to show a distance tabBar
                    // the shadow is added to the icons as well
                    // next the HStack and apply the background and shadow to the parent HStack if you wanted flat icons
                .background(Color.white)
                .clipShape(
                    TabBasinView(gutter: tabBarButtonHeight * 0.4, apex: tabBarButtonHeight )
                )
                .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/.opacity(0.8), radius: 2,
                        x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/,
                        y: -1)
                
                
                    //                        .clipShape(
                    //                            TabBasinView(gutter: tabBarButtonHeight * 0.6, apex: tabBarButtonHeight )
                    //                        )
                    //                        .background(
                    //                            Color(.gray)
                    //                                .opacity(0.2)
                    //                        )
                
            }
            
                //        .clipShape(
                //            TabBasinView(gutter: 35, apex: 50)
                //        )
                //        //TODO: not quite right, missing button now?
                //        .frame(width: .infinity, height: tabBarButtonHeight, alignment: .bottom)
                //        .background(
                //            Color(.gray)
                //            .opacity(0.2)
                //        )
                //.ignoresSafeArea(.all, edges: .bottom)
                //
            
                //MARK: Things I want from Geometry Reader, I want to get the bottom of the Tab view or the top of the custom Tabbar and it's mid point to place the NewMedia Button relative to it
                //                GeometryReader{ reader in
                //                    let globalCoord = reader.frame(in: .global)
                //                        /// positioning the Plus button correctly requires a ZStack
                //                        /// to layer the new button on top of the tab bar
                //                    HStack {
                //                        NewMediaButton(rotation:$buttonRotation,
                //                                       positionY: $buttonPosition,
                //                                       active: $showNewMediaItems
                //                        )
                //
                //                            .frame(width: tabBarButtonHeight,
                //                                   height: tabBarButtonHeight)
                //                            .position(x:globalCoord.width * 0.5,
                //                                      y:globalCoord.height - (tabBarTop * 2))
                //
                //                    }
                //                }.frame(width: tabBarButtonHeight,
                //                        height: tabBarButtonHeight)
            
        }
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
            .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro Max"))
            .previewDisplayName("11 Pro Max")
        Home()
            .previewDevice(PreviewDevice(rawValue: "iPhone SE (2nd generation"))
            .previewDisplayName("SE 2020")
    }
}
