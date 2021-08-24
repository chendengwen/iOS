//
//  Unit_Test.swift
//  Unit_Test
//
//  Created by mac on 2019/8/6.
//  Copyright © 2019 Gary. All rights reserved.
//

import XCTest
@testable import 健康管理H5

class Unit_Test: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let decodeString = "https://wx.tenpay.com/cgi-bin/mmpayweb-bin/checkmweb?prepay_id=wx061108075783481bf9673bd01380036200&package=1019423356&redirect_url=http%3A%2F%2Ftestkmjkzx.kmwlyy.com%2Fweb%2Fzszg%2Findex.html%23%2Fpaycallback%3Fid%3D73b7f693d5ff4cd7897bdc5caf189ff5%26price%3D0.02".removingPercentEncoding
        let urlArr:[String] = decodeString!.components(separatedBy: "&redirect_url=")
        let mallOriginUrl = urlArr[1]
        let mallLegalUrl = mallOriginUrl.pregReplace(pattern: "#/paycallback", with: "")
        let components = URLComponents(url: URL.init(string: mallLegalUrl)!, resolvingAgainstBaseURL: true)
        
        let resultUrl = urlArr[0] + (components?.query)!
        
        print(resultUrl)
    }
    
    func testExString() {
        let ip = "192.9.9.1:8080?ww=3".containsIP()
        assert(ip, "不包含IP")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
