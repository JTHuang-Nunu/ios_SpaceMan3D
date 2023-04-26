//
//  Collectable.swift
//  SpaceMan3D
//
//  Created by Mac15 on 2023/4/20.
//

import Foundation
import SceneKit

class Collectable {
    class func pyramidNode() -> SCNNode{
        let pyramid = SCNPyramid(width: 31.6, height: 20, length: 30)
        let pyramidNode = SCNNode(geometry: pyramid)
        pyramidNode.name = "pyramid"
        let position = SCNVector3Make(30, 0, -40)
        pyramidNode.position = position
        pyramidNode.geometry?.firstMaterial?.diffuse.contents = "boxSide3"
        pyramidNode.geometry?.firstMaterial?.shininess = 1.0
        return pyramidNode
    }
    
    class func sphereNode() -> SCNNode {
        let sphere = SCNSphere(radius: 30.0)
        let sphereNode = SCNNode(geometry: sphere)
        sphereNode.name = "sphere"
        let position = SCNVector3(x: 0, y: 40, z: -100)
        sphereNode.position = position
        sphereNode.geometry?.firstMaterial?.diffuse.contents = "earthDiffuse"
        let action = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 10, z: 0, duration: 5))
        sphereNode.runAction(action)
        return sphereNode
    }
    
    class func boxNode() -> SCNNode {
        let box = SCNBox(width: 6, height: 6, length: 6, chamferRadius: 0)
        let boxNode = SCNNode(geometry: box)
        let position = SCNVector3(30 , 10, 20)
        boxNode.name = "box"
        boxNode.position = position
        boxNode.geometry?.firstMaterial?.diffuse.contents = "boxSide2"
        boxNode.geometry?.firstMaterial?.shininess = 1.0

        return boxNode
    }
    
    class func tubeNode() -> SCNNode {
        let tube = SCNTube(innerRadius: 8, outerRadius: 10.0, height: 30.0)
        let tubeNode = SCNNode(geometry: tube)
        let position = SCNVector3(-50, 20, 0)
        tubeNode.name = "tube"
        tubeNode.position = position
        tubeNode.geometry?.firstMaterial?.diffuse.contents = UIColor.yellow
        tubeNode.geometry?.firstMaterial?.shininess = 1.0

        return tubeNode
    }
    
    class func cylinderNode() -> SCNNode {
        let cylinder = SCNCylinder(radius: 6, height: 30)
        let cylinderNode = SCNNode(geometry: cylinder)
        cylinderNode.name = "cylinder"
        
        let position = SCNVector3(30, 15, 50)
        cylinderNode.position = position
        cylinderNode.geometry?.firstMaterial?.diffuse.contents = "boxSide4"
        cylinderNode.geometry?.firstMaterial?.shininess = 1.0

        return cylinderNode
    }
    
    
    class func torusNode() -> SCNNode {
        let torus = SCNTorus(ringRadius: 12, pipeRadius: 5)
        let torusNode = SCNNode(geometry: torus)
        let position = SCNVector3(-40, 15, 50)
        torusNode.position = position
        torusNode.geometry?.firstMaterial?.diffuse.contents = "boxSide4"
        torusNode.geometry?.firstMaterial?.shininess = 1.0

        return torusNode
    }
    
    class func capsuleNode() -> SCNNode {
        let capsule = SCNCapsule(capRadius: 10, height: 70)
        let capsuleNode = SCNNode(geometry: capsule)
        let position = SCNVector3(0, 25, 70)
        capsuleNode.name = "capsule"
        
        capsuleNode.position = position
        capsuleNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        capsuleNode.geometry?.firstMaterial?.shininess = 1.0
        return capsuleNode
    }
}
