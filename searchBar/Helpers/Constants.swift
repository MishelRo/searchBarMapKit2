//
//  Constants.swift
//  searchBar
//
//  Created by User on 16.11.2021.
//
enum ConstString {
    case alarm
    case movement
    case stop
    case parking
    
    case stateZero
    case stateOne
    case stateTwo
    case stateThree
    case reuseIdentifier
    
    case hightForIphone7
    case height
}
extension ConstString {
    func path() -> String {
        switch self {
            
        case .alarm:
            return "Тревога"
        case .movement:
            return "Движение"
        case .stop:
            return "Остановка"
        case .parking:
            return "Парковка"
        case .stateZero:
            return "0"
        case .stateOne:
            return "1"
        case .stateTwo:
            return "2"
        case .stateThree:
            return "3"
        case .reuseIdentifier:
            return "pins"
        case .hightForIphone7:
            return "295"
        case .height:
            return "330"
        }
    }
}

class Constants {
    static func getStatus(status: ConstString) -> String {
        status.path()
    }
}
