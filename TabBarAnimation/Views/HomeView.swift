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
    
    init(tabIcon icon: TabIcon = .Home, _ name: String) {
        self.id = UUID()
        self.imageName = icon.rawValue
        self.name = name
        self.tabIcon = icon
    }
    
    func fill() -> String {
        "\(tabIcon.rawValue).fill"
    }
    
}
struct Home: View {
    //globale namespace for matched geometry animations
    @Namespace private var TabMenuID
    
    let tabItems: [TabItem] = [
        TabItem(tabIcon: TabIcon.Home, "Home"),
        TabItem(tabIcon: TabIcon.Share, "Share"),
        TabItem(tabIcon: TabIcon.Merge, "Merge"),
        TabItem(tabIcon: TabIcon.Profile, "Profile")
    ]
    let tabViewBGColor: [String:Color] = [
        "Home": Color.gray.opacity(0.33),
        "Share": Color.purple,
        "Merge": Color.yellow,
        "Profile": Color.blue
    ]
    
    
    @State var showNewMediaItems: Bool = false
    @State var animatePath: Bool = false
    @State var buttonRotation: Double = 0
    @State var buttonPosition: CGFloat = 0
    @StateObject var animationProgress = AnimationProgress()
    @State private var selected:String = "Home"
    @State private var tabBarTop: CGFloat = 0
    let softGray: Color = Color.gray.opacity(0.33)
        //Defined to hide the default tabbar yet allows programmable switching between tabitems
    init() {
        UITabBar.appearance().isHidden = true
    }
    var body: some View {
        ZStack {
            Spacer()
                // MARK: Note
                /// accepted type for a Tabviews are Text and Image. All other types are assigned but not reneder
                /// We can use our custom type to allow programmable switching of tabs
            GeometryReader{ reader in
                let globalCoord = reader.frame(in: .global)
                self.tabBarTop = globalCoord.maxY
                
                ZStack {
                    HStack(spacing: 0) {
                        TabView(selection: $selected){
                            //TODO: add a georeader around each icon to know it's center
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
                    // subMenus Contents
                    VStack(spacing:0) {
                        Spacer()
                        if showNewMediaItems {
                                // offset and opacity not currently tracked as animatable
                            withAnimation{
                                    //TODO: add a georeader around each icon to know it's center
                                SubBarView(namespace: TabMenuID)
                                //TODO: device has a safearea inset or not, adjust offset
                                    .offset(y: buttonPosition < 50 ? -100 : 0)
                                    .padding(.horizontal, 0)
                                    .padding(.top)
                                    .opacity(buttonPosition < 50 ? 1:0)
                                    //.transition(<#T##t: AnyTransition##AnyTransition#>)
                            }
                        } else {
                            MenuBarView(
                                selected: $selected,
                                endAnimation: buttonPosition > 50 ? true : false,
                                namespace: TabMenuID
                            ).environmentObject(animationProgress)
                        }
                    }
                    
                }
            }
            ZStack(alignment:
                    Alignment(horizontal: .center,
                              vertical: .bottom)
                   {
                NewMediaButton(
                    animationProgress: animationProgress,
                    rotation: $buttonRotation,
                    positionY: $buttonPosition,
                    active: $showNewMediaItems
                )
                
                    .frame(width: tabBarButtonHeight,
                           height: tabBarButtonHeight)
                    .position(x:globalCoord.width * 0.5,
                              y:
                                tabBarTop * 0.84 )
                    .edgesIgnoringSafeArea(.all)
            }
            
                //7 add a background and shadow to show a distance tabBar
                // the shadow is added to the icons as well
                // next the HStack and apply the background and shadow to the parent HStack if you wanted flat icons
                //TODO lift to a AnimatableModifier?
            
                //                .background(
                //                    TabBasinView(gutter: tabBarButtonHeight * 1.4,
                //                                 valley:  tabBarButtonHeight * 0.8,
                //                                 position: animatePath ? -100 : 0,
                //                                 animate: $showNewMediaItems)
                //                )
                //overlay hiding buttons, but only way to see the APEX curve flip.
                //                .overlay(
                //                    TabBasinView(gutter: tabBarButtonHeight * 0.8,
                //                                 valley:  tabBarButtonHeight,
                //                                 positionY: $buttonPosition )
                //                        .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/.opacity(0.2), radius: 1,
                //                                x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/,
                //                                y: -1.5)
                //                        .foregroundColor(Color.white)
                //
                //                )
            
                //.ignoresSafeArea(.all, edges: .bottom)
            
        }
            //frame height doesn't stay consistant after the NewButton moves in the Y direction, haveing to set background color, but as their is a animation
        .frame(height: UIApplication.shared.windows.first?.frame.height)
        .background(
            tabViewBGColor[selected]?
                .animation(.none)
        )
        .ignoresSafeArea()
        
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
