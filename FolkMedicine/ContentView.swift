//
//  ContentView.swift
//  FolkMedicine
//
//  Created by Minho Choi on 2020/04/16.
//  Copyright © 2020 Minho Choi. All rights reserved.
//

import SwiftUI
import Alamofire
import SwiftyXMLParser

let HerbListURL = "http://api.nongsaro.go.kr/service/prvateTherpy/prvateTherpyList"
let key = "20200325ZMJFEIMYLK63G1W5CRBSWQ"
var listRows = 178

struct ContentView: View {
    
    @ObservedObject var newHerbList = HerbList()
    @State private var search: String = ""
    let searchType = ["명칭", "학명", "생약명"]
    //명칭 - sCntntsSj, 학명 - sBneNm, 생약명 - sHbdcNm
    @State private var selectedSearchType = 0
    @State var selectedSTStr = ""

    var body: some View {
        
        NavigationView {
            VStack {
                HStack {
                    
                    Picker(selection: $selectedSearchType, label: Text("")) {
                        ForEach(0..<searchType.count) {
                            Text(self.searchType[$0])
                        }
                    }.frame(width: 140)
                        .pickerStyle(SegmentedPickerStyle())
                    
                    TextField("검색어 입력", text: $search)
                    
                    Button(action: {
                        switch self.selectedSearchType {
                        case 0 : self.selectedSTStr = "sCntntsSj"
                        case 1 : self.selectedSTStr = "sBneNm"
                        case 2 : self.selectedSTStr = "sHbdcNm"
                        default:
                            self.selectedSTStr = "sCntntsSj"
                        }
                        
                        self.newHerbList.getSearchHerb(sType: self.selectedSTStr, sText: self.search, numOfRows: listRows)
                        
                    }) {
                        Image(systemName: "magnifyingglass.circle")
                            .scaleEffect(1.5)
                    }
                    
                }.padding()
                
                List {
                    ForEach(newHerbList.herbList) { item in
                        
                        NavigationLink(destination: HerbDetailView(id: "\(item.id)")) {
                            HerbRow(item: item)
                        }
                    }
                }
            }.navigationBarTitle(Text("약초 검색"))
        }
    }
}




struct herbItem : Codable, Identifiable {
    var id: String = "000000"
    var sciName: String = ""
    var korName: String = "Loading..."
    var chnName: String = ""
    var thumbImgUrl: String = "1"
    var ImgUrl: String = "2"
}




func makeSURL(url:String, params1:[String: Any], params2: [String: Any], params3: [String: Any]) -> URL {
    let urlParams1 = params1.compactMap({ (key, value) -> String in
     return "\(key)=\(value)"
    }).joined(separator: "&")
    
    let urlParams2 = params2.compactMap({ (key, value) -> String in
     return "\(key)=\(value)"
    }).joined(separator: "&")
    
    let urlParams3 = params3.compactMap({ (key, value) -> String in
     return "\(key)=\(value)"
    }).joined(separator: "&")
    
    let withURL = url + "?\(urlParams1)" + "&\(urlParams2)" + "&\(urlParams3)"
    let encoded = withURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! + "&apiKey=" + key
    
    return URL(string: encoded)! //?? URL(string: HerbListURL)!
}




class HerbList: ObservableObject {
    
    @Published var herbList = [herbItem](repeating: herbItem.init(), count: listRows)
    
    init() {
        getSearchHerb(sType: "sCntntsSj", sText: "", numOfRows: listRows)
        //명칭 - sCntntsSj, 학명 - sBneNm, 생약명 - sHbdcNm
    }

    
    func getSearchHerb(sType: String, sText: String, numOfRows: Int) {
        
        self.herbList = [herbItem](repeating: herbItem.init(), count: listRows) // initialize
        
        let url = makeSURL(url: HerbListURL, params1: ["sType": sType], params2: ["sText": sText], params3: ["numOfRows": numOfRows])
        
        AF.request(url, method: .get).validate()
        .responseString { response in
            
//            print(" - API url: \(String(describing: response.request!))")

            //if case success
            switch response.result {
                
            case .success:
                if let string = response.value {
                    let xml = try! XML.parse(String(string))
                    
                    var cnt = 0
                    for element in xml.response.body.items.item {
                        if let bneNm = element["bneNm"].text,
                            let cntntsNo = element["cntntsNo"].text,
                            let cntntsSj = element["cntntsSj"].text,
                            let hbdcNm = element["hbdcNm"].text,
                            let thumbImgUrl = element["thumbImgUrl"].text,
                            let imgUrl = element["imgUrl"].text {
                            
                            self.herbList[cnt].id = cntntsNo
                            self.herbList[cnt].sciName = bneNm
                            self.herbList[cnt].korName = cntntsSj
                            self.herbList[cnt].chnName = hbdcNm
                            self.herbList[cnt].thumbImgUrl = thumbImgUrl
                            self.herbList[cnt].ImgUrl = imgUrl
                            
                        }
                        cnt = cnt + 1;
                    }
//                    print(self.herbList)
            }
            case .failure(_):
                print("url failure")
            }
        }.resume()
        
        
    }
    
}

