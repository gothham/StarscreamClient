//
//  WebSocketClient.swift
//  ScreamingRocket
//
//  Created by doss-zstch1212 on 09/11/23.
//

import Foundation
import Starscream

protocol WebSocketClient {
    /// Current WebSocket connection state.
    var readyState: ReadyState { get set }
    /// Client WebSocket.
    var socket: WebSocket! { get set }
    /// Delegate property for replica methods of SocketRocket.
    var fusionSocketDelegate: FusionSocketDelegate? { get set }
    /// Delegate for additional events that Starscream provides.
    var eventDelegate: WebSocketEventDelegate? { get set }
    /// Delegate property for tracking the readyState changes.
    var webSocketStateHandler: WebSocketStateDelegate? { get set }
    /// Opens the WebSocket connection.
    func openWebSocketConnection()
    /// Closed the WebSocket connection.
    func closeWebSocketConnection()
    /// Close the existing and reconnect the WebSocket connection.
    func reconnectWebSocketConneciton()
}
