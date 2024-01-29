//
//  FoodMoaya.swift
//  FoodDictionary
//
//  Created by Jooeun Kim on 2024/01/05.
//

import Foundation
import Moya

public enum FoodMoaya {
  // 1
  case food
}

extension FoodMoaya: TargetType {
    // 1
    public var baseURL: URL {
      return URL(string: "http://openapi.foodsafetykorea.go.kr/api/b2d5bbd6c8384296b0bd/COOKRCP01/json/0/100/")!
    }

    // 2
    public var path: String {
      switch self {
      case .food: return ""
      }
    }

    // 3
    public var method: Moya.Method {
      switch self {
      case .food: return .get
      }
    }

    // 4
    public var sampleData: Data {
      return Data()
    }

    // 5
    public var task: Task {
      return .requestPlain // TODO
    }

    // 6
    public var headers: [String: String]? {
      return ["Content-Type": "application/json"]
    }

    // 7
    public var validationType: ValidationType {
      return .successCodes
    }
  }
