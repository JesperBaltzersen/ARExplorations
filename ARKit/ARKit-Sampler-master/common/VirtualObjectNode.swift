//
//  VirtualObjectNode.swift
//  ARKit-Sampler
//
//  Created by Shuichi Tsutsumi on 2017/09/20.
//  Copyright © 2017 Shuichi Tsutsumi. All rights reserved.
//

import SceneKit

class VirtualObjectNode: SCNNode {

    enum VirtualObjectType {
        case hiusdz
        case hiscn
        case duck
        case wheelbarrow
        case teapot
    }
    
    init(type: VirtualObjectType = .hiscn) {
        super.init()
        
        var scale = 1.0
        switch type {
        case .duck:
            loadScn(name: "duck", inDirectory: "models.scnassets/duck")
        case .hiscn:
            loadScn(name: "hi2", inDirectory: "models.scnassets/hi")
            scale = 0.05
        case .hiusdz:
            loadUsdz(name: "hi")
        case .wheelbarrow:
            loadUsdz(name: "wheelbarrow")
            scale = 0.005
        case .teapot:
            loadUsdz(name: "teapot")
            scale = 0.005
        }
        self.scale = SCNVector3(scale, scale, scale)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func react() {
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.3
        SCNTransaction.completionBlock = {
            SCNTransaction.animationDuration = 0.15
            self.opacity = 1.0
        }
        self.opacity = 0.5
        SCNTransaction.commit()
    }
}
