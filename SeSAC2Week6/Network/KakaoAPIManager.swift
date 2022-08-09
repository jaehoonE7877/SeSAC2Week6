//
//  KakaoAPIManager.swift
//  SeSAC2Week6
//
//  Created by Seo Jae Hoon on 2022/08/08.
//

import Foundation

import Alamofire
import SwiftyJSON

class KakaoAPIManager {
    
    static let shared = KakaoAPIManager()
    
    private init() { }
    
    let header : HTTPHeaders = ["Authorization": "KakaoAK \(APIKey.kakao)"]
    
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
