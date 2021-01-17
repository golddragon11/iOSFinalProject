import SwiftUI

struct EmitterLayerView: UIViewRepresentable {
    typealias UIViewType = UIView
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let snowEmitterCell = CAEmitterCell()
        snowEmitterCell.contents = UIImage(systemName: "snow")?.cgImage
        snowEmitterCell.birthRate = 1
        snowEmitterCell.lifetime = 2
        snowEmitterCell.velocity = 100
        snowEmitterCell.lifetime = 20
        snowEmitterCell.scale = 0.5
        snowEmitterCell.yAcceleration = 30
        
        let snowEmitterLayer = CAEmitterLayer()
        snowEmitterLayer.emitterCells = [snowEmitterCell]
        view.layer.addSublayer(snowEmitterLayer)
        
        return view
    }
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}
