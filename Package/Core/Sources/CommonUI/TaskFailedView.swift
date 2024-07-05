//
//  TaskFailedView.swift
//
//
//  Created by Ken Westdorp on 7/5/24.
//

import SwiftUI

public struct TaskFailedView: View {
    public init() { }

    public var body: some View {
        Image(systemName: "xmark")
            .symbolRenderingMode(.multicolor)
            .imageScale(.large)
            .padding()
    }
}
