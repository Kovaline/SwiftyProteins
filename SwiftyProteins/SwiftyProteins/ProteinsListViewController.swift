//
//  ProteinsListViewController.swift
//  SwiftyProteins
//
//  Created by Ihor KOVALENKO on 12/19/19.
//  Copyright © 2019 Ihor KOVALENKO. All rights reserved.
//

import UIKit

class ProteinsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
  
    
    @IBOutlet weak var spinnerWheel: UIActivityIndicatorView!
    var ligandsArray: [String]?
    var filteredArray: [String]?
    var ligand : String?
    @IBOutlet weak var searchProtein: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        spinnerWheel.isHidden = true
        self.navigationItem.setHidesBackButton(true, animated: true)
        tableView.backgroundColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        searchProtein.delegate = self
        let path = Bundle.main.path(forResource: "ligands", ofType: "txt")
        do {
            let file = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)
            ligandsArray = file.components(separatedBy: "\n")
            filteredArray = ligandsArray
        } catch let error {
            print(error)
        }
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredArray = ligandsArray
            tableView.reloadData()
        } else {
            filterLigands(searchText: searchText)
        }
    }
    
    
    func filterLigands(searchText: String){
        filteredArray = ligandsArray?.filter({ (ligands) -> Bool in
        return ligands.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredArray!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        cell.backgroundColor = UIColor.clear
        cell.protein.text = filteredArray![indexPath.row]
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath) as! TableViewCell
        
        ligand = currentCell.protein.text
        if ligand == "" {
            let alert = UIAlertController(title: "Error", message: "Ligand name is wrong! Could not load", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        } else {
        ProteinLoader().load(URL: "http://file.rcsb.org/ligands/download/" + currentCell.protein.text! + "_ideal.pdb", Controller: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showLigand" {
            let ligandmodel = segue.destination as! LigandModelController
            ligandmodel.ligandName = self.ligand!
            if let ligandmodeldata = sender as? ProteinLoader {
                ligandmodel.atom = ligandmodeldata.atom
                ligandmodel.connects = ligandmodeldata.connects
            }
            
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
