//
//  File.swift
//  MarvelComicCharacters
//
//  Created by Ken Westdorp on 7/6/24.
//

import Foundation

import Foundation

/**
 A struct to hold the configuration details for accessing the Marvel API.

 - Note: To obtain the public and private keys, please register at [developer.marvel.com](https://developer.marvel.com).

 - Important: The public and private keys should be securely stored and not hardcoded in the source code. The keys below are placeholders and should be replaced with your actual Marvel API keys.
 */
struct Configuration {

    /// The base URL for the Marvel API.
    static let baseURL: URL = URL(string: "https://gateway.marvel.com")!

    /**
     The public key for accessing the Marvel API.

     - Important: Obtain your public key from [developer.marvel.com](https://developer.marvel.com).
     */
    static let publicKey: String = ""

    /**
     The private key for accessing the Marvel API.

     - Important: Obtain your private key from [developer.marvel.com](https://developer.marvel.com).
     */
    static let privateKey: String = ""
}
