//
//  Multiplayer.swift
//  shared-cube
//
//  Created by Adam Watters on 4/20/24.
//

import GroupActivities

/// Starts a Happy Beam group activity.
func startSession() async throws {
    let activity = _GroupActivity()
    let activationSuccess = try await activity.activate()
    print("Group Activities session activation: ", activationSuccess)
}

/// Metadata about the Happy Beam group activity.
struct _GroupActivity: GroupActivity {
    var metadata: GroupActivityMetadata {
        var data = GroupActivityMetadata()
        data.title = "Shared Cube"
        data.subtitle = "Behold the cube."
        data.supportsContinuationOnTV = false
        return data
    }
    static var activityIdentifier = "com.threezy.shared-cube"
}
