//
//  AnimatedSceneViewController.swift
//  Scene Kit Kitchen
//
//  Created by Kathleen Chung on 2018-07-30.
//  Copyright © 2018 Kathleen Chung. All rights reserved.
//

import UIKit
import SceneKit

class AnimatedSceneViewController: UIViewController {

    var sceneView: SCNView!
    var camera: SCNNode!
    var ground: SCNNode!
    var light: SCNNode!
    var button: SCNNode!
    var sphere1: SCNNode!
    var sphere2: SCNNode!

    override func viewDidLoad() {
        super.viewDidLoad()

        sceneView = SCNView(frame: view.frame)
        sceneView.scene = SCNScene()
        view.addSubview(sceneView)

        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        tapRecognizer.addTarget(self, action: #selector(sceneTapped))
        sceneView.gestureRecognizers = [tapRecognizer]

        let groundGeometry = SCNFloor()
        groundGeometry.reflectivity = 0
        let groundMaterial = SCNMaterial()
        groundMaterial.diffuse.contents = UIColor.blue
        groundGeometry.materials = [groundMaterial]
        ground = SCNNode(geometry: groundGeometry)

        let nodeCamera = SCNCamera()
        nodeCamera.zFar = 10000
        camera = SCNNode()
        camera.camera = nodeCamera
        camera.position = SCNVector3(x: -20, y: 15, z: 20)
        let constraint = SCNLookAtConstraint(target: ground)
        constraint.isGimbalLockEnabled = true
        camera.constraints = [constraint]

        let ambientLight = SCNLight()
        ambientLight.color = UIColor.darkGray
        ambientLight.type = SCNLight.LightType.ambient
        camera.light = ambientLight

        let spotLight = SCNLight()
        spotLight.type = SCNLight.LightType.spot
        spotLight.castsShadow = true
        spotLight.spotInnerAngle = 70.0
        spotLight.spotOuterAngle = 90.0
        spotLight.zFar = 500
        light = SCNNode()
        light.light = spotLight
        light.position = SCNVector3(x: 0, y: 25, z: 25)
        light.constraints = [constraint]

        let sphereGeometry = SCNSphere(radius: 1.5)
        let sphereMaterial = SCNMaterial()
        sphereMaterial.diffuse.contents = UIColor.green
        sphereGeometry.materials = [sphereMaterial]
        sphere1 = SCNNode(geometry: sphereGeometry)
        sphere1.position = SCNVector3(x: -15, y: 1.5, z: 0)
        sphere2 = SCNNode(geometry: sphereGeometry)
        sphere2.position = SCNVector3(x: 15, y: 1.5, z: 0)

        let buttonGeometry = SCNBox(width: 4, height: 1, length: 4, chamferRadius: 0)
        let buttonMaterial = SCNMaterial()
        buttonMaterial.diffuse.contents = UIColor.red
        buttonGeometry.materials = [buttonMaterial]
        button = SCNNode(geometry: buttonGeometry)
        button.position = SCNVector3(x: 0, y: 0.5, z: 15)

        sceneView.scene?.rootNode.addChildNode(camera)
        sceneView.scene?.rootNode.addChildNode(ground)
        sceneView.scene?.rootNode.addChildNode(light)
        sceneView.scene?.rootNode.addChildNode(button)
        sceneView.scene?.rootNode.addChildNode(sphere1)
        sceneView.scene?.rootNode.addChildNode(sphere2)
    }

    @objc func sceneTapped(recognizer: UITapGestureRecognizer) {
        let location = recognizer.location(in: sceneView)

        let hitResults = sceneView.hitTest(location, options: nil)
        if let result = hitResults.first {
            let node = result.node
            node.removeFromParentNode()
        }
    }
}
