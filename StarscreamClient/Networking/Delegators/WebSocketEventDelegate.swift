//
//  WebSocketEventDelegate.swift
//  ScreamingRocket
//
//  Created by doss-zstch1212 on 09/11/23.
//

import Foundation

protocol WebSocketEventDelegate {
    /// Called when the connection health is changed.
    func webSocketDidViabilityChange(isViable: Bool)
    
    /// Called when the device network connection gets upgraded.
    func webSocketShouldReconnect()
    
    /// Called when the peer(Server) closes the connection.
    func webSocketPeerClosed()
}
