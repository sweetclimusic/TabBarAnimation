//
//  CustomTabBarView.swift
//  TabBarAnimation
//
//  Created by Ashlee Muscroft on 03/08/2021.
//

import SwiftUI

struct TabBarButton: View {
    @Binding var selected: String
    var tabItem: TabItem
    var body: some View {
        Button(action: {
            withAnimation(.spring()){
                selected = tabItem.name
            }
        },
        label: {
            tabItem.image
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 26, height: 26)
                    .foregroundColor(selected == tabItem.name ? .pink : .gray)
            Text(tabItem.name)
        })
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
