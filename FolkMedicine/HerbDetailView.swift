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
    @ObservedObject var detailData = getDetail(id: "205057")
    
    var body: some View {
        VStack {
            Button(action: {
                self.detailData.refresh(id: self.id)
                print(self.detailData.herbData)
            }) {
                Text("asdfasdfasdfas")
            }
            VStack {
                Text("\(detailData.herbData.id)")
                Text("\(detailData.herbData.korName)")
                Text("\(detailData.herbData.chnName)")
                Text("\(detailData.herbData.sciName)")
            }
        }
    }
}




struct herbDetail: Codable {
    
    var id: String = "000000"   //cntntsNo
    var sciName: String = ""    //bneNm
    var korName: String = ""    //cntntsSj
    var chnName: String = ""    //hbdcNm
    var ImgUrl1: String = "1"   //imgUrl1
    var ImgUrl2: String = "2"   //imgUrl2
    var ImgUrl3: String = "3"   //imgUrl3
    var ImgUrl4: String = "4"   //imgUrl4
    var ImgUrl5: String = "5"   //imgUrl5
    var ImgUrl6: String = "6"   //imgUrl6
    var therapy: String = ""    //prvateTherpy
    var stle: String = ""       //stle
    var useRegn: String = ""    //useeRegn
}


class getDetail: ObservableObject {
    
    @Published var herbData = herbDetail()

    init(id:String) {
        getDtlHerb(cntntsNo: id)
    }
    

    func makeDURL(url:String, params1:[String: Any]) -> URL {
        let urlParams1 = params1.compactMap({ (key, value) -> String in
         return "\(key)=\(value)"
        }).joined(separator: "&")
        
        let withURL = url + "?\(urlParams1)"
        let encoded = withURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! + "&apiKey=" + key
        
        print(encoded)
        
        return URL(string: encoded)! //?? URL(string: HerbListURL)!
    }


    func getDtlHerb(cntntsNo: String) {

        let url = makeDURL(url: HerbDetailURL, params1: ["cntntsNo": cntntsNo])

        AF.request(url, method: .get).validate()
        .responseString { response in
            
    //        print(" - API url: \(String(describing: response.request!))")

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
                            self.herbData.therapy = therapy
                            self.herbData.stle = stle
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
