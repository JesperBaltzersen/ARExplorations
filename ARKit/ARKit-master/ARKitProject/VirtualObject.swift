import Foundation
import SceneKit
import ARKit

class VirtualObject: SCNNode {
	static let ROOT_NAME = "Virtual object root node"
	var fileExtension: String = ""
	var thumbImage: UIImage!
	var title: String = ""
	var modelName: String = ""
	var modelLoaded: Bool = false
	var id: Int!
    var virtualObjectScene : SCNScene!
    var textNode : SCNNode!

	var viewController: MainViewController?

	override init() {
		super.init()
		self.name = VirtualObject.ROOT_NAME
	}

	init(modelName: String, fileExtension: String, thumbImageFilename: String, title: String) {
		super.init()
		self.id = VirtualObjectsManager.shared.generateUid()
		self.name = VirtualObject.ROOT_NAME
		self.modelName = modelName
		self.fileExtension = fileExtension
		self.thumbImage = UIImage(named: thumbImageFilename)
		self.title = title
        self.virtualObjectScene = nil
        self.textNode = nil
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func loadModel() {
        virtualObjectScene = SCNScene(named: "\(modelName).\(fileExtension)", inDirectory: "Models.scnassets/\(modelName)")
        
		let wrapperNode = SCNNode()

		for child in virtualObjectScene.rootNode.childNodes {
			child.geometry?.firstMaterial?.lightingModel = .physicallyBased
			child.movabilityHint = .movable
			wrapperNode.addChildNode(child)
		}
        
//        let billboardText = self.text
        textNode = SCNNode.textNode(text: "Resound Linx Quatro")
        textNode.name = "text"
//        textNode.boundingBox.min.y = virtualObjectScene.rootNode.boundingBox.max.y
        wrapperNode.addChildNode(textNode)
        
        self.addChildNode(wrapperNode)
        
		modelLoaded = true
        
        Gn.loadSceneAsync(completion: { (result) in
            let (t,err) = result
            t
        }
         
            } catch {
                
            }
        })
        
//        loadSceneAsync( (result) in
//            do {
//                let boxScene = try result.get()
//
//            } catch {
//
//            }
//        })
	}

	func unloadModel() {
		for child in self.childNodes {
			child.removeFromParentNode()
		}

		modelLoaded = false
	}

	func translateBasedOnScreenPos(_ pos: CGPoint, instantly: Bool, infinitePlane: Bool) {
		guard let controller = viewController else {
			return
		}
		let result = controller.worldPositionFromScreenPosition(pos, objectPos: self.position, infinitePlane: infinitePlane)
		controller.moveVirtualObjectToPosition(result.position, instantly, !result.hitAPlane)
	}
}

extension VirtualObject {

	static func isNodePartOfVirtualObject(_ node: SCNNode) -> Bool {
		if node.name == VirtualObject.ROOT_NAME {
			return true
		}

		if node.parent != nil {
			return isNodePartOfVirtualObject(node.parent!)
		}

		return false
	}
    
//    func updateNodePlacements(){
//        textNode.boundingBox.min.y = virtualObjectScene.rootNode.boundingBox.max.y
//    }
}

// MARK: - Protocols for Virtual Objects

protocol ReactsToScale {
	func reactToScale()
}

extension SCNNode {

	func reactsToScale() -> ReactsToScale? {
		if let canReact = self as? ReactsToScale {
			return canReact
		}

		if parent != nil {
			return parent!.reactsToScale()
		}

		return nil
	}
    
//    func updateNodePlacements(){
//        let node = self as! VirtualObject
//
//        node.boundingBox.min.y = .virtualObjectScene.rootNode.boundingBox.max.y
//    }
}
