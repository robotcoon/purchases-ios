//
//  Copyright RevenueCat Inc. All Rights Reserved.
//
//  Licensed under the MIT License (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      https://opensource.org/licenses/MIT
//
//  StackComponent.swift
//
//  Created by James Borthwick on 2024-08-20.
// swiftlint:disable missing_docs

import Foundation

#if PAYWALL_COMPONENTS

public extension PaywallComponent {

    struct StackComponent: PaywallComponentBase {

        let type: ComponentType
        public let components: [PaywallComponent]
        public let width: WidthSize?
        public let spacing: CGFloat?
        public let backgroundColor: ColorInfo?
        public let dimension: Dimension
        public let padding: Padding
        public let margin: Padding
        public let cornerRadiuses: CornerRadiuses?
        public let border: Border?
        public let shadow: Shadow?

        public init(components: [PaywallComponent],
                    dimension: Dimension = .vertical(.center),
                    width: WidthSize? = nil,
                    spacing: CGFloat? = nil,
                    backgroundColor: ColorInfo? = nil,
                    padding: Padding = .zero,
                    margin: Padding = .zero,
                    cornerRadiuses: CornerRadiuses? = nil,
                    border: Border? = nil,
                    shadow: Shadow? = nil
        ) {
            self.components = components
            self.width = width
            self.spacing = spacing
            self.backgroundColor = backgroundColor
            self.type = .stack
            self.dimension = dimension
            self.padding = padding
            self.margin = margin
            self.cornerRadiuses = cornerRadiuses
            self.border = border
            self.shadow = shadow
        }

    }

}

#endif
