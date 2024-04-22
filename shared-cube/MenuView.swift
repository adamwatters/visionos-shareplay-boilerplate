//  Created by Adam Watters on 4/20/24.

import SwiftUI
import GroupActivities

struct MenuView: View {
    @StateObject private var groupStateObserver = GroupStateObserver()
    
    var body: some View {
        VStack {
            Text("groupStateObserver.isEligibleForGroupSession is \(groupStateObserver.isEligibleForGroupSession)")
            Button {
                print("Starting as SharePlay", groupStateObserver.isEligibleForGroupSession)
                
                Task {
                    do {
                        try await startSession()
                    } catch {
                        print("SharePlay session failure", error)
                    }
                }
            } label: {
                Text("Play with Friends").padding(20)
            }
            .disabled(!groupStateObserver.isEligibleForGroupSession)
        }.padding(36)
    }
}
