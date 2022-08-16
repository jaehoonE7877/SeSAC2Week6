//
//  MainTableViewCell.swift
//  SeSAC2Week6
//
//  Created by Seo Jae Hoon on 2022/08/09.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    // contectCollectionView 도 delegate, datasource가 필요함 => MainViewController에 위임
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        print("MainTableViewCell", #function)
        
        setupUI()
        
    }

    private func setupUI() {
        
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.text = "넷플릭스 인기 콘텐츠"
        titleLabel.backgroundColor = .clear
        
        contentCollectionView.collectionViewLayout = collectionViewLayout()
    }

    private func collectionViewLayout() -> UICollectionViewFlowLayout {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 300, height: 180)
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        // 왼쪽 여백은 위에 제목 레이블 만큼 띄워서 정돈되게
        
        return layout
    }
    
    
}
