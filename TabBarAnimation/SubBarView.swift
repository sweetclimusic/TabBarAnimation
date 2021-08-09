//
//  SubBarView.swift
//  TabBarAnimation
//
//  Created by Ashlee Muscroft on 06/08/2021.
//

import SwiftUI

struct SubBarView: View {
    let subItems: [TabItem] = [
        TabItem(systemImageName: "folder", "Browse"),
        TabItem(systemImageName: "wrench.and.screwdriver", "Log Support"),
        TabItem(systemImageName: "video", "Record"),
    ]
    @State private var selected:String = "None"
    var image = Image("arrow.triangle.merge.fill")
    var body: some View {
        IconBar(items: subItems,
                tabBarButtonStyle: TabBarButtonStyle(width: 70,
                                                     height: tabBarButtonHeight,
                                                     color: .white,
                                                     padding: .horizontal),
                selected: $selected)
        
    }
}

struct SubBarView_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
