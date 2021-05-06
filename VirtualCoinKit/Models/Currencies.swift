//
//  CurrencyLocale.swift
//  vcoin
//
//  Created by Marcin Czachurski on 18.01.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import Foundation

public class Currencies {
    public static var allCurrenciesDictionary: [String: Currency] = Currencies.initialzieCurrenciesDictionary()

    public static var allCurrenciesList = [
        Currency(id: "AED", locale: "ar-AE", name: "Arab Emirates Dirham"),
        Currency(id: "AFN", locale: "fa-AF", name: "Afghanistan Afghani"),
        Currency(id: "ALL", locale: "sq-AL", name: "Albanian Lek"),
        Currency(id: "AMD", locale: "hy-AM", name: "Armenian Dram"),
        Currency(id: "AOA", locale: "pt-AO", name: "Angolan Kwanza"),
        Currency(id: "ARS", locale: "es-AR", name: "Argentine Peso"),
        Currency(id: "AUD", locale: "en-AU", name: "Australian Dollar"),
        Currency(id: "AZN", locale: "az-AZ", name: "Azerbaijan New Manat"),
        Currency(id: "BAM", locale: "bs-BA", name: "Marka"),
        Currency(id: "BDT", locale: "bh-BD", name: "Bangladeshi Taka"),
        Currency(id: "BGN", locale: "bg-BG", name: "Bulgarian Lev"),
        Currency(id: "BHD", locale: "ar-BH", name: "Bahraini Dinar"),
        Currency(id: "BIF", locale: "fr-BI", name: "Burundi Franc"),
        Currency(id: "BND", locale: "ms-BN", name: "Brunei Dollar"),
        Currency(id: "BOB", locale: "es-BO", name: "Boliviano"),
        Currency(id: "BRL", locale: "es-BR", name: "Brazilian Real"),
        Currency(id: "BWP", locale: "en-BW", name: "Botswana Pula"),
        Currency(id: "BYN", locale: "be-BY", name: "Belarusian ruble"),
        Currency(id: "CAD", locale: "fr-CA", name: "Canadian Dollar"),
        Currency(id: "CHF", locale: "fr-CH", name: "Swiss Franc"),
        Currency(id: "CLP", locale: "es-CL", name: "Chilean Peso"),
        Currency(id: "CNY", locale: "ii-CN", name: "Yuan Renminbi"),
        Currency(id: "COP", locale: "es-CO", name: "Colombian Peso"),
        Currency(id: "CRC", locale: "es-CR", name: "Costa Rican Colon"),
        Currency(id: "CZK", locale: "cs-CZ", name: "Czech Koruna"),
        Currency(id: "DKK", locale: "da-DK", name: "Danish Krone"),
        Currency(id: "DOP", locale: "es-DO", name: "Dominican Peso"),
        Currency(id: "DZD", locale: "ar-DZ", name: "Algerian Dinar"),
        Currency(id: "EGP", locale: "ar-EG", name: "Egyptian Pound"),
        Currency(id: "ETB", locale: "so-ET", name: "Ethiopian Birr"),
        Currency(id: "EUR", locale: "fr-FR", name: "Euro"),
        Currency(id: "GBP", locale: "en-GB", name: "Pound Sterling"),
        Currency(id: "GEL", locale: "ka-GE", name: "Georgian Lari"),
        Currency(id: "GHS", locale: "ha-GH", name: "Ghanaian Cedi"),
        Currency(id: "GIP", locale: "en-GI", name: "Gibraltar Pound"),
        Currency(id: "GTQ", locale: "es-GT", name: "Guatemalan Quetzal"),
        Currency(id: "HKD", locale: "zh-HK", name: "Hong Kong Dollar"),
        Currency(id: "HNL", locale: "es-HN", name: "Honduran Lempira"),
        Currency(id: "HRK", locale: "hr-HR", name: "Croatian Kuna"),
        Currency(id: "HUF", locale: "hu-HU", name: "Hungarian Forint"),
        Currency(id: "IDR", locale: "id-ID", name: "Indonesian Rupiah"),
        Currency(id: "ILS", locale: "en-IL", name: "Israeli New Shekel"),
        Currency(id: "INR", locale: "ml-IN", name: "Indian Rupee"),
        Currency(id: "IQD", locale: "ar-IQ", name: "Iraqi Dinar"),
        Currency(id: "IRR", locale: "fa-IR", name: "Iranian Rial"),
        Currency(id: "ISK", locale: "is-IS", name: "Iceland Krona"),
        Currency(id: "JMD", locale: "en-JM", name: "Jamaican Dollar"),
        Currency(id: "JOD", locale: "ar-JO", name: "Jordanian Dinar"),
        Currency(id: "JPY", locale: "ja-JP", name: "Japanese Yen"),
        Currency(id: "KES", locale: "so-KE", name: "Kenyan Shilling"),
        Currency(id: "KGS", locale: "ky-KG", name: "Som"),
        Currency(id: "KHR", locale: "km-KH", name: "Kampuchean Riel"),
        Currency(id: "KRW", locale: "ko-KR", name: "Korean Won"),
        Currency(id: "KWD", locale: "ar-KW", name: "Kuwaiti Dinar"),
        Currency(id: "KZT", locale: "kk-KZ", name: "Kazakhstan Tenge"),
        Currency(id: "LBP", locale: "ar-LB", name: "Lebanese Pound"),
        Currency(id: "LKR", locale: "ta-LK", name: "Sri Lanka Rupee"),
        Currency(id: "MAD", locale: "ar-EH", name: "Malagasy Franc"),
        Currency(id: "MDL", locale: "ro-MD", name: "Moldovan Leu"),
        Currency(id: "MGA", locale: "mg-MG", name: "Malagasy Ariary"),
        Currency(id: "MMK", locale: "my-MM", name: "Myanmar Kyat"),
        Currency(id: "MOP", locale: "pt-MO", name: "Macau Pataca"),
        Currency(id: "MUR", locale: "fr-MU", name: "Mauritius Rupee"),
        Currency(id: "MWK", locale: "en-MW", name: "Malawi Kwacha"),
        Currency(id: "MXN", locale: "es-MX", name: "Mexican Nuevo Peso"),
        Currency(id: "MYR", locale: "ta-MY", name: "Malaysian Ringgit"),
        Currency(id: "MZN", locale: "pt-MZ", name: "Mozambique Metical"),
        Currency(id: "NAD", locale: "af-NA", name: "Namibian Dollar"),
        Currency(id: "NGN", locale: "yo-NG", name: "Nigerian Naira"),
        Currency(id: "NOK", locale: "nn-NO", name: "Norwegian Krone"),
        Currency(id: "NPR", locale: "ne-NP", name: "Nepalese Rupee"),
        Currency(id: "NZD", locale: "en-NZ", name: "New Zealand Dollar"),
        Currency(id: "OMR", locale: "ar-OM", name: "Omani Rial"),
        Currency(id: "PAB", locale: "es-PA", name: "Panamanian Balboa"),
        Currency(id: "PEN", locale: "es-PE", name: "Kampuchean Riel"),
        Currency(id: "PHP", locale: "es-PH", name: "Philippine Peso"),
        Currency(id: "PKR", locale: "ur-PK", name: "Pakistan Rupee"),
        Currency(id: "PLN", locale: "pl-PL", name: "Polish Zloty"),
        Currency(id: "PYG", locale: "es-PY", name: "Paraguay Guarani"),
        Currency(id: "QAR", locale: "ar-QA", name: "Qatari Rial"),
        Currency(id: "RON", locale: "ro-RO", name: "Romanian New Leu"),
        Currency(id: "RSD", locale: "sr-RS", name: "Dinar"),
        Currency(id: "RUB", locale: "ru-RU", name: "Russian Ruble"),
        Currency(id: "RWF", locale: "rw-RW", name: "Rwanda Franc"),
        Currency(id: "SAR", locale: "ar-SA", name: "Saudi Riyal"),
        Currency(id: "SEK", locale: "se-SE", name: "Swedish Krona"),
        Currency(id: "SGD", locale: "zh-SG", name: "Singapore Dollar"),
        Currency(id: "SZL", locale: "en-SZ", name: "Swaziland Lilangeni"),
        Currency(id: "THB", locale: "th-TH", name: "Thai Baht"),
        Currency(id: "TND", locale: "ar-TN", name: "Tunisian Dollar"),
        Currency(id: "TRY", locale: "tr-TR", name: "Turkish Lira"),
        Currency(id: "TTD", locale: "es-TT", name: "Trinidad and Tobago Dollar"),
        Currency(id: "TWD", locale: "zh-TW", name: "Taiwan Dollar"),
        Currency(id: "TZS", locale: "sw-TZ", name: "Tanzanian Shilling"),
        Currency(id: "UAH", locale: "uk-UA", name: "Ukraine Hryvnia"),
        Currency(id: "UGX", locale: "sw-UG", name: "Uganda Shilling"),
        Currency(id: "USD", locale: "en-US", name: "US Dollar"),
        Currency(id: "UYU", locale: "es-UY", name: "Uruguayan Peso"),
        Currency(id: "UZS", locale: "uz-UZ", name: "Uzbekistan Sum"),
        Currency(id: "VEF", locale: "es-VE", name: "Venezuelan Bolivar"),
        Currency(id: "VND", locale: "vi-VN", name: "Vietnamese Dong"),
        Currency(id: "VUV", locale: "fr-VU", name: "Vanuatu Vatu"),
        Currency(id: "XAF", locale: "fr-GA", name: "CFA Franc BEAC"),
        Currency(id: "XOF", locale: "fr-CI", name: "CFA Franc BCEAO"),
        Currency(id: "ZAR", locale: "zu-ZA", name: "South African Rand"),
        Currency(id: "ZMW", locale: "en-ZM", name: "Zambian Kwacha")
    ]

    private class func initialzieCurrenciesDictionary() -> [String: Currency] {
        var currencies: [String: Currency] = [:]
        for currency in Currencies.allCurrenciesList {
            currencies[currency.id] = currency
        }

        return currencies
    }
}
