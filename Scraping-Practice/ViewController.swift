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
    
    @IBOutlet private weak var contributionLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    
    private var items = [(title: String, value: String)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        letsScraping()
        
    }
    
    func letsScraping() {
        AF.request("https://qiita.com/REON").responseString { response in
            switch response.result {
                case .success(let value):
                    if let doc = try? HTML(html: value, encoding: .utf8) {
                        let postedArticles = doc.xpath("//span[@class='css-1s0lzlm e1ojqm5t4']").compactMap { $0.text }
                        let postedArticleValues = doc.xpath("//span[@class='css-9yocrl e1ojqm5t5']").compactMap { $0.text }
                        postedArticles.enumerated().forEach { index, postedArticle in
                            self.items.append((title: postedArticle,
                                               value: postedArticleValues[index]))
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
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let item = items[indexPath.row]
        cell.textLabel?.text = item.title + item.value
        return cell
    }
    
}
