//
//  User.swift
//  PhysicalTracker
//
//  Created by Christophe DURAND on 14/01/2020.
//  Copyright © 2020 Christophe DURAND. All rights reserved.
//

import Foundation

class User: NSObject, NSCoding {
    //MARK: - Properties
    var userId: String
    var userName: String
    var domain: String
    var ricciResult: Int
    var birthyear: Int
    var height: Int
    var weight: Int
    var sex: Int
    var status: String
    var descriptions: String
    var resultDictionary: [String: Any] = [:]
    
    //MARK: - Init
    init(userId: String, userName: String, ricciResult: Int, birthyear: Int, height: Int, weight: Int, sex: Int, status: String, domain: String, descriptions: String, resultDictionary: [String: Any]) {
        self.userId = userId
        self.userName = userName
        self.domain = domain
        self.ricciResult = ricciResult
        self.birthyear = birthyear
        self.height = height
        self.weight = weight
        self.sex = sex
        self.status = status
        self.descriptions = descriptions
        self.resultDictionary = resultDictionary
    }
    
    required convenience init?(coder: NSCoder) {
        
        let userId = coder.decodeObject(forKey: Constants.Keys.userId) as! String
        let userName = coder.decodeObject(forKey: Constants.Keys.userName) as! String
        let ricciResult = coder.decodeInteger(forKey: Constants.Keys.ricciResult)
        let birthyear = coder.decodeInteger(forKey: Constants.Keys.birthyear)
        let height = coder.decodeInteger(forKey: Constants.Keys.height)
        let weight = coder.decodeInteger(forKey: Constants.Keys.weight)
        let sex = coder.decodeInteger(forKey: Constants.Keys.sex)
        let status = coder.decodeObject(forKey: Constants.Keys.status) as! String
        let domain = coder.decodeObject(forKey: Constants.Keys.domain) as! String
        let descriptions = coder.decodeObject(forKey: Constants.Keys.descriptions) as! String
        let resultDictionary = coder.decodeObject(forKey: Constants.Keys.resultDictionary) as! [String: Any]
        
        self.init(userId: userId, userName: userName, ricciResult: ricciResult, birthyear: birthyear, height: height, weight: weight, sex: sex, status: status, domain: domain, descriptions: descriptions, resultDictionary: resultDictionary)
    }
    
    //MARK: - Methods
    func encode(with coder: NSCoder) {
        coder.encode(userId, forKey: Constants.Keys.userId)
        coder.encode(userName, forKey: Constants.Keys.userName)
        coder.encode(domain, forKey: Constants.Keys.domain)
        coder.encode(ricciResult, forKey: Constants.Keys.ricciResult)
        coder.encode(birthyear, forKey: Constants.Keys.birthyear)
        coder.encode(height, forKey: Constants.Keys.height)
        coder.encode(weight, forKey: Constants.Keys.weight)
        coder.encode(sex, forKey: Constants.Keys.sex)
        coder.encode(status, forKey: Constants.Keys.status)
        coder.encode(descriptions, forKey: Constants.Keys.descriptions)
        coder.encode(resultDictionary, forKey: Constants.Keys.resultDictionary)
    }
    
    func isUserEqual(user: User) -> Bool{
        if user.userId == userId {
            return true
        }
        
        return false
    }
    
    func toDictionary() -> [String:String] {
        var dictionary = [String:String]()
        
        dictionary[Constants.RessourcesStrings.inputDeviceType] = Constants.RessourcesStrings.iOS
        dictionary[Constants.RessourcesStrings.inputBirthyear] = String(birthyear)
        dictionary[Constants.RessourcesStrings.inputHeight] = String(height)
        dictionary[Constants.RessourcesStrings.inputWeight] = String(weight)
        
        switch status {
        case Constants.RessourcesStrings.student:
            dictionary[Constants.RessourcesStrings.inputStatus] = Constants.RessourcesStrings.studentStatus
            break
            
        case Constants.RessourcesStrings.employee:
            dictionary[Constants.RessourcesStrings.inputStatus] = Constants.RessourcesStrings.employeeStatus
            break
            
        case Constants.RessourcesStrings.other:
            dictionary[Constants.RessourcesStrings.inputStatus] = Constants.RessourcesStrings.otherStatus
            dictionary[Constants.RessourcesStrings.inputWhoAreYou] = descriptions
            break
            
        default:
            break
        }
        
        switch domain {
        case Constants.RessourcesStrings.societiesAndHumanities:
            dictionary[Constants.RessourcesStrings.inputDomainOfStudy] = Constants.RessourcesStrings.sohu
            break
            
        case Constants.RessourcesStrings.health:
            dictionary[Constants.RessourcesStrings.inputDomainOfStudy] = Constants.RessourcesStrings.sant
            break
            
        case Constants.RessourcesStrings.sciences:
            dictionary[Constants.RessourcesStrings.inputDomainOfStudy] = Constants.RessourcesStrings.scie
            break
            
        case Constants.RessourcesStrings.staps:
            dictionary[Constants.RessourcesStrings.inputDomainOfStudy] = Constants.RessourcesStrings.stap
            break
            
        default:
            break
        }
        
        switch sex {
        case 0:
            dictionary[Constants.RessourcesStrings.inputSex] = Constants.RessourcesStrings.woman
            break
            
        case 1:
            dictionary[Constants.RessourcesStrings.inputSex] = Constants.RessourcesStrings.man
            break
            
        default:
            break
        }
        
        print(dictionary)
        return dictionary
    }
    
}
