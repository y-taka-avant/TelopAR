//
//  ContentView.swift
//  TelopAR
//
//  Created by yuya.takahashi on 2021/03/01.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    var body: some View {
        
        let container = ARViewContainer()
        
        return ZStack() {
            container.edgesIgnoringSafeArea(.all)
            
            VStack() {
                Spacer()
                
                HStack() {
                    Spacer()
                    
                    Button(action: {
                        container.addTelop()
                    }, label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.orange)
                            .padding(20)
                    })
                }
            }
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    let arView = ARView(frame: .zero)
    
    func makeUIView(context: Context) -> ARView {
        
        arView.environment.sceneUnderstanding.options = .occlusion
        arView.debugOptions = .showSceneUnderstanding
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    func addTelop() {
        guard let wt = arView.raycast(from: arView.center,
                                      allowing: .estimatedPlane,
                                      alignment: .any).first?.worldTransform else {
            return
        }
        
        let telop = try! Experience.loadTelop()
        telop.children[0].anchor?.anchoring = AnchoringComponent(.plane(.any, classification: .any, minimumBounds: [0, 0]))
        telop.setTransformMatrix(wt, relativeTo: nil)
        arView.scene.anchors.append(telop)
    }
    
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
