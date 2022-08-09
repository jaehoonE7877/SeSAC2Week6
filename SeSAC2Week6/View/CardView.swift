//
//  CardView.swift
//  SeSAC2Week6
//
//  Created by Seo Jae Hoon on 2022/08/09.
//

import UIKit

/*
 Xml Interface Builder
 1. UIView Custom Class 지정
 2. 커스텀 클래스를 주지 않고, File's Owner에 view를 주는 것 => 자유도가 높고 확장성이 좋다
 그러나 여러 뷰를 사용하는 곳엔 제약이 있다.
 */

/*
 View: 인터페이스 빌더기반 UI 초기화 구문: required init?
    - 프로토콜 초기화 구문: required > 초기화 구문이 프로토콜로 명세되어 있음
 <-> 코드 UI 초기화 구문: override init
 
 */



class CardView: UIView {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var contentLabel: UILabel!
    

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        let view = UINib(nibName: "CardView", bundle: nil).instantiate(withOwner: self).first as! UIView
        
        view.frame = bounds
        view.backgroundColor = .lightGray
        self.addSubview(view)
    }
    
    
}
