//
//  MainViewController.swift
//  SeSAC2Week6
//
//  Created by Seo Jae Hoon on 2022/08/09.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    
    @IBOutlet weak var mainTableView: UITableView!
    
    
    let color: [UIColor] = [ .yellow , .lightGray, .brown, .magenta, .blue]
    
    let numberList: [[Int]] = [
        [Int](100...110),
        [Int](55...75),
        [Int](5000...5006),
        [Int](51...60),
        [Int](61...70),
        [Int](71...80),
        [Int](81...90)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        bannerCollectionView.delegate = self
        bannerCollectionView.dataSource = self
        
        bannerCollectionView.register(UINib(nibName: "CardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CardCollectionViewCell")
        bannerCollectionView.collectionViewLayout = collectionViewLayout()
        
        bannerCollectionView.isPagingEnabled = true // device width 기준으로 움직여주기 때문에 cell의 크기와는 무관
        bannerCollectionView.showsHorizontalScrollIndicator = false
    }
    
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == bannerCollectionView ? color.count : numberList[collectionView.tag].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCollectionViewCell", for: indexPath) as? CardCollectionViewCell else { return UICollectionViewCell() }
        
        if collectionView == bannerCollectionView {
            cell.cardView.posterImageView.backgroundColor = color[Int.random(in: 0...4)]
        } else {
            cell.cardView.posterImageView.backgroundColor = .black
            cell.cardView.contentLabel.textColor = .white
            cell.cardView.contentLabel.text = "\(numberList[collectionView.tag][indexPath.item])"
        }
        
        
        
        return cell
    }
    
    func collectionViewLayout() -> UICollectionViewFlowLayout{
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width , height: bannerCollectionView.frame.height)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        return layout
    }
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return numberList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        
        cell.backgroundColor = .yellow
        cell.contentCollectionView.backgroundColor = .green
        
        //⭐️중요
        cell.contentCollectionView.delegate = self
        cell.contentCollectionView.dataSource = self
        //내부에 있는 컬렉션 뷰에 cell의 nib을 꼭 지정해줘야 됨
        cell.contentCollectionView.register(UINib(nibName: "CardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CardCollectionViewCell")
        //테이블 뷰 속 컬렉션 뷰 셀 구분 짓기
        cell.contentCollectionView.tag = indexPath.section
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 3 ? 350 : 190
    }
    
}
