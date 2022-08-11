//
//  Protocol.swift
//  SeSAC2Week6
//
//  Created by Seo Jae Hoon on 2022/08/10.
//

import Foundation
import UIKit

protocol ReuseableProtocol {
    static var reuseIdentifier: String { get }
}

extension UICollectionViewCell: ReuseableProtocol {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReuseableProtocol {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
