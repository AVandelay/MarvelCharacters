//
//  Tagged.swift
//
//
//  Created by Ken Westdorp on 7/4/24.
//

import Foundation

public struct Tagged<Tag, Value: Equatable & Sendable>: Equatable, Sendable {
    public let value: Value
}

public typealias CharacterID = Tagged<CharacterTag, Int>
public typealias ComicID = Tagged<ComicTag, URL>

public enum CharacterTag {}
public enum ComicTag {}
