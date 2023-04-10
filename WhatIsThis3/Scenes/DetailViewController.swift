//
//  DetailViewController.swift
//  WhatIsThis3
//
//  Created by eun-ji on 2023/04/09.
//

//TODO: 이미지 저장기능, 데이터 베이스 저장기능 수정

import UIKit
import CoreData

//protocol DetailViewControllerDelegate: AnyObject {
//    func fetchImage()
//}

class DetailViewController: UIViewController {

    @IBOutlet weak var detailCollectionView: UICollectionView!

    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var commentTextField: UITextField!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    
//    weak var delegate: DetailViewControllerDelegate?
    var customerList = [CustomerList]()
    var selectedCustomerList: Customer?
    var indexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailCollectionView.collectionViewLayout = layout()
        detailCollectionView.delegate = self
        detailCollectionView.dataSource = self
        fetchImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        if let hasData = selectedCustomerList {
            titleLabel.text = hasData.title
            contentLabel.text = hasData.content
        }
    }
 
    private func layout() -> UICollectionViewCompositionalLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func fetchImage() {
        let fetchRequest : NSFetchRequest<CustomerList> = CustomerList.fetchRequest()
        let context = appdelegate.persistentContainer.viewContext
        
        do {
            self.customerList = try context.fetch(fetchRequest)
        } catch {
            print(error)
        }
    }
    
}

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return customerList.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailVCCell", for: indexPath) as! DetailCollectionViewCell
        let photo = UIImage(data: customerList[indexPath.item].image!)
        cell.detailImageView.image = photo
        return cell
    }

}
