//
//  ProteinLoader.swift
//  SwiftyProteins
//
//  Created by Ihor KOVALENKO on 1/24/20.
//  Copyright © 2020 Ihor KOVALENKO. All rights reserved.
//

import Foundation
import Alamofire

class ProteinLoader: NSObject {
    var atom : [(number: Int, x: Float, y: Float, z:Float, type: String)] = []
    var connects : [[Int]] = []
    let check = "CHEcKeR"
    func load(URL:String, Controller: ProteinsListViewController){
        Controller.spinnerWheel.isHidden = false
        Alamofire.request(URL, method: .get).responseData{ response in
            switch response.result {
            case .success(let value):
                guard let string = String(data: value, encoding: .utf8) else { return }
                self.toArrays(ligandsString: string)
                DispatchQueue.main.async {
                    Controller.spinnerWheel.isHidden = true
                    if (self.atom.count == self.connects.count) {
                        Controller.performSegue(withIdentifier: "showLigand", sender: self)
                    }
                    else {
                        let alert = UIAlertController(title: "Error", message: "Could not load a ligand", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        Controller.present(alert, animated: true)
                    }
                    
                }
            case .failure:
                let alert = UIAlertController(title: "Error", message: "Could not load a ligand", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                Controller.present(alert, animated: true)
            }
            
            
        }
    }
    
    func toArrays(ligandsString: String) {
        ligandsString.enumerateLines { line, _ in
            let params = line.split(separator: " ")
            if params[0] == "ATOM" {
                self.atom.append((number: Int(params[1])!, x:Float(params[6])!, y:Float(params[7])!, z:Float(params[8])!, type:String(params[11])))
            }
            else if params[0] == "CONECT" {
                var connects : [Int] = []
                for connect in params {
                    if (connect != "CONECT") {
                        connects.append(Int(connect)!)
                    }
                }
                self.connects.append(connects)
            }
        }
    }
}
