//
//  SettingsSheetView.swift
//  palera1nLoader
//
//  Created by Lakhan Lothiyi on 26/11/2022.
//

import Foundation
import SwiftUI
import IrregularGradient

struct SettingsSheetView: View {
    @Binding var isOpen: Bool
    @EnvironmentObject var console: Console
    
    var tools: [Tool] = [
        Tool(name: "UICache", desc: "Refresh icon cache of jailbreak apps", action: ToolAction.uicache),
        Tool(name: "Remount r/w", desc: "Remounts the rootfs and preboot as read/write", action: ToolAction.mntrw),
        Tool(name: "Launch Daemons", desc: "Start daemons using launchctl", action: ToolAction.daemons),
        Tool(name: "Respring", desc: "Restart SpringBoard", action: ToolAction.respring),
        Tool(name: "Activate Tweaks", desc: "Runs substitute-launcher to activate tweaks", action: ToolAction.tweaks),
        Tool(name: "Kickstart", desc: "Do all of the above and fix dpkg", action: ToolAction.all),
    ]
    
    var openers: [Opener] = [
        Opener(name: "Sileo", desc: "Open the Sileo app", action: Openers.sileo),
        Opener(name: "TrollHelper", desc: "Open the TrollHelper app", action: Openers.trollhelper),
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Rectangle()
                    .irregularGradient(colors: palera1nColorGradients, backgroundColor: palera1nColorGradients[1], animate: true, speed: 0.5)
                    .blur(radius: 100)
                
                main
            }
        }
    }
    
    @ViewBuilder
    var main: some View {
        ScrollView {
            ForEach(tools) { tool in
                ToolsView(tool)
            }

            Text("Openers")
                .fontWeight(.bold)
                .font(.title)

            ForEach(openers) { opener in
                OpenersView(opener)
            }
        }
        .navigationTitle("Tools")
    }

    @ViewBuilder
    func ToolsView(_ tool: Tool) -> some View {
        Button {
            switch tool.action {
                case .uicache:
                    self.runUiCache()
                case .mntrw:
                    spawn(command: "/sbin/mount", args: ["-uw", "/private/preboot"], root: true)
                    spawn(command: "/sbin/mount", args: ["-uw", "/" ], root: true)
                    console.log("[*] Remounted the rootfs and preboot as read/write")
                case .daemons:
                    spawn(command: "/bin/launchctl", args: ["bootstrap", "system", "/Library/LaunchDaemons"], root: true)
                    spawn(command: "/usr/libexec/firmware", args: [""], root: true)
                    spawn(command: "/usr/sbin/pwd_mkdb", args: ["-p", "/etc/master.passwd"], root: true)
                    spawn(command: "/Library/dpkg/info/debianutils.postinst", args: ["configure", "99999"], root: true)
                    spawn(command: "/Library/dpkg/info/apt.postinst", args: ["configure", "99999"], root: true)
                    spawn(command: "/Library/dpkg/info/dash.postinst", args: ["configure", "99999"], root: true)
                    spawn(command: "/Library/dpkg/info/zsh.postinst", args: ["configure", "99999"], root: true)
                    spawn(command: "/Library/dpkg/info/bash.postinst", args: ["configure", "99999"], root: true)
                    spawn(command: "/Library/dpkg/info/vi.postinst", args: ["configure", "99999"], root: true)
                    spawn(command: "/Library/dpkg/info/openssh-server.extrainst_", args: ["install"], root: true)
                    spawn(command: "/usr/sbin/pwd_mkdb", args: ["-p", "/etc/master.passwd"], root: true)
                    spawn(command: "/usr/bin/chsh", args: ["-s", "/usr/bin/zsh", "mobile"], root: true)
                    spawn(command: "/usr/bin/chsh", args: ["-s", "/usr/bin/zsh", "root"], root: true)
                    spawn(command: "/usr/bin/sh", args: ["/launch_ssh_daemon.sh"], root: true)
                    console.log("[*] Launched daemons")
                case .respring:
                    spawn(command: "/usr/bin/sbreload", args: [], root: true)
                    console.log("[*] Resprung the device... but you probably won't see this :)")
                case .tweaks:
                    spawn(command: "/etc/rc.d/substitute-launcher", args: [], root: true)
                    console.log("[*] Started Substitute, respring to enable tweaks")
                case .all:
                    self.runUiCache()

                    spawn(command: "/sbin/mount", args: ["-uw", "/private/preboot"], root: true)
                    spawn(command: "/sbin/mount", args: ["-uw", "/" ], root: true)
                    console.log("[*] Remounted the rootfs and preboot as read/write")

                    spawn(command: "/bin/launchctl", args: ["bootstrap", "system", "/Library/LaunchDaemons"], root: true)
                    spawn(command: "/usr/libexec/firmware", args: [""], root: true)
                    spawn(command: "/usr/sbin/pwd_mkdb", args: ["-p", "/etc/master.passwd"], root: true)
                    spawn(command: "/Library/dpkg/info/debianutils.postinst", args: ["configure", "99999"], root: true)
                    spawn(command: "/Library/dpkg/info/apt.postinst", args: ["configure", "99999"], root: true)
                    spawn(command: "/Library/dpkg/info/dash.postinst", args: ["configure", "99999"], root: true)
                    spawn(command: "/Library/dpkg/info/zsh.postinst", args: ["configure", "99999"], root: true)
                    spawn(command: "/Library/dpkg/info/bash.postinst", args: ["configure", "99999"], root: true)
                    spawn(command: "/Library/dpkg/info/vi.postinst", args: ["configure", "99999"], root: true)
                    spawn(command: "/Library/dpkg/info/openssh-server.extrainst_", args: ["install"], root: true)
                    spawn(command: "/usr/sbin/pwd_mkdb", args: ["-p", "/etc/master.passwd"], root: true)
                    spawn(command: "/usr/bin/chsh", args: ["-s", "/usr/bin/zsh", "mobile"], root: true)
                    spawn(command: "/usr/bin/chsh", args: ["-s", "/usr/bin/zsh", "root"], root: true)
                    spawn(command: "/usr/bin/sh", args: ["/launch_ssh_daemon.sh"], root: true)
                    console.log("[*] Launched daemons")

                    spawn(command: "/usr/bin/ldid", args: ["-s", "/usr/bin/apt"], root: true)
                    console.log("[*] Fixed zsh: killed     apt")

                    spawn(command: "/usr/bin/ldid", args: ["-s", "/etc/rc.d/substitute-launcher"], root: true)
                    console.log("[*] Fixed zsh: killed     /etc/rc.d/substitute-launcher")

                    spawn(command: "/etc/rc.d/substitute-launcher", args: [], root: true)
                    console.log("[*] Started Substitute, respring to enable tweaks")

                    spawn(command: "/usr/libexec/firmware", args: [""], root: true)
                    console.log("[*] Fixed dpkg, apt, cydia substrate, and preferenceloader")

                    spawn(command: "/usr/bin/sbreload", args: [], root: true)
                    console.log("[*] Resprung the device... but you probably won't see this :)")
            }

            self.isOpen.toggle()
        } label: {
            HStack {
                Image(systemName: "wrench")
                
                VStack(alignment: .leading) {
                    Text(tool.name)
                        .font(.title2.bold())
                    Text(tool.desc)
                        .font(.caption)
                }
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Capsule().foregroundColor(.init("CellBackground")).background(.ultraThinMaterial))
            .clipShape(Capsule())
            .padding(.horizontal)
            .padding(.vertical, 4)
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    func OpenersView(_ opener: Opener) -> some View {
        Button {
            self.isOpen.toggle()

            switch opener.action {
                case .sileo:
                    spawn(command: "/usr/bin/plooshiuicache", args: ["-p", "/Applications/Sileo.app"], root: true)
                    let ret = spawn(command: "/usr/bin/uiopen", args: ["--path", "/Applications/Sileo.app"], root: true)
                    DispatchQueue.main.async {
                        if ret != 0 {
                            console.error("[-] Failed to open Sileo. Status: \(ret)")
                            return
                        }

                        console.log("[*] Opened Sileo")
                    }
                case .trollhelper:
                    spawn(command: "/usr/bin/plooshiuicache", args: ["-p", "/Applications/TrollStorePersistenceHelper.app"], root: true)
                    let ret = spawn(command: "/usr/bin/uiopen", args: ["--path", "/Applications/TrollStorePersistenceHelper.app"], root: true)
                    DispatchQueue.main.async {
                        if ret != 0 {
                            console.error("[-] Failed to open TrollHelper. Status: \(ret)")
                            return
                        }

                        console.log("[*] Opened TrollHelper")
                    }
            }
        } label: {
            HStack {
                Image(systemName: "wrench")
                
                VStack(alignment: .leading) {
                    Text("Open \(opener.name)")
                        .font(.title2.bold())
                    Text(opener.desc)
                        .font(.caption)
                }
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Capsule().foregroundColor(.init("CellBackground")).background(.ultraThinMaterial))
            .clipShape(Capsule())
            .padding(.horizontal)
            .padding(.vertical, 4)
        }
        .buttonStyle(.plain)
    }

    private func runUiCache() {
        DispatchQueue.global(qos: .utility).async {
            // for every .app file in /Applications, run uicache -p
            let fm = FileManager.default
            let apps = try? fm.contentsOfDirectory(atPath: "/Applications")
            let excludeApps: [String] = ["Xcode Previews.app", "Sidecar.app"]
            for app in apps ?? [] {
                if app.hasSuffix(".app") && !excludeApps.contains(app) {
                    let ret = spawn(command: "/usr/bin/uicache", args: ["-p", "/Applications/\(app)"], root: true)
                    DispatchQueue.main.async {
                        if ret != 0 {
                            console.error("[-] Failed to uicache \(app). Status: \(ret)")
                            return
                        }
                        console.log("[*] Registered apps in /Applications")
                    }
                }
            }

        }
    }
    
}

public enum ToolAction {
    case uicache
    case mntrw
    case daemons
    case respring
    case tweaks
    case all
}

struct Tool: Identifiable {
    var id: String { name }
    let name: String
    let desc: String
    let action: ToolAction
}

// openers
public enum Openers {
    case sileo
    case trollhelper
}

struct Opener: Identifiable {
    var id: String { name }
    let name: String
    let desc: String
    let action: Openers
}

struct SettingsSheetView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsSheetView(isOpen: .constant(true))
            .preferredColorScheme(.dark)
    }
}