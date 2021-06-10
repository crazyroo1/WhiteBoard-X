//
//  CanvasView.swift
//  WhiteBoard X
//
//  Created by Turner Eison on 6/8/21.
//

import Foundation
import PencilKit
import SwiftUI

struct CanvasView {
    @Binding var canvasView: PKCanvasView
    @State var toolPicker = PKToolPicker()
    @Binding var backgroundColor: Color
    let onSaved: () -> Void
}

private extension CanvasView {
    func showToolPicker() {
        toolPicker.setVisible(true, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
        toolPicker.colorUserInterfaceStyle = .light
        
        canvasView.becomeFirstResponder()
    }
}

extension CanvasView: UIViewRepresentable {
    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.tool = PKInkingTool(.pen, color: .gray, width: 10)
#if targetEnvironment(simulator)
        canvasView.drawingPolicy = .anyInput
#endif
        canvasView.delegate = context.coordinator
        
        canvasView.backgroundColor = UIColor(backgroundColor)
        canvasView.contentSize = .veryLarge
        canvasView.setContentOffset(CGSize.veryLarge.center, animated: false)
        canvasView.maximumZoomScale = 5
        
        canvasView.showsVerticalScrollIndicator = false
        canvasView.showsHorizontalScrollIndicator = false
        
        showToolPicker()
        return canvasView
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        canvasView.backgroundColor = UIColor(
            patternImage: UIImage(named: "grid")!
                .withTintColor(.gray)
                .withAlpha(0.3)
                .withBackground(color: UIColor(backgroundColor))!
        )
        toolPicker.colorUserInterfaceStyle = backgroundColor.isLight() ? .light : .dark
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(canvasView: $canvasView, onSaved: onSaved)
    }
}

class Coordinator: NSObject {
    var canvasView: Binding<PKCanvasView>
    let onSaved: () -> Void
    
    init(canvasView: Binding<PKCanvasView>, onSaved: @escaping () -> Void) {
        self.canvasView = canvasView
        self.onSaved = onSaved
    }
}

extension Coordinator: PKCanvasViewDelegate {
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        if !canvasView.drawing.bounds.isEmpty {
            onSaved()
        }
    }
}
