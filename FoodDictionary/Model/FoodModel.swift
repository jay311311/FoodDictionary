//
//  FoodModel.swift
//  FoodDictionary
//
//  Created by Jooeun Kim on 2024/01/05.
//

import Foundation

struct FoodModel: Decodable {
    var COOKRCP01: FoodInfos
}

struct FoodInfos : Decodable {
    let total_count: String
    let row: [Food]
}

struct Food: Decodable {
    let RCP_NM: String            // 메뉴명(name)
    let RCP_PARTS_DTLS: String?    // 재료 정보
    let RCP_WAY2: String?          // 조리 방법
    let RCP_PAT2: String?          // 요리 종류
    let HASH_TAG: String?          // 해쉬 태그
    let INFO_ENG: String?          // 열량
    let INFO_WGT: String?          // 중량(1인분)
    let ATT_FILE_NO_MAIN: String?  // 이미지 경로 (소)
    let ATT_FILE_NO_MK: String?    // 이미지 경로 (대)
    let RCP_NA_TIP:String?         // 저감 조라법 TIP
    let MANUAL01: String?          // 만드는법
    let MANUAL02: String?
    let MANUAL03: String?
    let MANUAL04: String?
    let MANUAL05: String?
    let MANUAL06: String?
    let MANUAL07: String?
    let MANUAL08: String?
    let MANUAL09: String?
    let MANUAL10: String?
    let MANUAL11: String?
    let MANUAL12: String?
    let MANUAL13: String?
    let MANUAL14: String?
    let MANUAL15: String?
    let MANUAL16: String?
    let MANUAL17: String?
    let MANUAL18: String?
    let MANUAL19: String?
}
