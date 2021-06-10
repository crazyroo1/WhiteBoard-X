//
//  ActivityViewController.swift
//  WhiteBoard X
//
//  Created by Turner Eison on 6/10/21.
//

import Foundation
import SwiftUI

struct ActivityViewController: UIViewControllerRepresentable {
    init(activityItems: [Any], applicationActivities: [UIActivity]? = nil) {
        self.activityItems = activityItems
        self.applicationActivities = applicationActivities
        print("initialized with \(activityItems)")
    }
    
    
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
        print("creating... \(activityItems)")
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityViewController>) {
        print("updating...")
    }
    
}
