//
//  KakaoAPIManager.swift
//  SeSAC2Week6
//
//  Created by Seo Jae Hoon on 2022/08/08.
//

import Foundation

import Alamofire
import SwiftyJSON

struct User {
    fileprivate let name = "고래밥"    //같은 스위프트 파일에서 다른 클래스, 구조체 사용 가능. 다른 스위프트 파일은 X
    private let age = 22    //같은 스위프트 파일 내에서 같은 타입
}

extension User {
    
    func example() {
        print(self.name)
        print(self.age)
    }
    
}

struct Person {
    
    func example() {
        let user = User()
        user.name
        //user.age
        
    }
    
}

class KakaoAPIManager {
    
    static let shared = KakaoAPIManager()
    
    private init() { }
    
    private let header : HTTPHeaders = ["Authorization": "KakaoAK \(APIKey.kakao)"]
    
    //Alamofire + SwiftyJSON
    //검색 키워드(필수 쿼리)
    //인증키
    func callRequest(type: Endpoint ,query: String, completionHandler: @escaping (JSON) -> () ) {
        
        print(#function)
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let url = type.requesrtURL + query
        
        AF.request(url, method: .get, headers: header).validate().responseData { response in //앞쪽 접두어 AF로 바꿔야 함
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                completionHandler(json)
                
            case .failure(let error):
                print(error)
                
            }
        }
        
    }
    
}
