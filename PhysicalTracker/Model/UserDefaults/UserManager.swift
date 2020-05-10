//
//  UserManager.swift
//  PhysicalTracker
//
//  Created by Christophe DURAND on 16/01/2020.
//  Copyright © 2020 Christophe DURAND. All rights reserved.
//

import Foundation

class UserManager {
    //MARK: - Properties
    //Singleton
    static let shared = UserManager()
    var usersArray = [User]()
    var currentUser = User(userId: "", userName: "", ricciResult: 0, birthyear: 0, height: 1, weight: 0, sex: 0, status: "", domain: "", descriptions: "", resultDictionary: ["":0])
    
    //MARK: - Private init Singleton
    private init() {}
    
    //MARK: - Methods
    // Users helpers methods
    func findIndexInUsersArray(user: User) -> Int{
        if usersArray.count > 0 {
            for i in 0...usersArray.count - 1 {
                if usersArray[i].userName == user.userName {
                    return i
                }
            }
        }
        
        return -1
    }
    
    func getUsersArray() {
        let decoded  = UserDefaults.standard.data(forKey: "usersArray")
        
        if decoded != nil {
            usersArray = NSKeyedUnarchiver.unarchiveObject(with: decoded!) as! [User]
        }
    }
    
    func setUsersArray(users: [User]) {
        let userDefaults = UserDefaults.standard
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: users)
        
        userDefaults.set(encodedData, forKey: "usersArray")
    }
    
    
    // CurrentUser helpers methods
    func getCurrentUser() -> Bool {
        let decoded  = UserDefaults.standard.data(forKey: "actualUser")
        
        if decoded != nil {
            currentUser = NSKeyedUnarchiver.unarchiveObject(with: decoded!) as! User
        }
        
        return decoded != nil
    }
    
    func setCurrentUsersArray() {
        let userDefaults = UserDefaults.standard
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: usersArray)
        
        userDefaults.set(encodedData, forKey: "usersArray")
    }
    
    func setCurrentUser(index: Int) {
        getUsersArray()
        
        currentUser = usersArray[index]
        
        updateCurrentUser()
        print("setCurrentUser from userDefault's userArray, userRicci = " + String(currentUser.ricciResult))
    }
    
    func updateCurrentUser() {
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: currentUser)
        
        UserDefaults.standard.set(encodedData, forKey: "actualUser")
        print("updateCurrentUser to userDefault, userRicci = " + String(currentUser.ricciResult))
    }
    
    func updateResultToCurrentUser(exerciseKey: String, result:Int) {
        currentUser.resultDictionary.updateValue(result, forKey: exerciseKey)
        print("update result to currentUser " + exerciseKey + String(result))
    }
    
    func getCurrentUserExerciseResultByKey(exerciseKey: String) -> Int{
        return currentUser.resultDictionary[exerciseKey] as! Int
    }
    
    func removeCurrentUser(index: Int) {
        let user = usersArray[index]
        
        if currentUser.isUserEqual(user: user) {
            UserDefaults.standard.removeObject(forKey: "actualUser")
        }
    }
    
    func updateModifiedUserInUsersArray(){
        for i in 0...usersArray.count-1 {
            if usersArray[i].isUserEqual(user: currentUser){
                usersArray[i] = currentUser
            }
        }
        setUsersArray(users: usersArray)
    }
    
    func updateCertaindUserInUsersArray(user: User){
        for i in 0...usersArray.count-1 {
            if usersArray[i].isUserEqual(user: user){
                usersArray[i] = user
            }
        }
        setUsersArray(users: usersArray)
    }
    
    // Results helpers methods
    func getCurrentResult(exerciseKey: String) -> Int {
        return currentUser.resultDictionary[exerciseKey] as! Int
    }
    
    func saveRicciSurveyResult(){
        getUsersArray()
        
        for user in usersArray {
            if user.userName == currentUser.userName {
                user.ricciResult = currentUser.ricciResult
            }
        }
        
        setUsersArray(users: usersArray)
    }
    
}
