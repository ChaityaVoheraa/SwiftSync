//
//  Status.swift
//  SwiftSync
//
//  Created by Chaitya Vohera on 30/03/24.
//

import Foundation

enum Status: String, CaseIterable {
    case Available
    case Busy
    case AtSchool = "At School"
    case AtTheMovies = "At The Movies"
    case AtWork = "At Work"
    case BatteryAboutToDie = "Battery About to die"
    case CantTalk = "Can't Talk"
    case InAMeeting = "In a Meeting"
    case AtTheGym = "At the gym"
    case Sleeping
    case UrgentCallsOnly = "Urgent calls only"
}
