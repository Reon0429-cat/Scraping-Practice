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
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var gitHubGrass = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        letsScraping()
        
    }
    
    func letsScraping() {
        AF.request("https://github.com/Reon0429-cat").responseString { response in
            switch response.result {
                case .success(let value):
                    if let doc = try? HTML(html: value, encoding: .utf8) {
                        let grass = doc.css("rect").compactMap { $0["data-count"] }
                        self.gitHubGrass = grass.compactMap { Int($0) }
                        print("DEBUG_PRINT: ", self.gitHubGrass.reduce(0, +))
                        self.collectionView.reloadData()
                    }
                case .failure(let error):
                    print("DEBUG_PRINT: ", error.localizedDescription)
            }
        }
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CustomCollectionViewCell.nib,
                                forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        collectionView.collectionViewLayout = layout
    }
    
}

extension ViewController: UICollectionViewDelegate {
    
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        gitHubGrass.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CustomCollectionViewCell.identifier,
            for: indexPath
        ) as! CustomCollectionViewCell
        let value = gitHubGrass[indexPath.item]
        cell.configure(value: value)
        return cell
    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.width / 7 - 10
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
}

