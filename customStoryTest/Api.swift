//
//  Api.swift
//  CustomStory
//
//  Created by MD SAZID HASAN DIP on 21/6/21.
//

import Foundation
import Alamofire


let domain = "https://classchatapi.thebitlabs.com"

let header = "bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJyeGMxMjYzNkBlb29weS5jb20iLCJqdGkiOiJjYzNhZjM0ZC02MWU5LTQ3NzYtYWM1Yi0zYmE1Yzg1MTc2ZDQiLCJlbWFpbCI6InJ4YzEyNjM2QGVvb3B5LmNvbSIsInVuaXF1ZV9uYW1lIjoicmFtb3MiLCJnaXZlbl9uYW1lIjoiU2VyZ2lvIFJhbW9zIiwiVXNlcklkIjoiZTI0Y2M2NGEtMTJiMy00MTM3LTliOGItNGU2NjU5OWVhNmQyIiwiVXNlck5hbWUiOiJyYW1vcyIsIkRldmljZUlkIjoiaW9zIiwiSWRlbnRpZmllciI6ImRmNzdjMGYwNDU3NjQ0YjBhZGIxODExMWFjZTA1NDc2IiwiSW5zdGl0dXRlSWQiOiI1ZTZlNTYzNTJkYjM4YzQwNTRlZTI5YjMiLCJJbnN0aXR1dGVOYW1lIjoiQW1lcmljYW4gSW50ZXJuYXRpb25hbCBVbml2ZXJzaXR5LUJhbmdsYWRlc2giLCJEZXZpY2VUeXBlIjoiaW9zIiwiUHVibGljSVAiOiIxOTEuOTYuMTA5LjE5NyIsIm5iZiI6MTYyNDI1ODI2NiwiZXhwIjoxNjMyMDM0MjY2LCJpYXQiOjE2MjQyNTgyNjYsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0OjUwMDEvIiwiYXVkIjoiaHR0cHM6Ly9sb2NhbGhvc3Q6NTAwMS8ifQ.joLoICJl_EgT2GYQPhfOafjgo2YvpEkFka3PC1JRwMk"
   
import ObjectMapper
enum ErrorCode {
    case timedOut
    case loginFailed
    case unAuthorized
    //    case badRequest
    case noInternet
    case unknown
}


class APIError:Mappable {
    var code:ErrorCode?
    var message:String?
    
    init(code:ErrorCode,message:String) {
        self.code = code
        self.message = message
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        code <- map["code"]
        message <- map["description"]
    }
    
}

class Api {
    
    static var shared:Api = {
        return Api()
    }()
    let getStories = domain+"/api/v1/Story/GetStories"
    
 
    var headers = ["Authorization": header]
    
    func getAPIError(fromError error:Error) -> APIError {
        let err:APIError?
        switch (error._code){
            case NSURLErrorTimedOut:
                err = APIError(code: .timedOut, message: "Server Timed out.")
                break
            case NSURLErrorNotConnectedToInternet:
                err = APIError(code: .noInternet, message: "Internet connection not available.")
                break
            default:
                err = APIError(code: .unknown, message: error.localizedDescription)
                break
        }
        return err!
    }
    
    
    func apiError(withStatusCode statusCode:Int, andMessage message:String?) -> APIError {
        switch statusCode {
            //        case 400:
            //            return APIError(code: .badRequest, message: message ?? "Unauthorized access!")
            case 401:
                return APIError(code: .unAuthorized, message: message ?? "Unauthorized access!")
            default:
                return APIError(code: .unknown, message: message ?? "Unknown reason.")
        }
    }
    
    
    func getStories(withPageNo page:Int, pageSize:Int, completion:@escaping (Bool, APIError?, IGStories?) -> ()){
        let URL = getStories
        let parameters = ["page":page, "pageSize":pageSize]
        Alamofire.request(URL, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseData(completionHandler: { (response) in
            switch response.result {
                case .failure(let error):
                    completion(false, self.getAPIError(fromError: error), nil)
                case .success(let data):
                    do {
                        let stories = try JSONDecoder().decode(IGStories.self, from: data)
                        completion(true, nil, stories)
                    } catch {
                        completion(false, self.apiError(withStatusCode: (response.response?.statusCode)!, andMessage: "data error!"), nil)
                    }
            }
        })
    }
}

