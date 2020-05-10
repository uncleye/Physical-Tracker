//
//  DatabaseService.swift
//  PhysicalTracker
//
//  Created by Christophe DURAND on 11/02/2020.
//  Copyright © 2020 Christophe DURAND. All rights reserved.
//

import Foundation

class DatabaseService {
    //MARK: - Properties
    var task: URLSessionDataTask?
    private var databaseSession: URLSession
    
    //MARK: - Initializers
    init(databaseSession: URLSession = URLSession(configuration: .default)) {
        self.databaseSession = databaseSession
    }
    
    //MARK: - Methods
    private func setupBaseURL() -> String {
        let baseUrlString = "https://manager.itsquizz.com/quiz/pilot?"
        
        return baseUrlString
    }
    
    private func getQuery(idQuiz: String) -> String {
        let query = "service=getElement&directory=generated&pageIndex=1&idQuiz=" + idQuiz
        
        return query
    }
    
    private func createPostRequest(idQuiz: String, parameters: [String:String]) -> URLRequest {
        var request = URLRequest(url: URL(string: setupBaseURL() + getQuery(idQuiz: idQuiz))!)
        request.httpMethod = "POST"
        
        let body = getPostDataString(parameters: parameters)
        request.httpBody = body.data(using: .utf8)
        
        return request
    }
    
    private func getPostDataString(parameters: [String:String]) -> String {
        var dataString = ""
        
        for (key, value) in parameters {
            dataString += "&"
            dataString += key
            dataString += "="
            dataString += value
        }
        
        print(dataString)
    
        return dataString
    }
    
    private func getMatchingValueFrom(responseDataXML: String, tag: String) -> String {
        let pattern : String = "<"+tag+">(.*?)</"+tag+">"
        let regexOptions = NSRegularExpression.Options.caseInsensitive

        do {
            let regex = try NSRegularExpression(pattern: pattern, options: regexOptions)
            let textCheckingResult : NSTextCheckingResult = regex.firstMatch(in: responseDataXML, options: NSRegularExpression.MatchingOptions(rawValue: UInt(0)), range: NSMakeRange(0, responseDataXML.count))!
            let matchRange : NSRange = textCheckingResult.range(at: 1)
            let match : String = (responseDataXML as NSString).substring(with: matchRange)
            return match
        } catch {
            print(pattern + "<-- not found in string -->" + responseDataXML )
            return ""
        }
    }
    
    func postData(isCreatingProfile: Bool, idQuiz: String, parameters: [String: String], callback: @escaping (Bool) -> Void) {
        let request = createPostRequest(idQuiz: idQuiz, parameters: parameters)
        var id = "1"
        
        task?.cancel()
        
        task = databaseSession.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data else {
                    print("No data!")
                    callback(false)
                    return
                }
    
                guard error == nil else {
                    print(error?.localizedDescription ?? "Error")
                    callback(false)
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    print("Status code != 200")
                    callback(false)
                    return
                }
                                
                guard let responseDataString = String(data: data, encoding: .utf8) else {
                    print("No responseDataString!")
                    callback(false)
                    return
                }
                
                print(responseDataString)
                callback(true)
                
                if (isCreatingProfile) {
                    id = self.getMatchingValueFrom(responseDataXML: responseDataString, tag: Constants.Labels.random)
                    print("UserID = " + id)
                    
                    UserManager.shared.currentUser.userId = id
                    
                    UserManager.shared.updateCurrentUser()
                    
                    UserManager.shared.getUsersArray()
                    
                    UserManager.shared.usersArray[UserManager.shared.usersArray.count-1] = UserManager.shared.currentUser
                    
                    UserManager.shared.setCurrentUsersArray()
                }
            }
        }
        
        task?.resume()
    }
    
}
