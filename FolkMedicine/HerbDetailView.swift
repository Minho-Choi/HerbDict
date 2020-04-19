//
//  HerbDetail.swift
//  FolkMedicine
//
//  Created by Minho Choi on 2020/04/18.
//  Copyright © 2020 Minho Choi. All rights reserved.
//

import SwiftUI
import Alamofire
import SwiftyXMLParser

let HerbDetailURL = "http://api.nongsaro.go.kr/service/prvateTherpy/prvateTherpyDtl"

struct HerbDetailView: View {
    
    @State var id: String
    
    var body: some View {
        HerbDetail(herbData: getDetail(id: id).herbData)
    }
}



struct herbDetail: Codable {
    
    var id: String = "205056"   //cntntsNo
    var sciName: String = "Solanum melongena (가지과)"    //bneNm
    var korName: String = "가지"    //cntntsSj
    var chnName: String = "(가체)"    //hbdcNm
    var ImgUrl1: String = "http://www.nongsaro.go.kr/cms_contents/1124/205056_MF_REPR_ATTACH_01.jpg"   //imgUrl1
    var ImgUrl2: String = "http://www.nongsaro.go.kr/cms_contents/1124/205056_MF_ATTACH_01.jpg"   //imgUrl2
    var ImgUrl3: String = "3"   //imgUrl3
    var ImgUrl4: String = "4"   //imgUrl4
    var ImgUrl5: String = "5"   //imgUrl5
    var ImgUrl6: String = "6"   //imgUrl6
    var therapy: String = "□ 티눈 치료 - 가지 꼭지를 잘라낸 부분을 티눈에 대고 2∼3분 가볍게 문지른다. - 이것을 하루에 1∼2회, 1주일쯤 계속 해주면 티눈이 마치 때 처럼 벗겨진다. \n□ 구내염 치료 - 그늘에 말린 가지 꼭지5~6개를 뚝배기나 법랑냄비에 넣고 5컵의 물을 부어 약한 불로 물이 절반 정 도까지 줄어 들어 진한 보리차 색이 날 때까지 서서히 달인다. - 달인 물에 굵은 소금을 약간 넣고 하루 2∼3회 양치질을 하면 된다. \n- 참고 : 차가우면 자극이 크기 때문에 조금 미지근하게 데워서 사용하는 것이 좋다. \n□ 치통 치료 - 가지나 가지꼭지를 말렸다가 불에 구워서 부드러운 가루를 만든다. - 여기에 소금을 약간 넣고 쌀풀이나 꿀에 개서 밤알 크기로 알약을 만들어 아픈 이로 물고 있으면 통 증이 멎는다. \n□ 화상 치료 - 가지의 잎과 줄기를 깨끗이 씻고 잘게 썬 다음 물을 세 배 정도 넣고 달여 천에 싸서 찌꺼기를 짜 버리고, 그 물을 다시 끓여 엿처럼 되면 화상 부위에 바른다. \n□ 상처 치료 - 말린 가지 3~4개에 감초가루 1차 숟가락을 넣고 여기에 적당량의 물을 붓고 그 물이 반이 될 때까 지 달여 필요할 때 반 컵쯤 복용한다."    //prvateTherpy
    var stle: String = "□ 키 60~100cm, 잎은 호생, 엽병이 길고 타원형, 길이 15~35cm. 꽃은 자주색, 술잔 모양의 화관은 끝 이 5개로 갈라진다. 1개의 화경중 밑에 있는 것이 성숙하여 흑자색의 열매를 맺는다. \n□ 개화기 : 6~9월 \n□ 재배환경 : 토양적응성이 큼. 건조에 약하고 다소 습한 곳에서 잘 자람. \n□ 수확·건조 : 과실은 여름과 가을에 성숙하면 채취하고, 뿌리는 9~10월에 전초가 마른 후 뽑아서 햇볕에 말린다."       //stle
    var useRegn: String = "가지의 꽃받침"    //useeRegn
}




class getDetail: ObservableObject {
    
    @Published var herbData = herbDetail()

    init(id:String) {
        DispatchQueue.main.async {
            self.getDtlHerb(cntntsNo: id)
        }
    }
    

    func makeDURL(url:String, params1:[String: Any]) -> URL {
        let urlParams1 = params1.compactMap({ (key, value) -> String in
         return "\(key)=\(value)"
        }).joined(separator: "&")
        
        let withURL = url + "?\(urlParams1)"
        let encoded = withURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! + "&apiKey=" + key
        
//        print(encoded)
        
        return URL(string: encoded)! //?? URL(string: HerbListURL)!
    }


    func getDtlHerb(cntntsNo: String) {
        
        print("getDtlHerb Started")

        let url = makeDURL(url: HerbDetailURL, params1: ["cntntsNo": cntntsNo])

        AF.request(url, method: .get).validate()
        .responseString { response in
            
            print(" - API url: \(String(describing: response.request!))")

            //if case success
            switch response.result {
                
            case .success:
                if let string = response.value {
                    let xml = try! XML.parse(String(string))
                    
                    let element = xml.response.body.item
                    
                    if let bneNm = element.bneNm.text,
                        let cntntsNo = element.cntntsNo.text,
                        let cntntsSj = element.cntntsSj.text,
                        let hbdcNm = element.hbdcNm.text,
                        let imgUrl1 = element.imgUrl1.text,
                        let imgUrl2 = element.imgUrl2.text,
                        let imgUrl3 = element.imgUrl3.text,
                        let imgUrl4 = element.imgUrl4.text,
                        let imgUrl5 = element.imgUrl5.text,
                        let imgUrl6 = element.imgUrl6.text,
                        let therapy = element.prvateTherpy.text,
                        let stle = element.stle.text,
                        let useRegn = element.useeRegn.text
                    {
                        DispatchQueue.main.async {
                            self.herbData.id = cntntsNo
                            self.herbData.sciName = bneNm
                            self.herbData.korName = cntntsSj
                            self.herbData.chnName = hbdcNm
                            self.herbData.ImgUrl1 = imgUrl1
                            self.herbData.ImgUrl2 = imgUrl2
                            self.herbData.ImgUrl3 = imgUrl3
                            self.herbData.ImgUrl4 = imgUrl4
                            self.herbData.ImgUrl5 = imgUrl5
                            self.herbData.ImgUrl6 = imgUrl6
                            self.herbData.therapy = therapy.replacingOccurrences(of: "<br />", with: "\n")
                            self.herbData.stle = stle.replacingOccurrences(of: "<br />", with: "\n")
                            self.herbData.useRegn = useRegn
                        }
                        }
                    }
            case .failure(_):
                print("url failure")
            }
        }
    }
    
    func refresh(id: String) {
        getDtlHerb(cntntsNo: id)
    }

}
