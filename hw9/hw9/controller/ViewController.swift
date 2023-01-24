//
//  ViewController.swift
//  hw9
//
//  Created by Chin Lung on 1/21/23.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var resultTableView: UITableView!
    let searchResult = ["lol"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        resultTableView.dataSource = self;
    }


}
extension ViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = resultTableView.dequeueReusableCell(withIdentifier: "searchResultCell", for: <#T##IndexPath#>)
        cell.textLabel?.text = searchResult[indexPath.row] as! String
        return cell
    }
};
