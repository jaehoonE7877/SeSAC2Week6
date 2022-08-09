//
//  CardCollectionViewCell.swift
//  SeSAC2Week6
//
//  Created by Seo Jae Hoon on 2022/08/09.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cardView: CardView!
    
    //변경되지 않는 UI font color같이 변하지 않는 데이터를 작성
    //셀이 생성이 되는 시점에서만 호출되며, 재사용되는 시점에는 호출되지 않는다.
    override func awakeFromNib() {
        super.awakeFromNib()

        setupUI()
        
    }

    func setupUI() {
        cardView.backgroundColor = .clear
        cardView.posterImageView.backgroundColor = .lightGray
        cardView.posterImageView.layer.cornerRadius = 10
        cardView.likeButton.tintColor = .systemRed
    }
    
}
