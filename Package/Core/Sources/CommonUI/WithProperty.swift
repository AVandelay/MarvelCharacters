//
//  WithProperty.swift
//
//
//  Created by Ken Westdorp on 7/5/24.
//

import SwiftUI

public struct WithProperty<Property: DynamicProperty, Content: View>: View {
    let property: Property

    var content: (Property) -> Content

    public init(_ property: Property, @ViewBuilder content: @escaping (Property) -> Content) {
        self.property = property
        self.content = content
    }

    public var body: some View {
        content(property)
    }
}
