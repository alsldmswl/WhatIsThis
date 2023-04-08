//
//  MainViewController.swift
//  WhatIsThis3
//
//  Created by eun-ji on 2023/04/08.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var MainCollectionView: UICollectionView!
    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        MainCollectionView.collectionViewLayout = layout()
        MainCollectionView.delegate = self
        MainCollectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    

    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        let writeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "WriteViewController")
        writeViewController.modalPresentationStyle = .fullScreen
        navigationController?.show(writeViewController, sender: nil)
    }
    
    
    private func layout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(140))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(140))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
    
}
extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 40
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainVCCell", for: indexPath) as! MainVCCell
        return cell
    }
    
    
}

