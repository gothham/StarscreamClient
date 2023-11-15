//
//  ReadyState.swift
//  ScreamingRocket
//
//  Created by doss-zstch1212 on 04/11/23.
//
// This is an effort to handle the websocket readyState from the client side since Starscream doesn't provide the functionality for readyState. But the library (Starscream) has handled it gracefully inside their framework.

import Foundation

/// Type used for checking the ReadyState/ConnectionState/SocketState.
enum ReadyState: Int {
    /// Initial state when a WebSocket connection is created, and it's not yet open.
    case connecting = 0
    
    /// The connection is fully open, and you can send and receive data.
    case open = 1
    
    /// When either the client or the server initiates the process of closing the WebSocket connection, it enters the "CLOSING" state.
    case closing = 2
    
    /// Connection is no longer open, and you can't send or receive data through it.
    case closed = 3
    
    /// Connection Failed.
    case failed = 4
}