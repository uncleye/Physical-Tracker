//
//  ResultsManager.swift
//  PhysicalTracker
//
//  Created by Christophe DURAND on 20/01/2020.
//  Copyright © 2020 Christophe DURAND. All rights reserved.
//

import UIKit

class ResultsManager {
    //MARK: - Properties
    //Singleton
    static let shared = ResultsManager()
    
    //MARK: - Private init Singleton
    private init() { }
    
    //MARK: - Methods
    func positionValueInTable(table: [String], value: Int) -> Int{
        for i in 0...table.count - 1 {
            if (value<Int(table[i]) ?? 0) {
                return i
            }
        }
        
        return table.count
    }
    
    func evaluationExercise(exerciseKey: String) -> Int {
        let ageScale = NSLocalizedString(exerciseKey + Constants.RessourcesStrings.gradingScaleAge, comment: "").split(separator: "|").map(String.init)
        let femaleScaleOneDimension = NSLocalizedString(exerciseKey + Constants.RessourcesStrings.gradingScaleFemale, comment: "").split(separator: "|").map(String.init)
        let maleScaleOneDimension = NSLocalizedString(exerciseKey + Constants.RessourcesStrings.gradingScaleMale, comment: "").split(separator: "|").map(String.init)
        var femaleScale = [[String]]()
        var maleScale = [[String]]()
        let result = UserManager.shared.getCurrentUserExerciseResultByKey(exerciseKey: exerciseKey)
        let userAge = Calendar.current.component(.year, from: Date())-UserManager.shared.currentUser.birthyear
        let indiceOfIntervalOfAge = positionValueInTable(table: ageScale, value: userAge)
        let userSex = UserManager.shared.currentUser.sex
        
        for i in 0...ageScale.count - 1 {
            femaleScale.append(femaleScaleOneDimension[i].split(separator: ",").map(String.init))
            maleScale.append(maleScaleOneDimension[i].split(separator: ",").map(String.init))
        }
    
        if userSex == 0 {
            if exerciseKey == Constants.RessourcesStrings.step {
                return femaleScale[indiceOfIntervalOfAge].count - positionValueInTable(table: femaleScale[indiceOfIntervalOfAge], value: result)
            }
            
            return positionValueInTable(table: femaleScale[indiceOfIntervalOfAge], value: result)
        } else {
            if exerciseKey == Constants.RessourcesStrings.step {
                return maleScale[indiceOfIntervalOfAge].count - positionValueInTable(table: maleScale[indiceOfIntervalOfAge], value: result)
            }
            
            return positionValueInTable(table: maleScale[indiceOfIntervalOfAge], value: result)
        }
    }
    
    func isExistTheResult(exerciseKey: String) -> Bool {
        return UserManager.shared.currentUser.resultDictionary[exerciseKey] != nil
    }
    
    func numberOfRowIncategory(categoryNumber: Int) -> Int {
        let categories = NSLocalizedString(Constants.RessourcesStrings.categoriesKeys, comment: "").split(separator: "|").map(String.init)
        let categoryKey = categories[categoryNumber+1]
        let exerciseKey = NSLocalizedString(categoryKey + Constants.RessourcesStrings.exercisesKeys, comment: "").split(separator: "|").map(String.init)
        var count = 0
        
        for key in exerciseKey {
            if isExistTheResult(exerciseKey:key) {
                count = count + 1
            }
        }
        
        return count
    }
    
    func setResultKeyList(categoryNumber: Int) -> [String] {
        var resultList = [String]()
        let categories = NSLocalizedString(Constants.RessourcesStrings.categoriesKeys, comment: "").split(separator: "|").map(String.init)
        let categoryKey = categories[categoryNumber+1]
        let exerciseKey = NSLocalizedString(categoryKey + Constants.RessourcesStrings.exercisesKeys, comment: "").split(separator: "|").map(String.init)
        
        for key in exerciseKey {
            if isExistTheResult(exerciseKey:key) {
                resultList.append(key)
            }
        }
        
        return resultList
    }
    
    func setResultExerciseList(categoryNumber: Int)-> [String] {
        let resultList = setResultKeyList(categoryNumber: categoryNumber)
        var resultExerciseList = [String]()
        
        for result in resultList {
            resultExerciseList.append(NSLocalizedString(result + Constants.RessourcesStrings.title, comment: ""))
        }
        
        return resultExerciseList
    }
    
    func setResultNumberList(categoryNumber: Int)-> [String] {
        let resultList = setResultKeyList(categoryNumber: categoryNumber)
        var resultExerciseList = [String]()
        
        for result in resultList{
            resultExerciseList.append(UserManager.shared.currentUser.resultDictionary[result] as! String)
        }
        
        return resultExerciseList
    }
    
    func calculationBMI() -> Float {
        let weight = Float(UserManager.shared.currentUser.weight)
        let height = Float(UserManager.shared.currentUser.height)
        var bmi = (weight/(height*height))*10000
        
        bmi = roundBMIResult(BMI: bmi)
        
        return Float(bmi)
    }
    
    func roundBMIResult(BMI: Float) -> Float {
        return Float(round(10*BMI)/10)
    }

    func evaluationBMI() -> Int {
        let BMIStandard = NSLocalizedString(Constants.RessourcesStrings.bmiGradingScale, comment: "").split(separator: "|").map(String.init)
        let BMIValue = calculationBMI()
        
        for i in 0...BMIStandard.count - 1 {
            if (BMIValue<Float(BMIStandard[i]) ?? 0) {
                return BMIStandard.count - i
            }
        }
        
        return 0
    }
    
    func evaluationRicci() -> Int {
        let ricciStandard = NSLocalizedString(Constants.RessourcesStrings.ricciGradingScale, comment: "").split(separator: "|").map(String.init)
        let ricciResult = UserManager.shared.currentUser.ricciResult
        let evaluationRicci = positionValueInTable(table: ricciStandard, value: ricciResult)
        
        return evaluationRicci
    }
    
    func numberOfSectionsInResult() -> Int {
        return NSLocalizedString(Constants.RessourcesStrings.categoriesTitles, comment: "").split(separator: "|").map(String.init).count - 1
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        if cString.count != 6 {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}
