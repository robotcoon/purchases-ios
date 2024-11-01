//
//  Copyright RevenueCat Inc. All Rights Reserved.
//
//  Licensed under the MIT License (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      https://opensource.org/licenses/MIT
//
//  OfferingsResponse.swift
//
//  Created by Nacho Soto on 3/31/22.
// swiftlint:disable nesting identifier_name missing_docs

import Foundation

#if PAYWALL_COMPONENTS

public struct PaywallComponentsData: Codable, Equatable, Sendable {

    public struct ComponentsConfigs: Codable, Equatable, Sendable {

        public var base: ComponentsConfig

        public init(base: ComponentsConfig) {
            self.base = base
        }

    }

    public struct ComponentsConfig: Codable, Equatable, Sendable {

        public var stack: PaywallComponent.StackComponent
        public let stickyFooter: PaywallComponent.StickyFooterComponent?

        public init(
            stack: PaywallComponent.StackComponent,
            stickyFooter: PaywallComponent.StickyFooterComponent?
        ) {
            self.stack = stack
            self.stickyFooter = stickyFooter
        }

    }

    public enum LocalizationData: Codable, Equatable, Sendable {
        case string(String), image(PaywallComponent.ThemeImageUrls)

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let stringValue = try? container.decode(String.self) {
                self = .string(stringValue)
            } else if let imageValue = try? container.decode(PaywallComponent.ThemeImageUrls.self) {
                self = .image(imageValue)
            } else {
                throw DecodingError.typeMismatch(
                    LocalizationData.self,
                    DecodingError.Context(codingPath: decoder.codingPath,
                                          debugDescription: "Wrong type for LocalizationData")
                )
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .string(let stringValue):
                try container.encode(stringValue)
            case .image(let imageValue):
                try container.encode(imageValue)
            }
        }
    }

    public var templateName: String

    /// The base remote URL where assets for this paywall are stored.
    public var assetBaseURL: URL

    /// The revision identifier for this paywall.
    public var revision: Int {
        get { return self._revision }
        set { self._revision = newValue }
    }

    public var componentsConfigs: ComponentsConfigs
    public var componentsLocalizations: [PaywallComponent.LocaleID: PaywallComponent.LocalizationDictionary]
    public var defaultLocale: String

    @DefaultDecodable.Zero
    internal private(set) var _revision: Int = 0

    private enum CodingKeys: String, CodingKey {
        case templateName
        case componentsConfigs
        case componentsLocalizations
        case defaultLocale
        case assetBaseURL = "assetBaseUrl"
        case _revision = "revision"
    }

    public init(templateName: String,
                assetBaseURL: URL,
                componentsConfigs: ComponentsConfigs,
                componentsLocalizations: [PaywallComponent.LocaleID: PaywallComponent.LocalizationDictionary],
                revision: Int,
                defaultLocaleIdentifier: String) {
        self.templateName = templateName
        self.assetBaseURL = assetBaseURL
        self.componentsConfigs = componentsConfigs
        self.componentsLocalizations = componentsLocalizations
        self._revision = revision
        self.defaultLocale = defaultLocaleIdentifier
    }

}

#endif

struct OfferingsResponse {

    struct Offering {

        struct Package {

            let identifier: String
            let platformProductIdentifier: String

        }

        let identifier: String
        let description: String
        let packages: [Package]
        @IgnoreDecodeErrors<PaywallData?>
        var paywall: PaywallData?
        @DefaultDecodable.EmptyDictionary
        var metadata: [String: AnyDecodable]

        #if PAYWALL_COMPONENTS
        // components
        var paywallComponents: PaywallComponentsData?
        #endif

    }

    struct Placements {
        let fallbackOfferingId: String?
        @DefaultDecodable.EmptyDictionary
        var offeringIdsByPlacement: [String: String?]
    }

    struct Targeting {
        let revision: Int
        let ruleId: String
    }

    let currentOfferingId: String?
    let offerings: [Offering]
    let placements: Placements?
    let targeting: Targeting?
}

extension OfferingsResponse {

    var productIdentifiers: Set<String> {
        return Set(
            self.offerings
                .lazy
                .flatMap { $0.packages }
                .map { $0.platformProductIdentifier }
        )
    }

}

extension OfferingsResponse.Offering.Package: Codable, Equatable {}
extension OfferingsResponse.Offering: Codable, Equatable {}
extension OfferingsResponse.Placements: Codable, Equatable {}
extension OfferingsResponse.Targeting: Codable, Equatable {}
extension OfferingsResponse: Codable, Equatable {}

extension OfferingsResponse: HTTPResponseBody {}
