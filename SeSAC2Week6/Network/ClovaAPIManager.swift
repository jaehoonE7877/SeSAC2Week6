//
//  ClovaAPIManager.swift
//  SeSAC2Week6
//
//  Created by Seo Jae Hoon on 2022/08/12.
//

import Foundation

import Alamofire
import SwiftyJSON

class ClovaAPIManager {
    
    static let shared = ClovaAPIManager()
    
    private init() { }
    
    // 네이버 클로바 얼굴인식 네트워킹
    func callRequest(imageData: Data, completionhandler: @escaping (JSON) -> ()){
        
        let url = URL.clovaCelebrityURL
        
        //헤더에 어떤 파일의 종류가 서버에게 전달이 되는지 명시
        let header: HTTPHeaders = [
            "X-Naver-Client-Id" : "\(APIKey.naverID)",
            "X-Naver-Client-Secret" : "\(APIKey.naverSecret)"
            //"Content-Type" : "multipart/form-data" 왜 안해도 될까요? 이미 라이브러리에 들어있음
        ]
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "image")  //
        }, to: url, headers: header)
        .validate(statusCode: 200...500).responseData { response in //앞쪽 접두어 AF로 바꿔야 함
            switch response.result {
            case .success(let value):

                let json = JSON(value)
                completionhandler(json)
                
            case .failure(let error):
                print(error)
                
            }
        }
    }
}
