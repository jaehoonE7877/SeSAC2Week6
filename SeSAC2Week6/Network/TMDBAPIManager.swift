//
//  TMDBAPIManager.swift
//  SeSAC2Week6
//
//  Created by Seo Jae Hoon on 2022/08/10.
//

import Foundation

import Alamofire
import SwiftyJSON

class TMDBAPIManager {
    
    static let shared = TMDBAPIManager()
    
    private init() { }
    
    let tvList = [
        ("환혼", 135157),
        ("이상한 변호사 우영우", 197067),
        ("인사이더", 135655),
        ("미스터 션사인", 75820),
        ("스카이 캐슬", 84327),
        ("사랑의 불시착", 94796),
        ("이태원 클라스", 96162),
        ("호텔 델루나", 90447)
    ]
        
    let imageURL = "https://image.tmdb.org/t/p/w500"
    
    func callRequest(query: Int, completionHandler: @escaping ([String]) -> () ) {
        
        let seasonURL = "https://api.themoviedb.org/3/tv/\(query)/season/1?api_key=\(APIKey.tmdb)&language=ko-KR"

        AF.request(seasonURL, method: .get).validate().responseData { response in //앞쪽 접두어 AF로 바꿔야 함
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                
                
                
                let value = json["episodes"].map { $0.1["still_path"].stringValue }
                completionHandler(value)
                
            case .failure(let error):
                print(error)
                
            }
        }
    }
    
    func requestImage(completionHandler: @escaping ([[String]]) -> ()) {
        
        var posterList: [[String]] = []
        
        TMDBAPIManager.shared.callRequest(query: tvList[0].1) { value in
            posterList.append(value)

            TMDBAPIManager.shared.callRequest(query: self.tvList[1].1) { value in
                posterList.append(value)

                TMDBAPIManager.shared.callRequest(query: self.tvList[2].1) { value in
                    posterList.append(value)
                   
                    TMDBAPIManager.shared.callRequest(query: self.tvList[3].1) { value in
                        posterList.append(value)
                     
                        TMDBAPIManager.shared.callRequest(query: self.tvList[4].1) { value in
                            posterList.append(value)
                           
                            TMDBAPIManager.shared.callRequest(query: self.tvList[5].1) { value in
                                posterList.append(value)
                                
                                TMDBAPIManager.shared.callRequest(query: self.tvList[6].1) { value in
                                    posterList.append(value)
                                    
                                    TMDBAPIManager.shared.callRequest(query: self.tvList[7].1) { value in
                                        posterList.append(value)
                                        completionHandler(posterList)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
//    func requestEpisodeImage() {
//
//        어떤 문제? =>
//        1. 순서가 보장되지 않는다.
//        2. 언제 끝날 지 모름
//        3. 차단당할 수 있다.(서버로부터)
//        for item in tvList {
//            TMDBAPIManager.shared.callRequest(query: item.1) { stillPath in
//                print(stillPath)
//            }
//        }
//
//        let id = tvList[7].1
//
//        TMDBAPIManager.shared.callRequest(query: id) { stillPath in
//
//            print(stillPath)
//            TMDBAPIManager.shared.callRequest(query: self.tvList[5].1) { stillPath in
//
//                print(stillPath)
//            }
//
//
//
//        }
//    }
}
