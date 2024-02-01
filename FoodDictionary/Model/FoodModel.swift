//
//  FoodModel.swift
//  FoodDictionary
//
//  Created by Jooeun Kim on 2024/01/05.
//

import Foundation
import UIKit

struct FoodModel: Decodable {
    var COOKRCP01: FoodInfos
}

struct FoodInfos : Decodable {
    let total_count: String
    let row: [OriginFood]
}

struct Food {
    let RCP_NM: String            // 메뉴명(name)
    let RCP_SEQ: String             // 일련 번호
    var RCP_SAVE: Bool
    let RCP_PARTS_DTLS: String?    // 재료 정보
    let RCP_PAT2: String?          // 요리 종류
    let INFO_WGT: String?          // 중량(1인분)
    let ATT_FILE_NO_MAIN: String?  // 이미지 경로 (소)
    let ATT_FILE_NO_MK: String?    // 이미지 경로 (대)
    let RCP_NA_TIP: String?         // 저감 조라법 TIP
    let RCP_STEP: [Recipe]          // 만드는법
}


struct Recipe {
    let MANUAL: String
    let MANUAL_IMG: String
}

struct OriginFood: Decodable {
    let RCP_NM: String            // 메뉴명(name)
    let RCP_SEQ: String             // 일련 번호
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
    let MANUAL_IMG01: String?
    let MANUAL_IMG02: String?
    let MANUAL_IMG03: String?
    let MANUAL_IMG04: String?
    let MANUAL_IMG05: String?
    let MANUAL_IMG06: String?
    let MANUAL_IMG07: String?
    let MANUAL_IMG08: String?
    let MANUAL_IMG09: String?
}

