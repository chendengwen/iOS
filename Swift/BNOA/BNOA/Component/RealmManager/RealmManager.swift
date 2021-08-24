//
//  RealmManager.swift
//  BNOA
//
//  Created by Cary on 2019/11/12.
//  Copyright © 2019 BNIC. All rights reserved.
//

import Foundation
import RealmSwift

//:Mark 数据迁移还未配置
open class RealmManager {
    
    static let sharedInstance = RealmManager()
    var realm:Realm?
    
    private init() {
        
        let dbVersionKey:String = "dbVersionKey"
        let dbVersion = UInt64(UserDefaults.standard.integer(forKey: dbVersionKey) + 1)
        let dbDirectory = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as String
        let dbPath = dbDirectory.appending("/defaultDB.realm")
        
        let config = Realm.Configuration.init(fileURL: URL.init(string: dbPath), inMemoryIdentifier: nil, syncConfiguration: nil, encryptionKey: nil, readOnly: false, schemaVersion: dbVersion, migrationBlock: { (migration, oldSchemaVersion) in
            
        }, deleteRealmIfMigrationNeeded: false, shouldCompactOnLaunch: nil, objectTypes: nil)
        Realm.Configuration.defaultConfiguration = config
        
        realm = try! Realm(configuration: config)
    }
    
    func add(_ object:Object) {
        try! realm?.write {
            realm?.add(object)
        }
    }
    
    func delete(_ object:Object) {
        try! realm?.write {
            realm?.delete(object)
        }
    }
    
    func update(_ block:(_ realm:Realm)->Void) {
        try! realm?.write {
            block(realm!)
        }
    }
    
    func objects<T:Object>(_ type:T.Type) -> Results<T> {
        return realm!.objects(T.self)
    }
}
