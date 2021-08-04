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

    init(systemImageName image: String, _ name: String) {
        self.id = UUID()
        self.imageName = image
        self.name = name
    }
}
struct Home: View {
    let tabItems: [TabItem] = [
        TabItem(systemImageName: "house", "Home"),
        TabItem(systemImageName: "square.and.arrow.up", "Share"),
        TabItem(systemImageName: "arrow.triangle.merge", "Merge")]
    @State var selected:String = "Home"
    //When defined, hide the default tabbar
    init() {
        UITabBar.appearance().isHidden = true
    }
    var body: some View {
        VStack( spacing: 0) {
        TabView(selection: $selected){
            // accepted type for a Tabviews are Text and Image. All other types are assigned but not reneder
            // We can use our custom type to allow programmable switching of tabs
            SolidTabView(color: .red, tab: tabItems[0].name)
            SolidTabView(color: .purple, tab: tabItems[1].name)
            SolidTabView(color: .yellow, tab: tabItems[2].name)
        
        }
            HStack{
                ForEach(tabItems, id: \.self) { tab in
                    TabBarButton(selected: $selected, tabItem: tab)
                }
                .padding(.top)
                .padding(.horizontal)
            }
        }
    }
}


struct SolidTabView: View {
    let color: Color
    let tab: String
    var body: some View {
        color
            .tag(tab)
            .ignoresSafeArea(.all, edges: .top)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
            Home()
    }
}
