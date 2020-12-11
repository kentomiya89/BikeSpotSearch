//
//  Migration.swift
//  BikeSpotSearch
//
//  Created by kentomiyabayashi on 2020/12/10.
//

import Foundation
import RealmSwift

struct Migration {

    func migration() {
        Realm.Configuration.defaultConfiguration = Realm.Configuration(
            schemaVersion: RealmDefine.sheamaVersion,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < RealmDefine.sheamaVersion {
                    migration.enumerateObjects(ofType: MyBikePark.className()) { (_, _) in

                    }
                }
            })
    }
}
