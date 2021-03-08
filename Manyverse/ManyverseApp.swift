//
//  ManyverseApp.swift
//  Manyverse
//
//  Created by David Gomez on 3/7/21.
//

import SwiftUI

@main
struct ManyverseApp: App {
    let helper = AppHelper()
    
    init() {
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != "1" {
            let nodejsThread = Thread(target:helper, selector:#selector(helper.startNode), object:nil)
            nodejsThread.stackSize = 4*1024*1024;
            nodejsThread.start()
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}


class AppHelper {
    @objc func startNode() {
        var targetEnvironment = "iphoneos"
        #if targetEnvironment(simulator)
            targetEnvironment = "iphonesimulator"
        #endif
        let jsFile = Bundle.main.path(forResource: "backend/out/index.js", ofType: nil)!

        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let bundlePath = Bundle.main.bundlePath
//        Utils.debug("documentsPath \(documentsPath)")
        NodeRunner.startEngine(withArguments: ["node", jsFile, documentsPath, bundlePath, targetEnvironment])
    }
}
