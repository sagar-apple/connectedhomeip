//
//  ContentView.swift
//  CTSwift
//
//  Created by Sagar Dhawan on 4/25/21.
//

import SwiftUI
import os.log
import CHIP

struct ContentView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Hello, world!")
                .padding()
            Button("Tap to Read") {

                // The CHIPDeviceController is our primary handle to CHIP
                let controller = CHIPDeviceController.shared()
                do {
                    // Get a paired CHIP Device using the Node ID we assigned during pairing
                    let device = try controller.getPairedDevice(1)
                    // We're interested in the state of the OnOffCluster
                    let onOffCluster = CHIPOnOff.init(device: device, endpoint: 1, queue: DispatchQueue.main)
                    // Perform a read on the OnOff attribute
                    onOffCluster?.readAttribute(onOff: { (error, values) in
                        if let value = values?["value"]
                        {
                            // The CHIP spec determines the types used here
                            let state = value as! NSInteger;
                            // update the UI here
                            updateLightState(state: state == 1)
                        }
                    })
                    onOffCluster?.toggle({ (error, values) in
                        if error != nil {
                            handleAccessoryError(error)
                        }
                    })
                } catch {
                    print("Could not find device. Error:%@", error)
                }
            }.padding()
        }
    }
}

func updateLightState(state: Bool) {
    print("Updated Accessory state to %@", state)

}

func handleAccessoryError(state: Bool) {
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
