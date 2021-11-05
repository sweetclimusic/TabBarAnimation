//
//  SubBarView.swift
//  TabBarAnimation
//
//  Created by Ashlee Muscroft on 06/08/2021.
//

import SwiftUI

struct SubBarView: View {
    let subItems: [TabItem] = [
        TabItem(tabIcon: .Browse, "Browse"),
        TabItem(tabIcon: .LogSupport, "Log Support"),
        TabItem(tabIcon: .Video, "Record"),
        TabItem(tabIcon: .Chart, "Stats")
    ]
    @State private var selected:String = "None"
    var namespace: Namespace.ID
    var image = Image("arrow.triangle.merge.fill")
    var body: some View {
        IconBar(items: subItems,
                tabBarButtonStyle: TabBarButtonStyle(width: 70,
                                                     height: tabBarButtonHeight,
                                                     color: .white),
                selected: $selected,
                namespace: namespace
        )
        
    }
}

struct SubBarView_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
