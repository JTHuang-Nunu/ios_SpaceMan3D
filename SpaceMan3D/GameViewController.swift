//
//  GameViewController.swift
//  SpaceMan3D
//
//  Created by Mac15 on 2023/4/20.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {
    var sceneView: SCNView!
    var mainScene: SCNScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainScene = createMainScene()
        sceneView = self.view as? SCNView
        sceneView.scene = mainScene
        sceneView.backgroundColor = UIColor.black
        sceneView.showsStatistics = true
        sceneView.allowsCameraControl = true
    }
    func createMainScene()-> SCNScene {
        let mainScene = SCNScene(named: "art.scnassets/hero.dae")
        mainScene!.rootNode.addChildNode(createFloorNode())
        mainScene!.rootNode.addChildNode(createEnemy())
        mainScene?.rootNode.addChildNode(Collectable.pyramidNode())
        mainScene?.rootNode.addChildNode(Collectable.sphereNode())
        mainScene?.rootNode.addChildNode(Collectable.boxNode())
        mainScene?.rootNode.addChildNode(Collectable.tubeNode())
        mainScene?.rootNode.addChildNode(Collectable.cylinderNode())
        mainScene?.rootNode.addChildNode(Collectable.torusNode())
        mainScene?.rootNode.addChildNode(Collectable.capsuleNode())
        
        return mainScene!
    }
    
    func createFloorNode()-> SCNNode {
        let floorNode = SCNNode()
        floorNode.geometry = SCNFloor()
        floorNode.geometry?.firstMaterial?.diffuse.contents = "Floor"
        return floorNode
    }
    
    func createEnemy()-> SCNNode {
        let enemyScene = SCNScene(named: "art.scnassets/enemy.dae")
        let enemyNode = enemyScene!.rootNode.childNode(withName: "enemy", recursively: true)
        enemyNode!.name = "enemy"
        enemyNode!.position = SCNVector3(x: 40, y:10, z: 30)
        
        let action = SCNAction.repeatForever(SCNAction.sequence([SCNAction.rotateBy(x: 0, y: 10, z: 0, duration: 1),SCNAction.rotateBy(x: 0, y: -10, z: 0, duration: 1)]))
        enemyNode?.runAction(action)
        return enemyNode!
    }
}
