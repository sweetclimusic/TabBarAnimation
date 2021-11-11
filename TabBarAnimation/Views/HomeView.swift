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
    @State private var readerFrame = CGRect()
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
                    // subMenus Contents
                    VStack(spacing:0) {
                        Spacer()
                        if showNewMediaItems {
                                // offset and opacity not currently tracked as animatable
                            withAnimation{
                                SubBarView(namespace: TabMenuID)
                                    .offset(y: animationProgress.animationYProsition < 50 ? -100 : 0)
                                    .padding(.horizontal, 0)
                                    .padding(.top)
                                    .opacity(animationProgress.animationYProsition < 50 ? 1:0)
                            }
                        } else {
                            MenuBarView(
                                selected: $selected,
                                namespace: TabMenuID
                            ).environmentObject(animationProgress)
                        }
                    }
                }.onAppear {
                    //capture GeoProxiy frame size for the rest of the view
                    self.readerFrame = reader.frame(in: .global)
                }
            }
            ZStack(alignment: Alignment(horizontal: .center,
                                        vertical: .bottom),
                   content:  {
                NewMediaButton(
                    rotation: $buttonRotation,
                    positionY: $buttonPosition,
                    active: $showNewMediaItems //not updated here?
                ).environmentObject(animationProgress)
                    .frame(width: tabBarButtonHeight,
                           height: tabBarButtonHeight)
                    .position(x:readerFrame.width * 0.5,
                              y:
                                readerFrame.maxY * 0.84 )
                    .edgesIgnoringSafeArea(.all)
            }).onAppear{
                animationProgress.nextState(.start)
            }
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
