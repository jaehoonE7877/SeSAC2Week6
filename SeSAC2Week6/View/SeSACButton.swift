//
//  SeSACButton.swift
//  SeSAC2Week6
//
//  Created by Seo Jae Hoon on 2022/08/09.
//

import UIKit

/*
 Swift Attribute(속성)
 @IBInspectable, @IBDesignable, @objc, @escaping, @available, @discardableResult, etc.
 */



//공통적인 버튼을 디자인(인터페이스 빌더 컴파일 시점 실시간으로 객체 속성을 확인할 수 있음)
@IBDesignable class SeSACButton: UIButton {
    

    @IBInspectable
    var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    @IBInspectable
    var borderColor: UIColor {
        get { return UIColor (cgColor: layer.borderColor!) }
        set { layer.borderColor = newValue.cgColor }
    }
}
