//
//  RxModel.swift
//  Rxswift_test
//
//  Created by 陈登文 on 2021/9/1.
//

import Foundation
import UIKit
import RxDataSources
import RxSwift

struct DataModel {

    let name: String
    let gitHubID: String
    var image: UIImage?
    
    init(name: String, gitHubID: String) {
        self.name = name
        self.gitHubID = gitHubID
        image = UIImage(named: gitHubID)
    }
}

extension DataModel: IdentifiableType{
    typealias Identity = String
    var identity:Identity {return gitHubID}
}


let githubData = Observable.just([
    SectionModel(model: "UI事件", items: [
        DataModel(name: "Login登录", gitHubID: "UI-login")
    ]),
    SectionModel(model: "网络请求", items: [
        DataModel(name: "Alamofire", gitHubID: "NET-alamofire")
    ]),
    SectionModel(model: "C", items: [
        DataModel(name: "Carlos García", gitHubID: "carlosypunto"),
        DataModel(name: "Cezary Kopacz", gitHubID: "CezaryKopacz"),
        DataModel(name: "Chris Jimenez", gitHubID: "PiXeL16"),
        DataModel(name: "Christian Tietze", gitHubID: "DivineDominion"),
    ]),
    SectionModel(model: "D", items: [
        DataModel(name: "だいちろ", gitHubID: "mokumoku"),
        DataModel(name: "David Alejandro", gitHubID: "davidlondono"),
        DataModel(name: "David Paschich", gitHubID: "dpassage"),
    ]),
    SectionModel(model: "E", items: [
        DataModel(name: "Esteban Torres", gitHubID: "esttorhe"),
        DataModel(name: "Evgeny Aleksandrov", gitHubID: "ealeksandrov"),
    ]),
    SectionModel(model: "F", items: [
        DataModel(name: "Florent Pillet", gitHubID: "fpillet"),
        DataModel(name: "Francis Chong", gitHubID: "siuying"),
    ]),
    SectionModel(model: "G", items: [
        DataModel(name: "Giorgos Tsiapaliokas", gitHubID: "terietor"),
        DataModel(name: "Guy Kahlon", gitHubID: "GuyKahlon"),
        DataModel(name: "Gwendal Roué", gitHubID: "groue"),
    ]),
    SectionModel(model: "H", items: [
        DataModel(name: "Hiroshi Kimura", gitHubID: "muukii"),
    ]),
    SectionModel(model: "I", items: [
        DataModel(name: "Ivan Bruel", gitHubID: "ivanbruel"),
    ]),
    SectionModel(model: "J", items: [
        DataModel(name: "Jeon Suyeol", gitHubID: "devxoul"),
        DataModel(name: "Jérôme Alves", gitHubID: "jegnux"),
        DataModel(name: "Jesse Farless", gitHubID: "solidcell"),
        DataModel(name: "Junior B.", gitHubID: "bontoJR"),
        DataModel(name: "Justin Swart", gitHubID: "justinswart"),
    ]),
    SectionModel(model: "K", items: [
        DataModel(name: "Karlo", gitHubID: "floskel"),
        DataModel(name: "Krunoslav Zaher", gitHubID: "kzaher"),
    ]),
    SectionModel(model: "L", items: [
        DataModel(name: "Laurin Brandner", gitHubID: "lbrndnr"),
        DataModel(name: "Lee Sun-Hyoup", gitHubID: "kciter"),
        DataModel(name: "Leo Picado", gitHubID: "leopic"),
        DataModel(name: "Libor Huspenina", gitHubID: "libec"),
        DataModel(name: "Lukas Lipka", gitHubID: "lipka"),
        DataModel(name: "Łukasz Mróz", gitHubID: "sunshinejr"),
    ]),
    SectionModel(model: "M", items: [
        DataModel(name: "Marin Todorov", gitHubID: "icanzilb"),
        DataModel(name: "Maurício Hanika", gitHubID: "mAu888"),
        DataModel(name: "Maximilian Alexander", gitHubID: "mbalex99"),
    ])
])


