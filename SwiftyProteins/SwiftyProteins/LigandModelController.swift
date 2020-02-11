//
//  LigandModelController.swift
//  SwiftyProteins
//
//  Created by Ihor KOVALENKO on 1/27/20.
//  Copyright © 2020 Ihor KOVALENKO. All rights reserved.
//

import UIKit
import SceneKit

class LigandModelController: UIViewController {
    var ligandName = ""
    var connects : [[Int]] = []
    var atom : [(number: Int, x: Float, y: Float, z:Float, type: String)] = []
    var scene : SCNScene? = nil

    @IBOutlet weak var chosenElement: UILabel!
    @IBOutlet weak var ligandScene: SCNView!
    
    
    
    @IBAction func changeColor(_ sender: Any) {
        if chosenElement.textColor == UIColor(hexString: "FCFCFC") {
            scene!.background.contents = UIColor.black
            self.view.backgroundColor = UIColor.black
            chosenElement.textColor = UIColor.white
        }
        else if chosenElement.textColor == UIColor.white {
            scene!.background.contents = UIColor.white
            self.view.backgroundColor = UIColor.white
            chosenElement.textColor = UIColor.black
        }
        else {
           scene!.background.contents = UIColor(hexString: "#373337")
            self.view.backgroundColor = UIColor(hexString: "#373337")
            chosenElement.textColor = UIColor(hexString: "FCFCFC")
        }
        
    }
    
    @IBAction func shareBtn(_ sender: Any) {
        let scrSht = ligandScene.snapshot()
        let vc = UIActivityViewController(activityItems: [scrSht], applicationActivities: [])
        present(vc, animated: true)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        chosenElement.textColor = UIColor(hexString: "FCFCFC")
        chosenElement.isHidden = true
        let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LigandModelController.wasTaped))
        singleTap.numberOfTapsRequired = 1
        singleTap.numberOfTouchesRequired = 1
        self.ligandScene.isUserInteractionEnabled = true
        self.ligandScene.addGestureRecognizer(singleTap)
        print("last ligand: " + ligandName)
        print(atom.count)
        print(connects)
        scene = SCNScene()
        ligandScene.scene = scene
        scene!.background.contents = UIColor(hexString: "#373337")
        for atoms in atom {
            let sphere = SCNSphere(radius: 0.35)
            sphere.firstMaterial?.diffuse.contents = cpkColoring(type: atoms.type)
            let sphereNode = SCNNode(geometry: sphere)
            sphereNode.position = SCNVector3(x: atoms.x, y: atoms.y, z: atoms.z)
            scene!.rootNode.addChildNode(sphereNode)
        }
        for connect in connects {
            let from = SCNVector3(CGFloat(atom[connect[0] - 1].x), CGFloat(atom[connect[0] - 1].y), CGFloat(atom[connect[0] - 1].z))
            for con in connect {
                if (con != connect[0]) {
                    let to = SCNVector3(CGFloat(atom[con - 1].x), CGFloat(atom[con - 1].y), CGFloat(atom[con - 1].z))
                    scene!.rootNode.addChildNode(getCylinder(from: from, to: to))
                }
            }
        }
        ligandScene.backgroundColor = UIColor.white
        ligandScene.autoenablesDefaultLighting = true
        ligandScene.allowsCameraControl = true

        // Do any additional setup after loading the view
    }
    
    @objc func wasTaped(tap: UITapGestureRecognizer) {
        let location = self.ligandScene.hitTest(tap.location(in: ligandScene), options: nil)
        if let node = location.first?.node {
            for atoms in atom {
                if (atoms.x == node.position.x && atoms.y == node.position.y && atoms.z == node.position.z) {
                    chosenElement.isHidden = false
                    print(atoms.type)
                    chosenElement.text = "Chosen element is: " + atoms.type
                }
            }
        } else {
            chosenElement.isHidden = true
        }
    }
    
    func cpkColoring(type: String) -> UIColor {
        var color: UIColor
        switch (type) {
        case "H":
            color = UIColor(hexString: "#ffffff")
        case "C":
            color = UIColor(hexString: "#909090")
        case "N":
            color = UIColor(hexString: "#556de3")
        case "O":
            color = UIColor(hexString: "#ff0a09")
        case "F", "CL":
            color = UIColor(hexString: "#8fe04f")
        case "S":
            color = UIColor(hexString: "#ffff31")
        case "BR":
            color = UIColor(hexString: "#a62a29")
        case "I":
            color = UIColor(hexString: "#940094")
        case "P":
            color = UIColor(hexString: "#ffa500")
        case "HE", "NE", "AR", "XE", "KR":
            color = UIColor(hexString: "#02ffff")
        case "FE":
            color = UIColor(hexString: "#dd7702")
        case "TI":
            color = UIColor(hexString: "#dd7702")
        default:
            color = UIColor(hexString: "#cc88e2")
        }
        
        return color
    }
    
    
    func getCylinder(from: SCNVector3, to: SCNVector3) -> SCNNode {
        let height = CGFloat(GLKVector3Distance(SCNVector3ToGLKVector3(from), SCNVector3ToGLKVector3(to)))
        let startNode = SCNNode()
        let endNode = SCNNode()
        startNode.position = from
        endNode.position = to
        let zAxisNode = SCNNode()
        zAxisNode.eulerAngles.x = .pi/2

        let cylinderGeometry = SCNCylinder(radius: 0.1, height: height)
        cylinderGeometry.firstMaterial?.diffuse.contents = UIColor.gray
        let cylinder = SCNNode(geometry: cylinderGeometry)

        cylinder.position.y = Float(-height/2)
        zAxisNode.addChildNode(cylinder)

        let returnNode = SCNNode()

        if (from.x > 0.0 && from.y < 0.0 && from.z < 0.0 && to.x > 0.0 && to.y < 0.0 && to.z > 0.0)
        {
            endNode.addChildNode(zAxisNode)
            endNode.constraints = [ SCNLookAtConstraint(target: startNode) ]
            returnNode.addChildNode(endNode)

        }
        else if (from.x < 0.0 && from.y < 0.0 && from.z < 0.0 && to.x < 0.0 && to.y < 0.0 && to.z > 0.0)
        {
            endNode.addChildNode(zAxisNode)
            endNode.constraints = [ SCNLookAtConstraint(target: startNode) ]
            returnNode.addChildNode(endNode)

        }
        else if (from.x < 0.0 && from.y > 0.0 && from.z < 0.0 && to.x < 0.0 && to.y > 0.0 && to.z > 0.0)
        {
            endNode.addChildNode(zAxisNode)
            endNode.constraints = [ SCNLookAtConstraint(target: startNode) ]
            returnNode.addChildNode(endNode)

        }
        else if (from.x > 0.0 && from.y > 0.0 && from.z < 0.0 && to.x > 0.0 && to.y > 0.0 && to.z > 0.0)
        {
            endNode.addChildNode(zAxisNode)
            endNode.constraints = [ SCNLookAtConstraint(target: startNode) ]
            returnNode.addChildNode(endNode)

        }
        else
        {
            startNode.addChildNode(zAxisNode)
            startNode.constraints = [ SCNLookAtConstraint(target: endNode) ]
            returnNode.addChildNode(startNode)
        }
        
        return returnNode
    }

}

extension UIColor {
convenience init(hexString: String, alpha: CGFloat = 1.0) {
   let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
   let scanner = Scanner(string: hexString)
   if (hexString.hasPrefix("#")) {
     scanner.scanLocation = 1
   }
   var color: UInt32 = 0
   scanner.scanHexInt32(&color)
   let mask = 0x000000FF
   let r = Int(color >> 16) & mask
   let g = Int(color >> 8) & mask
   let b = Int(color) & mask
   let red = CGFloat(r) / 255.0
   let green = CGFloat(g) / 255.0
   let blue = CGFloat(b) / 255.0
   self.init(red:red, green:green, blue:blue, alpha:alpha)
}
func toHexString() -> String {
   var r:CGFloat = 0
   var g:CGFloat = 0
   var b:CGFloat = 0
   var a:CGFloat = 0
   getRed(&r, green: &g, blue: &b, alpha: &a)
   let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
   return String(format:"#%06x", rgb)
}
}
