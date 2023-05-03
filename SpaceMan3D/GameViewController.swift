//
//  GameViewController.swift
//  SpaceMan3D
//
//  Created by Mac15 on 2023/4/20.
//

import UIKit
import QuartzCore
import SceneKit
import CoreMotion

class GameViewController: UIViewController,SCNSceneRendererDelegate, SCNPhysicsContactDelegate {
    var sceneView: SCNView!
    var mainScene: SCNScene!
    var cameraNode: SCNNode!
    var touchCount: Int?
    var motionManager: CMMotionManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainScene = createMainScene()
        sceneView = self.view as? SCNView
        sceneView.scene = mainScene
        sceneView.backgroundColor = UIColor.black
        sceneView.showsStatistics = true
        sceneView.allowsCameraControl = true
        
        createMainCamera()
        sceneView.delegate = self
        
        setupHeroBody()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let taps = event?.allTouches
        touchCount = taps?.count
        print(touchCount!)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchCount = 0
        print(touchCount!)
    }
    func renderer(_ renderer: SCNSceneRenderer, didSimulatePhysicsAtTime time: TimeInterval) {
        let moveDistane = Float(10.0)
        let moveSpeed = TimeInterval(1.0)
        let heroNode = mainScene.rootNode.childNode(withName: "hero", recursively: true)
        let currentX = heroNode?.position.x
        let currentY = heroNode?.position.y
        let currentZ = heroNode?.position.z
        if touchCount == 1 {
            let action = SCNAction.move(to: SCNVector3(currentX!, currentY!, currentZ! - moveDistane), duration: moveSpeed)
            heroNode?.runAction(action)
        }
        else if touchCount == 2 {
            let action = SCNAction.move(to: SCNVector3(currentX!, currentY!, currentZ! + moveDistane), duration: moveSpeed)
            heroNode?.runAction(action)
        }
        else if touchCount == 4 {
            let action = SCNAction.move(to: SCNVector3(0, 0, 0), duration: moveSpeed)
            heroNode?.runAction(action)
        }
    }
    
    func setupAccelerometer() {
        motionManager = CMMotionManager()
        if motionManager.isAccelerometerActive {
            motionManager.accelerometerUpdateInterval = 1/60.0
            motionManager.startAccelerometerUpdates(to: OperationQueue.main) {
                (data, error) in
                let heroNode = self.mainScene.rootNode.childNode(withName: "hero", recursively: true)?.presentation
                let currentX = heroNode?.position.x
                let currentY = heroNode?.position.y
                let currentZ = heroNode?.position.z
                let threshold = 0.20
                
                if (data?.acceleration.y)! < -threshold {
                    let destinationX = (Float((data?.acceleration.y)!) * 10.0 + Float(currentX!))
                    let destinationY = Float(currentY!)
                    let destinationZ = Float(currentZ!)
                    let action = SCNAction.move(to: SCNVector3(destinationX
                                                              ,destinationY,destinationZ), duration: 1)
                    heroNode?.runAction(action)
                }
                else if (data?.acceleration.y)! > threshold {
                    let destinationX = (Float((data?.acceleration.y)!) * 10.0 + Float(currentX!))
                    let destinationY = Float(currentY!)
                    let destinationZ = Float(currentZ!)
                    let action = SCNAction.move(to: SCNVector3(destinationX
                                                              ,destinationY,destinationZ), duration: 1)
                    heroNode?.runAction(action)
                }
            }
        }
    }
    
    func setupHeroBody() {
        let heroNode = mainScene?.rootNode
            .childNode(withName: "hero", recursively: true)
        heroNode?.position = SCNVector3(x: 0, y: 10, z: 0)
        heroNode?.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        heroNode?.physicsBody?.isAffectedByGravity = false
        heroNode?.physicsBody?.categoryBitMask  = CollisionCategoryHero
        heroNode?.physicsBody?.collisionBitMask = CollisionCategoryCollectibleLowValue | CollisionCategoryCollectibleMidValue | CollisionCategoryCollectibleHighValue | CollisionCategoryEnemy
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
        
        setupLighting(mainScene!)
        mainScene?.physicsWorld.contactDelegate = self
        return mainScene!
    }
    func createMainCamera() {
        cameraNode = SCNNode()
        cameraNode.name = "nameCamera"
        cameraNode.camera = SCNCamera()
        cameraNode.camera?.zFar = 1000
        cameraNode.position = SCNVector3(x: 0, y: 15, z: 50)
        mainScene.rootNode.childNode(withName: "hero", recursively: true)?.addChildNode(cameraNode)
    }
    
    func setupLighting(_ scene:SCNScene){
        let ambientLight = SCNNode()
        ambientLight.light = SCNLight()
        ambientLight.light!.type = SCNLight.LightType.ambient
        ambientLight.light!.color = UIColor.gray
        scene.rootNode.addChildNode(ambientLight)
        
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = SCNLight.LightType.spot
        lightNode.light!.castsShadow = true
        lightNode.position = SCNVector3Make(30, 30, 15)
        lightNode.light!.spotInnerAngle = 0
        lightNode.light!.spotOuterAngle = 60
        scene.rootNode.addChildNode(lightNode)
        
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
    
    func physicsWorld(_ world: SCNPhysicsWorld, didEnd contact: SCNPhysicsContact) {
        switch contact.nodeA.physicsBody?.categoryBitMask {
        case CollisionCategoryCollectibleLowValue:
            print("Hit a low value collectable")
            contact.nodeA.removeFromParentNode()
        
        case CollisionCategoryCollectibleMidValue:
            print("Hit a mid value collectable")
            contact.nodeA.removeFromParentNode()
            
        case CollisionCategoryCollectibleMidValue:
            print("Hit a high value collectable")
            contact.nodeA.removeFromParentNode()
            
        case CollisionCategoryEnemy:
            print("You lose")
            let rotate = SCNAction.rotateBy(x: 0, y: 5, z: 0, duration: 5)
            let moveon = SCNAction.moveBy(x: 0, y: 10, z: 0, duration: 5)
            let fadeout = SCNAction.fadeOut(duration: 5)
            contact.nodeB.runAction(SCNAction.group([rotate,moveon,fadeout]))
        
        default:
            print("Hit something useless collectible")
        }
    }
}
