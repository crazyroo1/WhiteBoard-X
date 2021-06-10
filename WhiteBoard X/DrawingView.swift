//
//  DrawingView.swift
//  WhiteBoard X
//
//  Created by Turner Eison on 6/8/21.
//

import Foundation
import SwiftUI
import PencilKit
import AlertToast

struct DrawingView: View {
    @State private var canvasView = PKCanvasView()
    
    @State private var backgroundColor = Color.white
    
    @State private var presentingToast = false
    
    @State private var showingClearWhiteboardAlert = false
    
    @State private var activityItems = [Any]()
    @State private var showingActivityController = false
    
    var body: some View {
        CanvasView(canvasView: $canvasView, backgroundColor: $backgroundColor, onSaved: saveDrawing)
            .ignoresSafeArea()
            .overlay(controlButtons, alignment: .top)
            .toast(isPresenting: $presentingToast) {
                AlertToast(displayMode: .hud, type: .complete(.green), title: "Recentered")
            }
            .alert("Clear Whiteboard?", isPresented: $showingClearWhiteboardAlert) {
                Button("Clear", role: .destructive, action: deleteDrawing)
                Button("Cancel", role: .cancel) {}
            }
            .sheet(isPresented: $showingActivityController, content: {
                ActivityViewController(activityItems: activityItems, applicationActivities: nil)
                    .background(.thinMaterial)
            })
            .preferredColorScheme(backgroundColor.isLight() ? .light : .dark)
    }
    
    var controlButtons: some View {
        VStack {
            HStack {
                FloatingView {
                    ColorPicker("Background Color", selection: $backgroundColor)
                        .labelsHidden()
                        .onChange(of: backgroundColor) { newValue in
                            saveDrawing()
                        }
                }
                
                Spacer()
                
                FloatingButton(systemImage: "camera.metering.center.weighted", action: recenter)
                
                Spacer()
                
                FloatingButton(systemImage: "trash.fill", role: .destructive) {
                    showingClearWhiteboardAlert.toggle()
                }
            }
            
            Spacer()
            
            HStack {
                Spacer()
                
                FloatingButton(systemImage: "square.and.arrow.up") {
                    if !activityItems.isEmpty {
                        showingActivityController = true
                    }
                }
                .disabled(activityItems.isEmpty)
            }
        }
        .font(.largeTitle)
        .padding()
    }
    
    func recenter() {
        canvasView.setContentOffset(CGPoint(x: canvasView.contentSize.width / 2, y: canvasView.contentSize.height / 2), animated: true)
        presentingToast = true
    }
    
    func saveDrawing() {
        guard !canvasView.drawing.strokes.isEmpty else {
            activityItems = []
            return
        }
        
        let image = canvasView.drawing.image(from: canvasView.drawing.bounds, scale: 3)
            .withBackground(color: UIColor(backgroundColor))
        
        activityItems = [
            image as Any,
            "Check out my drawing made with #Whiteboard X!"
        ]
    }
    
    func deleteDrawing() {
        canvasView.drawing = PKDrawing()
    }
}

struct DrawingView_Previews: PreviewProvider {
    static var previews: some View {
        DrawingView()
    }
}
