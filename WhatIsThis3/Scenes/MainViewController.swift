//
//  MainViewController.swift
//  WhatIsThis3
//
//  Created by eun-ji on 2023/04/08.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class MainViewController: UIViewController {

    @IBOutlet weak var MainCollectionView: UICollectionView!
    
    let db = Database.database().reference()
    var customers: [Customer] = []
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        MainCollectionView.collectionViewLayout = layout()
        MainCollectionView.delegate = self
        MainCollectionView.dataSource = self
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        fetchData()
        MainCollectionView.reloadData()
//        let email = Auth.auth().currentUser?.email ?? "고객"
        
        
        
//        sort()
    }
    
    func fetchData() {
        db.child("myCustomer").observeSingleEvent(of: .value) { snapshot in
            print("---> \(String(describing: snapshot.value))")
            
            do {
                let data = try JSONSerialization.data(withJSONObject: snapshot.value, options: [])
                let decoder = JSONDecoder()
                let custormers: [Customer] = try decoder.decode([Customer].self, from: data)
                self.customers = custormers
                DispatchQueue.main.async {
                    self.MainCollectionView.reloadData()
                }
            } catch let error {
                print("---> error: \(error.localizedDescription)")
            }
        }
    }
    
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        let writeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "WriteViewController")
        writeViewController.modalPresentationStyle = .fullScreen
        navigationController?.show(writeViewController, sender: nil)
    }
    
    @IBAction func settingButtonTapped(_ sender: UIButton) {
        
        let settingViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "SettingViewController")
        settingViewController.modalPresentationStyle = .fullScreen
        navigationController?.show(settingViewController, sender: nil)
        
    }
    
    private func layout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(140))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(140))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
    
//    func sort() {
//        storyList.sorted{
//            $0.date ?? Date() > $1.date ?? Date()
//        }
//    }
    
}
extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return customers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainVCCell", for: indexPath) as! MainVCCell
        cell.titleLabel.text = customers[indexPath.item].title
        cell.contentLabel.text = customers[indexPath.item].content
        
//        if let hasDate = storyList[indexPath.item].date {
//            let formatter = DateFormatter()
//            formatter.dateFormat = "yyyy년 MM월 dd일"
//            let dateString = formatter.string(from: hasDate)
//            cell.dateLabel.text = dateString
//        } else {
//            cell.dateLabel.text = ""
//        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "DetailViewController") as! DetailViewController
        detailViewController.modalPresentationStyle = .fullScreen
        navigationController?.show(detailViewController, sender: nil)
        let customer = self.customers[indexPath.item]
        detailViewController.selectedCustomerList = customer
        detailViewController.indexPath = indexPath
    }
 
}

extension MainViewController: WriteViewControllerDelegate1 {
    func didFinishSaveData() {
        self.fetchData()
        self.MainCollectionView.reloadData()
    }
}
