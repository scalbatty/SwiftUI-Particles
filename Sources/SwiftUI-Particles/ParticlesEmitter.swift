//
//  ParticlesEmitter.swift
//  SwiftUI-Particles
//
//  Created by Arthur Guibert on 28/10/2019.
//  Copyright © 2019 Arthur Guibert. All rights reserved.
//

import SwiftUI
import UIKit


/// Class that wraps the CAEmitterCell in a class compatible with SwiftUI
public struct ParticlesEmitter: UIViewRepresentable {
    var center: CGPoint = .zero
    var emitterSize: CGSize = .init(width: 1, height: 1)
    var shape: CAEmitterLayerEmitterShape = .line
    var beginTime: CFTimeInterval = 0
    var cells: [CAEmitterCell] = []

    public func updateUIView(_ uiView: InternalParticlesView, context: UIViewRepresentableContext<ParticlesEmitter>) {
        uiView.emit(
            from: center,
            size: emitterSize,
            shape: shape,
            beginTime: beginTime,
            cells: cells
        )
    }

    public func makeUIView(context: Context) -> InternalParticlesView {
        let view = InternalParticlesView()
        view.emit(
            from: center,
            size: emitterSize,
            shape: shape,
            beginTime: beginTime,
            cells: cells
        )
        return view
    }
}

public extension ParticlesEmitter {
    func emitterSize(_ size: CGSize) -> Self {
        return ParticlesEmitter(
            center: self.center,
            emitterSize: size,
            shape: self.shape,
            beginTime: self.beginTime,
            cells: self.cells
        )
    }

    func emitterPosition(_ position: CGPoint) -> Self {
        return ParticlesEmitter(
            center: position,
            emitterSize: self.emitterSize,
            shape: shape,
            beginTime: self.beginTime,
            cells: self.cells
        )
    }

    func emitterShape(_ shape: CAEmitterLayerEmitterShape) -> Self {
        return ParticlesEmitter(
            center: self.center,
            emitterSize: self.emitterSize,
            shape: shape,
            beginTime: self.beginTime,
            cells: self.cells
        )
    }

    func beginTime(_ beginTime: CFTimeInterval) -> Self {
        return ParticlesEmitter(
            center: self.center,
            emitterSize: self.emitterSize,
            shape: self.shape,
            beginTime: beginTime,
            cells: self.cells
        )
    }
}


/// The container view class for the particles, as the project is using a CAEmitterLayer
public final class InternalParticlesView: UIView {
    private var particleEmitter: CAEmitterLayer?

    /// Function that adds the emitter cells to the layer
    /// - Parameter center: center of the emitter
    /// - Parameter size: size of the emitter
    /// - Parameter cells: all the CAEmitterCell
    func emit(from center: CGPoint, size: CGSize, shape: CAEmitterLayerEmitterShape, beginTime: CFTimeInterval, cells: [CAEmitterCell]) {
        if particleEmitter == nil {
            particleEmitter = CAEmitterLayer()
            layer.addSublayer(particleEmitter!)
        }

        particleEmitter?.emitterPosition = center
        particleEmitter?.emitterShape = shape
        particleEmitter?.emitterSize = size
        particleEmitter?.emitterCells = cells
        particleEmitter?.beginTime = beginTime
    }
}

@resultBuilder
public struct EmitterCellBuilder {
    public static func buildBlock(_ cells: [CAEmitterCell]...) -> [CAEmitterCell] {
        cells.flatMap { $0 }
    }

    public static func buildExpression(_ expression: CAEmitterCell) -> [CAEmitterCell] {
        [expression]
    }

    public static func buildExpression(_ expression: [CAEmitterCell]) -> [CAEmitterCell] {
        expression
    }

    public static func buildArray(_ components: [[CAEmitterCell]]) -> [CAEmitterCell] {
        components.flatMap { $0 }
    }
}

public extension ParticlesEmitter {
    init(@EmitterCellBuilder _ content: () -> [CAEmitterCell]) {
        self.init(cells: content())
    }

    init(@EmitterCellBuilder _ content: () -> CAEmitterCell) {
        self.init(cells: [content()])
    }
}

public class EmitterCell: CAEmitterCell {
    public override init() {
        super.init()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public func copyEmitter() -> EmitterCell {
        return super.copy() as! EmitterCell
    }
}


public extension EmitterCell {
    /// Content for the emitter cell, it is either an image, or a circle.
    /// NB: It could easily be extended for other shapes.
    enum Content {
        case image(UIImage)
        case circle(CGFloat)
    }

    func content(_ content: Content) -> Self {
        self.contents = content.image.cgImage
        return self
    }

    @inlinable func birthRate(_ birthRate: Float) -> Self {
        self.birthRate = birthRate
        return self
    }

    @inlinable func lifetime(_ lifetime: Float) -> Self {
        self.lifetime = lifetime
        return self
    }

    @inlinable func scale(_ scale: CGFloat) -> Self {
        self.scale = scale
        return self
    }

    @inlinable func scaleRange(_ scaleRange: CGFloat) -> Self {
        self.scaleRange = scaleRange
        return self
    }

    @inlinable func scaleSpeed(_ scaleSpeed: CGFloat) -> Self {
        self.scaleSpeed = scaleSpeed
        return self
    }

    @inlinable func velocity(_ velocity: CGFloat) -> Self {
        self.velocity = velocity
        return self
    }

    @inlinable func velocityRange(_ velocityRange: CGFloat) -> Self {
        self.velocityRange = velocityRange
        return self
    }

    @inlinable func emissionLongitude(_ emissionLongitude: CGFloat) -> Self {
        self.emissionLongitude = emissionLongitude
        return self
    }

    @inlinable func emissionLatitude(_ emissionLatitude: CGFloat) -> Self {
        self.emissionLatitude = emissionLatitude
        return self
    }

    @inlinable func emissionRange(_ emissionRange: CGFloat) -> Self {
        self.emissionRange = emissionRange
        return self
    }

    @inlinable func spin(_ spin: CGFloat) -> Self {
        self.spin = spin
        return self
    }

    @inlinable func spinRange(_ spinRange: CGFloat) -> Self {
        self.spinRange = spinRange
        return self
    }

    @inlinable func color(_ color: UIColor) -> Self {
        self.color = color.cgColor
        return self
    }

    @available(iOS 14, *)
    @inlinable func color(_ color: Color) -> Self {
        self.color = UIColor(color).cgColor // For some reason it's required to generate cgColor via UIColor otherwise it returns nil sometimes
        return self
    }

    @inlinable func xAcceleration(_ xAcceleration: CGFloat) -> Self {
        self.xAcceleration = xAcceleration
        return self
    }

    @inlinable func yAcceleration(_ yAcceleration: CGFloat) -> Self {
        self.yAcceleration = yAcceleration
        return self
    }

    @inlinable func zAcceleration(_ zAcceleration: CGFloat) -> Self {
        self.zAcceleration = zAcceleration
        return self
    }

    @inlinable func alphaSpeed(_ alphaSpeed: Float) -> Self {
        self.alphaSpeed = alphaSpeed
        return self
    }

    @inlinable func alphaRange(_ alphaRange: Float) -> Self {
        self.alphaRange = alphaRange
        return self
    }
}

fileprivate extension EmitterCell.Content {
    var image: UIImage {
        switch self {
        case let .image(image):
            return image
        case let .circle(radius):
            let size = CGSize(width: radius * 2, height: radius * 2)
            return UIGraphicsImageRenderer(size: size).image { context in
                context.cgContext.setFillColor(UIColor.white.cgColor)
                context.cgContext.addPath(CGPath(ellipseIn: CGRect(origin: .zero, size: size), transform: nil))
                context.cgContext.fillPath()
            }
        }
    }
}
