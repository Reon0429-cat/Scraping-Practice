//
//  ViewController.swift
//  Scraping-Practice
//
//  Created by 大西玲音 on 2021/11/01.
//

import UIKit
import Alamofire
import Kanna

final class ViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var beefbowl = [Gyudon]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getGyudonPrice()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CustomTableViewCell.nib,
                           forCellReuseIdentifier: CustomTableViewCell.identifier)
        
    }
    
    func getGyudonPrice() {
        AF.request("https://www.yoshinoya.com/menu/gyudon/gyu-don/").responseString { response in
            switch response.result {
                case .success(let value):
                    if let doc = try? HTML(html: value, encoding: .utf8) {
                        var sizes = [String]()
                        for link in doc.xpath("//th[@class='menu-size']") {
                            sizes.append(link.text ?? "")
                        }
                        var prices = [String]()
                        for link in doc.xpath("//td[@class='menu-price']") {
                            prices.append(link.text ?? "")
                        }
                        for (index, value) in sizes.enumerated() {
                            let gyudon = Gyudon()
                            gyudon.size = value
                            gyudon.price = prices[index]
                            self.beefbowl.append(gyudon)
                        }
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    print("DEBUG_PRINT: ", error.localizedDescription)
            }
        }
    }
    
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return beefbowl.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier) as! CustomTableViewCell
        let gyudon = beefbowl[indexPath.row]
        cell.configure(title: gyudon.price, size: gyudon.size)
        return cell
    }
    
}
