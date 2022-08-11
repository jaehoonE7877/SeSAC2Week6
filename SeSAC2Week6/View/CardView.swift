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
        
        //인터페이스 빌더 기반으로 레이아웃을 잡았으나 내부적으로 코드를 통해서 추가해준 기능이기 때문에
        let view = UINib(nibName: "CardView", bundle: nil).instantiate(withOwner: self).first as! UIView
        view.translatesAutoresizingMaskIntoConstraints = true
        view.frame = bounds
        view.backgroundColor = .lightGray
        self.addSubview(view)
        
        //인터페이스 빌더 기반으로 만들고, 레이아웃을 잡았는데 true로 나온다.....
        //오토레이아웃 적용이 되는 관점보다 오토리사이징이 내부적으로 constraints 처리가 됨....
        //print(view.translatesAutoresizingMaskIntoConstraints)
    }
    
    
}
