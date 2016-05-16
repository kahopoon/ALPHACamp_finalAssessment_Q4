//
//  APICall.swift
//  ALPHACamp_finalAssessment_Q4
//
//  Created by Ka Ho on 16/5/2016.
//  Copyright © 2016 Ka Ho. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

let callURL:String = "http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=55ec6d6e-dc5c-4268-a725-d04cc262172b"

func metroDataAPICall(completion: (result: JSON) -> Void) {
    Alamofire.request(.GET, callURL).responseJSON { (response) in
        completion(result: JSON(response.result.value!))
    }
}