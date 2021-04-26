//
//  FirstVc.swift
//  NumMemery
//
//  Created by rphaeh on 2021/4/26.
//

import UIKit

class FirstVc: BaseVController {

    var dataSource: [String] = ["数字桩", "地点桩"]
    @IBOutlet var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            tableView.estimatedRowHeight = 40
            //设置重用ID
            tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    

}

extension FirstVc: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
        cell.textLabel?.text = dataSource[indexPath.row]
            
            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
