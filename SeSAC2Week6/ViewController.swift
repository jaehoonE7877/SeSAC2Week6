//
//  ViewController.swift
//  SeSAC2Week6
//
//  Created by Seo Jae Hoon on 2022/08/08.
//

import UIKit

import SwiftyJSON

/*
 1. html tag <> </> 기능 활용 > 한번 찾아보기!
 2. 문자열을 대체할 수 있는 메서드
 * response에서 처리하는 것과 보여지는 셀 등에서 처리하는 것의 차이는?
 */

/*
 TableView automaticDimension
 - 컨텐츠 양에 따라서 셀 높이가 자유록세
 - 조건: 레이블 numberOfLines = 0
 - 조건: tableview 의 높이를 automaticDemensioin으로 설정
 - 조건: 레이아웃(유동적인 크기의 객체 주변과의 거리 상하좌우 잡아주기)
 */

class ViewController: UIViewController {

    @IBOutlet weak var searchTableView: UITableView!
    
    
    
    private var blogList: [String] = []
    private var cafeList = [String]()
    
    private var isExpanded = false // false: 2줄, true = 0으로!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBlog()
        
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.rowHeight = UITableView.automaticDimension  //모든 섹션의 셀에 대해서 유동적으로!

    }
    
    private func searchBlog() {
        
        //네트워킹을 하는 곳과 분리 시키기!(싱글톤 만들어서)
        KakaoAPIManager.shared.callRequest(type: .blog, query: "고래밥") { json in
            
            print(json)
            
            for item in json["documents"] {
                let data = item.1["contents"].stringValue
                self.blogList.append(data)
            }
            
            self.searchCafe()
        }
        
    }
    
    private func searchCafe() {
        
        KakaoAPIManager.shared.callRequest(type: .cafe, query: "고래밥") { json in
            
            print(json)
            
            for item in json["documents"] {
                let data = item.1["contents"].stringValue.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: "")
                self.cafeList.append(data)
            }
            print(self.blogList)
            print(self.cafeList)
            
            self.searchTableView.reloadData()
            
        }
    }


    @IBAction func expandCell(_ sender: UIBarButtonItem) {
        
        isExpanded = !isExpanded
        searchTableView.reloadData()
    }
    
    
}
    
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? blogList.count : cafeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "KakaoCell", for: indexPath) as? KakaoCell else { return UITableViewCell()}
        
        
        cell.testLabel.numberOfLines = isExpanded ? 0 : 2
        cell.testLabel.text = indexPath.section == 0 ? blogList[indexPath.row] : cafeList[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "블로그 검색결과" : "카페 검색결과"
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? UITableView.automaticDimension : 60
    }
    
}

class KakaoCell: UITableViewCell {
    
    @IBOutlet weak var testLabel: UILabel!
    

    
}



