//
//  WebSocketStateDelegate.swift
//  ScreamingRocket
//
//  Created by doss-zstch1212 on 06/11/23.
//

import Foundation

/// Delegate that informs the state changes of Websocket.
protocol WebSocketStateDelegate {
    func readyStateDidChanged(to state: ReadyState)
}
