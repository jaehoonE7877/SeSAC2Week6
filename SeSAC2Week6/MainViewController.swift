//
//  MainViewController.swift
//  SeSAC2Week6
//
//  Created by Seo Jae Hoon on 2022/08/09.
//

import UIKit

import Kingfisher
/*
 awakeFromNib - 셀 UI 초기화, 재사용 메커니즘에 의해 일정 횟수 이상 호출되지 않음.
 cellforItemAt
 - 재사용 될 때마다, 사용자에게 보일 때 마다 항상 호출
 - 화면과 데이터는 별개, 모든 indexPath.item에 대한 조건이 없다면 재사용 시 오류가 발생할 수 있음.
 prepareForReuse
 - 셀이 재사용 될 때 초기화 하고자 하는 값을 넣으면 오류를 해결할 수 잇음. 즉, cellForRowAt에서 모든 indexPath.item에 대한 조건을 작성하지 않아도 됨!
 CollectionView in TableView
 - 하나의 컬렉션뷰나 테이블뷰라면 문제가 없다
 - 그러나 복합적인 구조로 이루어져있으면 테이블뷰셀도 재사용 되어야하고, 컬렉션뷰셀도 재사용이 되어야 함
 - Index > reloadData를 통해서 해결
 */


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
    
    var episodeList = [[String]]()
    
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
        
        TMDBAPIManager.shared.requestImage { posterList in
            dump(posterList)
            //1. 네트워크 통신 2. 배열 생성 3. 배열에 요소 담기 4. 뷰 등에 표현 5. 뷰 갱신!(reloadData)
            self.episodeList = posterList
            self.mainTableView.reloadData()
        }
    }
    
}
//UICollectionViewDelegateFlowLayout - sizeForItemAt (역동적인 셀)
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == bannerCollectionView ? color.count : episodeList[collectionView.tag].count
    }
    
    //bannerCollectionView or 테이블뷰 안에 들어있는 컬렉션뷰
    //내부 매개변수가 아닌 명확한 아웃렛을 사용할 경우,셀이 재사용되면 특정 collectionView 셀을 재사용하게 될 수 있음
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //print("MainViewController", #function, indexPath)
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCollectionViewCell.reuseIdentifier, for: indexPath) as? CardCollectionViewCell else { return UICollectionViewCell() }
        
        if collectionView == bannerCollectionView {
            cell.cardView.posterImageView.backgroundColor = color[Int.random(in: 0...4)]
        } else {
            cell.cardView.posterImageView.backgroundColor = .black
            cell.cardView.contentLabel.textColor = .white
            
            //화면과 데이터는 별개, 모든 indexPath.item에 대한 조건이 없다면 재사용 시 오류가 발생할 수 있음/
            //if indexPath.item < 2 {
            //cell.cardView.contentLabel.text = "\(numberList[collectionView.tag][indexPath.item])"
            //}
            
            let url = URL(string: "\(TMDBAPIManager.shared.imageURL)\(episodeList[collectionView.tag][indexPath.item])")
            cell.cardView.posterImageView.kf.setImage(with: url)
            
            cell.cardView.contentLabel.text = ""
            cell.cardView.posterImageView.contentMode = .scaleToFill
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
        return episodeList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    //내부 매개변수 tableView를 통해 테이블뷰를 특정
    //테이블뷰 객체가 하나 일 경우에는 내부 매개변수를 활용하지 않아도 문제가 생기지 않는다.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.reuseIdentifier, for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        
        //print("MainViewController", #function, indexPath)
        
        cell.backgroundColor = .yellow
        cell.titleLabel.text = "\(TMDBAPIManager.shared.tvList[indexPath.section].0) 드라마 다시보기"
        
        cell.contentCollectionView.backgroundColor = .green
        
        //⭐️중요
        cell.contentCollectionView.delegate = self
        cell.contentCollectionView.dataSource = self
        //내부에 있는 컬렉션 뷰에 cell의 nib을 꼭 지정해줘야 됨
        cell.contentCollectionView.register(UINib(nibName: CardCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: CardCollectionViewCell.reuseIdentifier)
        //테이블 뷰 속 컬렉션 뷰 셀 구분 짓기
        cell.contentCollectionView.tag = indexPath.section      //UIView Tag
        
        //더 큰 크기의 cell에서 reloadData()를 해줘야 됨
        cell.contentCollectionView.reloadData() // Index Out of Range 오류를 해결할 수 있음!!⭐️
        
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
    
}
