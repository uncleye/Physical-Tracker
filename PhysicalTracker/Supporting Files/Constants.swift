//
//  Constants.swift
//  PhysicalTracker
//
//  Created by Christophe DURAND on 07/01/2020.
//  Copyright © 2020 Christophe DURAND. All rights reserved.
//

import UIKit

struct Constants {
    struct HeadersIdentifiers {
        static let mainPageHeaderIdentifier = "mainPageHeaderIdentifier"
    }
    
    struct SeguesIdentifiers {
        static let createProfileSegue = "createProfileSegue"
        static let detailedProfileSegue = "detailedProfileSegue"
        static let circularTimerRingSegue = "circularTimerRingSegue"
        static let getReadySegue = "getReadySegue"
        static let instructionsSegue = "instructionsSegue"
        static let listOfProfilesSegue = "listOfProfilesSegue"
        static let mainPageSegue = "mainPageSegue"
        static let aboutUsSegue = "aboutUsSegue"
        static let referencesSegue = "referencesSegue"
        static let resultsSegue = "resultsSegue"
        static let ricciSurveySegue = "ricciSurveySegue"
        static let videoSegue = "videoSegue"
        static let timerSegue = "timerSegue"
        static let keepResultsSegue = "keepResultsSegue"
        static let goToKeepResultsDirectlySegue = "goToKeepResultsDirectlySegue"
        static let modifyProfileSegue = "modifyProfileSegue"
        static let interpretationSegue = "interpretationSegue"
        static let goToGetReadyDirectlySegue = "goToGetReadyDirectlySegue"
        static let checkResultsSegue = "checkResultsSegue"
        static let introductionSegue = "introductionSegue"
        static let fromMainPageToCreateProfileSegue = "fromMainPageToCreateProfileSegue"
        static let fromRicciSurveyToListOfProfilesSegue = "fromRicciSurveyToListOfProfilesSegue"
        static let fromGetReadyToListOfProfilesSegue = "fromGetReadyToListOfProfilesSegue"
    }
    
    struct StoryboardsIdentifiers {
        static let mainStoryboardIdentifier = "Main"
    }
    
    struct ViewControllersIdentifiers {
        static let introductionViewControllerIdentifier = "introductionVC"
        static let mainPageViewControllerIdentifier = "mainPageVC"
        static let instructionsViewControllerIdentifier = "instructionsVC"
        static let getReadyViewControllerIdentifier = "getReadyVC"
        static let interpretationsIdentifier = "interpretationsVC"
    }
        
    struct RessourcesStrings {
        static let answers = "answers_"
        static let background = "background_"
        static let categoriesKeys = "ex_category_keys"
        static let categoriesTitles = "ex_categories"
        static let exercises = "_exs"
        static let exercisesKeys = "_ex_keys"
        static let duration = "_duration"
        static let helperText = "_helper_text"
        static let instructions = "_instructions"
        static let ricciQuestions = "ricci_questions"
        static let ricciGagnon = "ricci_gagnon"
        static let studentCategories = "student_categories"
        static let grading = "_grading"
        static let gradingScaleAge = "_grading_scale_age"
        static let gradingScaleFemale = "_grading_scale_female"
        static let gradingScaleMale = "_grading_scale_male"
        static let title = "_title"
        static let timerBeep1 = "timer_beep"
        static let timerBeep2 = "timer_beep_2"
        static let video = "video_"
        static let chair = "chair"
        static let flamingo = "flamingo"
        static let handGrip = "hand_grip"
        static let shirado = "shirado"
        static let sorensen = "sorensen"
        static let sitStand = "sit_stand"
        static let sixWalk = "six_walk"
        static let step = "step"
        static let handGround = "hand_ground"
        static let shoulders = "shoulders"
        static let sitReach = "sit_reach"
        static let backgroundImageWithExtensionJPEG = ".jpg"
        static let videoWithExtensionMp4 = "mp4"
        static let audioWithExtensionMp3 = ".mp3"
        static let audioWithExtensionWav = ".wav"
        static let gradeScaleColor = "grade_scale_color"
        static let bmiGrading = "bmi_grading"
        static let bmiGradingAdvices = "bmi_grading_advices"
        static let bmiGradingScale = "bmi_grading_scale"
        static let ricciGrading = "ricci_grading"
        static let ricciGradingScale = "ricci_grading_scale"
        static let ricciGradingAdvices = "ricci_grading_advices"
        static let idQuiz532 = "532"
        static let idQuiz533 = "533"
        static let inputUserIdentifier = "input_userIdentifier"
        static let inputDate = "input_date"
        static let inputTest = "input_test"
        static let inputData1 = "input_data1"
        static let inputData2 = "input_data2"
        static let inputData3 = "input_data3"
        static let inputDeviceType = "input_deviceType"
        static let inputBirthyear = "input_birthyear"
        static let inputHeight = "input_height"
        static let inputWeight = "input_weight"
        static let inputSex = "input_sex"
        static let inputStatus = "input_status"
        static let inputWhoAreYou = "input_whoAreYou"
        static let inputDomainOfStudy = "input_domainOfStudy"
        static let sohu = "SOHU"
        static let sant = "SANT"
        static let scie = "SCIE"
        static let stap = "STAP"
        static let man = "1"
        static let woman = "2"
        static let iOS = "I"
        static let studentStatus = "E"
        static let employeeStatus = "P"
        static let otherStatus = "A"
        static let bmi = "BMI"
        static let status = "status"
        static let introVCisFirstLaunched = "introVCisFirstLaunched"
        static let launchedBefore = "launchedBefore"
        static let student = "Étudiant UP"
        static let employee = "Personnel UP"
        static let other = "Autre"
        static let societiesAndHumanities = "Sociétés et Humanités"
        static let health = "Santé"
        static let sciences = "Sciences"
        static let staps = "Staps"
    }
    
    struct Images {
        static let results = "results"
        static let profile = "profile"
        static let info = "info"
        static let timer = "timer"
        static let mainPage = "mainPage"
        static let checkmark = "checkmark"
    }

    struct Videos {
        static let videoChair = "video_chair"
        static let videoFlamingo = "video_flamingo"
        static let videoHandGrip = "video_hand_grip"
        static let videoHandGround = "video_hand_ground"
        static let videoInterview = "video_interview"
        static let videoShirado = "video_shirado"
        static let videoShoulders = "video_shoulders"
        static let videoSitReach = "video_sit_reach"
        static let videoSitStand = "video_sit_stand"
        static let videoSorensen = "video_sorensen"
        static let videoStep = "video_step"
    }
    
    struct Colors {
        static let redUIColor = UIColor(hex: 0x8B1538)
    }
    
    struct Fonts {
        static let rubikBlack = "Rubik-Black"
        static let rubikBlackItalic = "Rubik-BlackItalic"
        static let rubikBold = "Rubik-Bold"
        static let rubikBoldItalic = "Rubik-BoldItalic"
        static let rubikItalic = "Rubik-Italic"
        static let rubikLight = "Rubik-Light"
        static let rubikMedium = "Rubik-Medium"
        static let rubikMediumItalic = "Rubik-MediumItalic"
        static let rubikRegular = "Rubik-Regular"
    }
    
    struct Labels {
        static let measureYourPhysicalCondition = "Mesurer votre état de forme"
        static let surveyRicciGagnon = "Questionnaire de Ricci & Gagnon"
        static let createYourProfile = "Création de Profil"
        static let listOfProfiles = "Liste des Profils"
        static let suppressProfile = "Suppression du profil"
        static let consultProfileDetailed = "Consulter Détails du Profil"
        static let setCurrentUser = "Définir Utilisateur Actuel"
        static let createFirstProfile  = "Il vous faut un profil. Le créer ?"
        static let createNewProfile = "Créer un nouveau Profil ?"
        static let askToConsultProfileDetailed = "Voulez-vous consulter les détails de ce profil ?"
        static let askToSetCurrentUser = "Voulez-vous définir ce profil comme l'utilisateur actuel ?"
        static let askToDeleteProfile = "Voulez-vous supprimer ce profil ?"
        static let swipeToWatchVideo = "Glisser à gauche pour voir le tuto vidéo >>"
        static let swipeToStart = "Glisser pour commencer >>"
        static let later = "Plus Tard"
        static let now = "Maintenant"
        static let verifyProfile = "Vérification du Profil"
        static let modifyProfile = "Modification du Profil"
        static let profileDetailed = "Détails du Profil"
        static let error = "Erreur"
        static let nameAndFirstNameAlreadyTaken = "Vos prénom, nom sont déjà pris. Veuillez en choisir d'autres !"
        static let writeRightValues = "Veuillez inscrire des valeurs logiques !"
        static let yes = "Oui"
        static let no = "Non"
        static let results = "Résultats"
        static let profiles = "Profils"
        static let references = "Références"
        static let introduction = "Introduction"
        static let interpretation = "Interprétation"
        static let aboutUs = "Qui sommes-nous ?"
        static let disclosureIndicator = ">"
        static let instructions = "Instructions "
        static let random = "random"
        static let takingYourPulse = "Prenez votre pouls"
        static let pulsesPerMinute = " pulsations / minute"
        static let numberOfPulsesIn1Min = "Nombre de battements en 1 minute :"
        static let numberOfPulsesIn15Sec = "Nombre de battements en 15 secondes :"
        static let endTitleButton = "TERMINER"
        static let endSurveyText = "Fin du questionnaire"
        static let skipTitleButton = "PASSER"
        static let ok = "OK"
        static let stopTitleButton = "STOP"
        static let cancel = "Annuler"
        static let erase = "Effacer"
        static let subjectResultsString = "Résultats de l'app 'Tous en forme' pour "
        static let howFarAreYouGoing = "Jusqu'où allez-vous ?"
        static let numberOfMetersCovered = "Nombre de mètres parcourus :"
        static let numberOfPulsesInOneMinuteLabel = "Nombre de battements en 1 minute :"
        static let numberOfLifts = "Nombre de levées :"
        static let sumTwoHands = "Somme des deux mains :"
        static let resultsLabel = "Résultat :"
    }
    
    struct Texts {
        static let thierryBarriere = "Professeur d’éducation physique et sportive, co-directeur du Service Universitaire des sports, Université de Paris, 8 place Aurélie Nemours, Service des Sports, Bâtiment Sophie Germain, 75013 Paris, Tel : +33(0)1 57 27 79 60, email : Thierry.barriere@u-paris.fr"
        static let philippeDecq = "Neurochirurgien, Professeur des Universités-Praticien hospitalier, Université de Paris, Responsable de l’enseignement autour de l’activité physique adaptée (APA), Chef du service de neurochirurgie, hôpital Beaujon, Assistance Publique-Hôpitaux de Paris, 100 avenue du général Leclerc, 92110 Clichy, Tel : +33 (0)1 40 87 53 06, email : philippe.decq@aphp.fr"
        static let samiaSerri = "Responsable production audiovisuelle et Réalisatrice, Université de Paris, Département Image et Son, Bâtiment Lamarck : 5, rue Marie-Andrée Lagroua Weill-Hallé,  75013 Paris, Tel : +33(0)1 57 27 82 16, email : Samia.serri@u-paris.fr"
    }
    
    struct Keys {
        static let userId = "userId"
        static let userName = "userName"
        static let ricciResult = "ricciResult"
        static let birthyear = "birthyear"
        static let height = "height"
        static let weight = "weight"
        static let sex = "sex"
        static let status = "status"
        static let domain = "domain"
        static let descriptions = "descriptions"
        static let resultDictionary = "resultDictionary"
    }
    
    struct Durations {
        static let stepRestDuration = 60
        static let stepPulseDuration = 15
    }
    
}
