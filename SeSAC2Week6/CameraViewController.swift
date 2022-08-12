//
//  CameraViewController.swift
//  SeSAC2Week6
//
//  Created by Seo Jae Hoon on 2022/08/12.
//

import UIKit

import Alamofire
import SwiftyJSON
import YPImagePicker


class CameraViewController: UIViewController {

    
    @IBOutlet weak var resultImageView: UIImageView!
    
    //UIImagePickerController 1.인스턴스 생성
    let picker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //UIImagePickerController 2. delegate 연결
        picker.delegate = self
        
        
        resultImageView.contentMode = .scaleAspectFill
    }
    
    // 사진을 라이브러리에 저장
    @IBAction func saveToPhotoLibrary(_ sender: UIButton) {
        print(#function)
        if let image = resultImageView.image {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
        
    }
    
    //OpenSource
    //권한은 일단 다 허용상태로 해주기
    //권한 문구 등도 내부적으로 구현! 실제로 카메라를 쓸 때 권한을 요청
    @IBAction func YPImagePickerButtonTapped(_ sender: UIButton) {
        
        let picker = YPImagePicker()
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                print(photo.fromCamera) // Image source (camera or library)
                print(photo.image) // Final image selected by the user
                print(photo.originalImage) // original image selected by the user, unfiltered
                print(photo.modifiedImage) // Transformed image, can be nil
                print(photo.exifMeta) // Print exif meta data of original image.
                
                self.resultImageView.image = photo.image
                
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)

        
    }
   
    
    //UIImagePickerController
    @IBAction func cameraButtonTapped(_ sender: UIButton) {
        
        //카메라를 사용할 수 있는 기기인가를 판별
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("사용불가 + 사용자에게 토스트 / 얼럿")
            return
        }
        // 카메라 촬영을 띄울지, 갤러리 쪽을 띄울지 선택
        picker.sourceType = .camera
        // 사진 촬영 후 편집이 가능한지
        picker.allowsEditing = false // 편집 화면
        
        present(picker, animated: true)
        
        
    }
    //UIImagePickerController
    @IBAction func photoLibraryButtonTapped(_ sender: UIButton) {
        
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("사용불가 + 사용자에게 토스트 / 얼럿")
            return
        }
        
        picker.sourceType = .photoLibrary
        picker.allowsEditing = false
        
        present(picker, animated: true)
    }
    // 이미지뷰 이미지 > 네이버 > 얼굴 분석 해줘 요청 > 응답!
    // 문자열이 아닌 파일, 이미지, pdf 파일 자체가 그대로 전송되지 않음. => 텍스트 형태로 인코딩
    // 어떤 파일의 종류가 서버에게 전달이 되는 지 명시 = ContentType
    @IBAction func clovaFaceButtonTapped(_ sender: UIButton) {
        print(#function)
        let url = "https://openapi.naver.com/v1/vision/celebrity"
        
        //헤더에 어떤 파일의 종류가 서버에게 전달이 되는지 명시
        let header: HTTPHeaders = [
            "X-Naver-Client-Id" : "TNRc5NfUf6sqkTiPy72M",
            "X-Naver-Client-Secret" : "ZWKJLPOWyO"
            //"Content-Type" : "multipart/form-data" 왜 안해도 될까요? 이미 라이브러리에 들어있음
        ]
        
        // 네이버 클로바 얼굴인식 네트워킹
        
        // UIImage를 텍스트 형태(바이너리 타입)로 변환해서 전달
        guard let imageData = resultImageView.image?.jpegData(compressionQuality: 0.5) else { return }
        
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "image")  //
        }, to: url, headers: header)
        .validate(statusCode: 200...500).responseData { response in //앞쪽 접두어 AF로 바꿔야 함
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                print(json)
                
            case .failure(let error):
                print(error)
                
            }
        }
        
        
        
        
    }
    
}

//UIImagePickerController 3. 프로토콜 채택(UINavigationControllerDelegate도 채택해야 함(상속관계))
extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //UIImagePickerController 4. 카메라 촬영 후, 갤러리에서 사진을 선택한 후의 동작
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(#function)
        
        //원본사진, 편집 사진, 메타 데이터 => InfoKey로 관리
        //분기처리
//        picker.sourceType == .camera {
//
//        }
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.resultImageView.image = image
            
            // 사진 찍고나서, 언제 사라질 지 구현해줘야 함
            dismiss(animated: true)
        }
    }
    
    //왼쪽 하단의 취소버튼 눌렀을 때 어떻게 할 것인지(dismiss 기능은 내가 구현해야 함)
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print(#function)
    }
    
    
    
}

// 오늘 과제 => 오픈 웨더 구현(위치 base)
// clova APi => 코드 구조 개선
// UIButton ( iOS15+에선 어떻게 다뤄지나?!)
