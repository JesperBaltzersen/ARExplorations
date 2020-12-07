//
//  VirtualObjectViewController.swift
//  ARKit-Sampler
//
//  Created by Shuichi Tsutsumi on 2017/09/20.
//  Copyright © 2017 Shuichi Tsutsumi. All rights reserved.
//

import UIKit
import ARKit

class VirtualObjectViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.scene = SCNScene()
        sceneView.debugOptions = [SCNDebugOptions.showFeaturePoints]
        
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(rotateNode(_:)))
        self.sceneView.addGestureRecognizer(rotationGesture)
        
        let panningGesture = UIPanGestureRecognizer(target: self, action: #selector(spinNode(_:)))
        self.sceneView.addGestureRecognizer(panningGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sceneView.session.run()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard let frame = sceneView.session.currentFrame else {return}
        sceneView.updateLightingEnvironment(for: frame)
    }
    
    
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        print("\(self.classForCoder)/" + #function)
        guard let planeAnchor = anchor as? ARPlaneAnchor else {fatalError()}
        planeAnchor.addPlaneNode(on: node, contents: UIColor.arBlue.withAlphaComponent(0.3))
        
        let textNode = SCNNode.textNode(text: "Resound Linx Quatro")

        virtualNode = VirtualObjectNode()
//        var testNode = VirtualObjectNode()
        DispatchQueue.main.async(execute: {
            self.virtualNode.addChildNode(textNode)
            node.addChildNode(self.virtualNode)
//            node.addChildNode(textNode)
        })
    }

    //Store The Rotation Of The CurrentNode
    var currentAngleY: Float = 0.0
    var virtualNode: VirtualObjectNode = VirtualObjectNode()
    
    @objc func rotateNode(_ gesture: UIRotationGestureRecognizer){
        print("in rotateNode")
//        var virtualNode: VirtualObjectNode = VirtualObjectNode()
        //1. Get The Current Rotation From The Gesture
        let rotation = Float(gesture.rotation)
        print("rotation: \(rotation)")

        //2. If The Gesture State Has Changed Set The Nodes EulerAngles.y
        if gesture.state == .changed{
            //isRotating = true
            
            virtualNode.eulerAngles.y = currentAngleY + rotation
            print(".changed: \(currentAngleY + rotation)")
        }

        //3. If The Gesture Has Ended Store The Last Angle
        if(gesture.state == .ended) {
            currentAngleY = virtualNode.eulerAngles.y
//            print(".ended: \(currentAngleY)")
//            isRotating = false
        }
    }
    
    @objc func spinNode(_ gesture: UIPanGestureRecognizer) {
//        let orgPos = virtualNode.simdPosition
//
//        let touchPoint = gesture.location(in: self.sceneView)
//
//        guard let hitTest = self.sceneView.hitTest(touchPoint, types: .existingPlane).first else { return }
//
//        let wt = hitTest.worldTransform
//
//        let newPos = SCNVector3(wt.columns.3.x, wt.columns.3.y, wt.columns.3.z)
//
//        virtualNode.simdPosition = float3(orgPos.x + (orgPos.x - newPos.x),orgPos.y + (orgPos.y - newPos.y), orgPos.z + (orgPos.z - newPos.z))

        guard let pan = try? { Float(gesture.translation(in: self.sceneView).x) / 100 } else { 0.0 }
        print("rotation: \(pan())")

        //2. If The Gesture State Has Changed Set The Nodes EulerAngles.y
        if gesture.state == .changed{
            //isRotating = true
            
            virtualNode.eulerAngles.y = currentAngleY + pan()
            print(".changed: \(currentAngleY + pan())")
        }

        //3. If The Gesture Has Ended Store The Last Angle Of The Cube
        if(gesture.state == .ended) {
            currentAngleY = virtualNode.eulerAngles.y
        }
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {fatalError()}
        planeAnchor.updatePlaneNode(on: node)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        print("\(self.classForCoder)/" + #function)
    }
}

