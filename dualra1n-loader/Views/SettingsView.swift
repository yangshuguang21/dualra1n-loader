//
//  SettingsView.swift
//  dualra1n
//
//  Created by Uckermark on 17.10.22.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var action: Actions
    private let gitCommit = Bundle.main.infoDictionary?["REVISION"] as? String ?? "unknown"
    private let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "unknown"
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: JailbreakSettingsView(action: action).navigationBarTitle("Jailbreak", displayMode: .inline)) {
                    Text("Jailbreak")
                }
                NavigationLink(destination: ToolsView(action: action).navigationBarTitle("Tools", displayMode: .inline)) {
                    Text("Tools")
                }
                NavigationLink(destination: DesignSettingsView(prefs: action.prefs).navigationBarTitle("Design", displayMode: .inline)) {
                    Text("Design")
                }
                NavigationLink(destination: LogView(action: action).navigationBarTitle("Credits", displayMode: .inline)) {
                    Text("Credits (Coming soon™)")
                }
                .disabled(true)
            }
            .navigationBarTitle("Settings", displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct JailbreakSettingsView: View {
    @ObservedObject var action: Actions
    
    var body: some View {
        List {
            Toggle("Enable Verbose", isOn: $action.verbose)
            Button("Delete cached bootstrap", action: action.deleteBootstrap)
            Button("Restore RootFS (experimental)", action: action.restoreRootFS)
        }
    }
}

struct ToolsView: View {
    @ObservedObject var action: Actions
    
    var body: some View {
        List {
            Button("Rebuild Icon Cache", action: action.runUiCache)
            Button("Remount R/W", action: action.remountRW)
            Button("Launch Daemons", action: action.launchDaemons)
            Button("Enable Tweaks", action: action.enableTweakInjection)
            Button("Respring", action: action.respringJB)
            Button("Restore Sileo", action: action.installSileo)
            Button("Add sources", action: action.addSource)
        }
    }
}

struct DesignSettingsView: View {
    @ObservedObject var prefs: Preferences
    let themes = ["Coastal Breeze", "Sunset Vibes"]
    
    var body: some View {
        List {
            Text("Select theme")
            Picker("", selection: $prefs.theme) {
                ForEach(themes, id: \.self) {
                    Text($0)
                }
            }
            .onDisappear() {
                prefs.save()
            }
            .pickerStyle(.wheel)
        }
    }
}
