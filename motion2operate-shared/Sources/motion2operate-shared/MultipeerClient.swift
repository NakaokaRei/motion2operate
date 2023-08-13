//
//  MultipeerClient.swift
//  
//
//  Created by rei.nakaoka on 2023/08/13.
//

import Foundation
import MultipeerConnectivity

public protocol MulitipeerProtocol {
    func recievedMessage(message: String)
}

public class MultipeerClient: NSObject {

    private let serviceType = "motion2operate"
    #if os(iOS)
    private let myPeerID = MCPeerID(displayName: "iOS")
    #elseif os(macOS)
    private let myPeerID = MCPeerID(displayName: "Mac")
    #endif
    private var session: MCSession!
    private var serviceAdvertiser: MCNearbyServiceAdvertiser!
    private var serviceBrowser: MCNearbyServiceBrowser!
    private var connectedPeers: [MCPeerID] {
        return session.connectedPeers
    }

    public var delegate: MulitipeerProtocol?

    public override init() {
        super.init()

        session = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self

        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: nil, serviceType: serviceType)
        serviceAdvertiser.delegate = self
        serviceAdvertiser.startAdvertisingPeer() // サービスへの参加意思を周りに伝えることを開始

        serviceBrowser = MCNearbyServiceBrowser(peer: myPeerID, serviceType: serviceType)
        serviceBrowser.delegate = self
        serviceBrowser.startBrowsingForPeers() // 近くのピアの検索を開始
    }

    public func send(message: String) {
        do {
            try session.send(message.data(using: .utf8)!, toPeers: connectedPeers, with: .reliable)
        } catch {
            print(error)
        }
    }

}

extension MultipeerClient: MCSessionDelegate {

    public func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        let message: String
        switch state {
        case .connected:
            message = "\(peerID.displayName)が接続されました"
        case .connecting:
            message = "\(peerID.displayName)が接続中です"
        case .notConnected:
            message = "\(peerID.displayName)が切断されました"
        @unknown default:
            message = "\(peerID.displayName)が想定外の状態です"
        }
        print(message)
    }

    public func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        guard let message = String(data: data, encoding: .utf8) else {
            return
        }
        delegate?.recievedMessage(message: message)
    }

    public func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        assertionFailure("非対応")
    }

    public func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        assertionFailure("非対応")
    }

    public func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        assertionFailure("非対応")
    }
}

extension MultipeerClient: MCNearbyServiceAdvertiserDelegate {

    public func advertiser(
        _ advertiser: MCNearbyServiceAdvertiser,
        didReceiveInvitationFromPeer peerID: MCPeerID,
        withContext context: Data?,
        invitationHandler: @escaping (Bool, MCSession?) -> Void
    ) {
        invitationHandler(true, session)
    }
}

extension MultipeerClient: MCNearbyServiceBrowserDelegate {

    public func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        guard let session = session else {
            return
        }
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 0)
    }

    public func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
    }
}
