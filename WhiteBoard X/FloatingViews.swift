//
//  FloatingViews.swift
//  WhiteBoard X
//
//  Created by Turner Eison on 6/10/21.
//

import Foundation
import SwiftUI

struct FloatingView<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(Circle())
    }
}

struct FloatingButton: View {
    var systemImage: String
    var role: ButtonRole?
    var action: () -> Void
    
    var body: some View {
        Button(role: role) {
            action()
        } label: {
            Image(systemName: systemImage)
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(Circle())
        }
    }
}
