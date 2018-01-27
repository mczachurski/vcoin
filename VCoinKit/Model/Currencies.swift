//
//  CurrencyLocale.swift
//  vcoin
//
//  Created by Marcin Czachurski on 18.01.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import Foundation

public class Currencies {
    
    public static var allCurrenciesDictionary:[String:Currency] = Currencies.initialzieCurrenciesDictionary()
    
    public static var allCurrenciesList = [
        Currency(code: "AED", locale: "ar-AE", name: "Arab Emirates Dirham"),
        Currency(code: "AFN", locale: "fa-AF", name: "Afghanistan Afghani"),
        Currency(code: "ALL", locale: "sq-AL", name: "Albanian Lek"),
        Currency(code: "AMD", locale: "hy-AM", name: "Armenian Dram"),
        Currency(code: "AOA", locale: "pt-AO", name: "Angolan Kwanza"),
        Currency(code: "ARS", locale: "es-AR", name: "Argentine Peso"),
        Currency(code: "AUD", locale: "en-AU", name: "Australian Dollar"),
        Currency(code: "AZN", locale: "az-AZ", name: "Azerbaijan New Manat"),
        Currency(code: "BAM", locale: "bs-BA", name: "Marka"),
        Currency(code: "BDT", locale: "bh-BD", name: "Bangladeshi Taka"),
        Currency(code: "BGN", locale: "bg-BG", name: "Bulgarian Lev"),
        Currency(code: "BHD", locale: "ar-BH", name: "Bahraini Dinar"),
        Currency(code: "BIF", locale: "fr-BI", name: "Burundi Franc"),
        Currency(code: "BND", locale: "ms-BN", name: "Brunei Dollar"),
        Currency(code: "BOB", locale: "es-BO", name: "Boliviano"),
        Currency(code: "BRL", locale: "es-BR", name: "Brazilian Real"),
        Currency(code: "BWP", locale: "en-BW", name: "Botswana Pula"),
        Currency(code: "BYN", locale: "be-BY", name: "Belarusian ruble"),
        Currency(code: "CAD", locale: "fr-CA", name: "Canadian Dollar"),
        Currency(code: "CHF", locale: "fr-CH", name: "Swiss Franc"),
        Currency(code: "CLP", locale: "es-CL", name: "Chilean Peso"),
        Currency(code: "CNY", locale: "ii-CN", name: "Yuan Renminbi"),
        Currency(code: "COP", locale: "es-CO", name: "Colombian Peso"),
        Currency(code: "CRC", locale: "es-CR", name: "Costa Rican Colon"),
        Currency(code: "CZK", locale: "cs-CZ", name: "Czech Koruna"),
        Currency(code: "DKK", locale: "da-DK", name: "Danish Krone"),
        Currency(code: "DOP", locale: "es-DO", name: "Dominican Peso"),
        Currency(code: "DZD", locale: "ar-DZ", name: "Algerian Dinar"),
        Currency(code: "EGP", locale: "ar-EG", name: "Egyptian Pound"),
        Currency(code: "ETB", locale: "so-ET", name: "Ethiopian Birr"),
        Currency(code: "EUR", locale: "fr-FR", name: "Euro"),
        Currency(code: "GBP", locale: "en-GB", name: "Pound Sterling"),
        Currency(code: "GEL", locale: "ka-GE", name: "Georgian Lari"),
        Currency(code: "GHS", locale: "ha-GH", name: "Ghanaian Cedi"),
        Currency(code: "GIP", locale: "en-GI", name: "Gibraltar Pound"),
        Currency(code: "GTQ", locale: "es-GT", name: "Guatemalan Quetzal"),
        Currency(code: "HKD", locale: "zh-HK", name: "Hong Kong Dollar"),
        Currency(code: "HNL", locale: "es-HN", name: "Honduran Lempira"),
        Currency(code: "HRK", locale: "hr-HR", name: "Croatian Kuna"),
        Currency(code: "HUF", locale: "hu-HU", name: "Hungarian Forint"),
        Currency(code: "IDR", locale: "id-ID", name: "Indonesian Rupiah"),
        Currency(code: "ILS", locale: "en-IL", name: "Israeli New Shekel"),
        Currency(code: "INR", locale: "ml-IN", name: "Indian Rupee"),
        Currency(code: "IQD", locale: "ar-IQ", name: "Iraqi Dinar"),
        Currency(code: "IRR", locale: "fa-IR", name: "Iranian Rial"),
        Currency(code: "ISK", locale: "is-IS", name: "Iceland Krona"),
        Currency(code: "JMD", locale: "en-JM", name: "Jamaican Dollar"),
        Currency(code: "JOD", locale: "ar-JO", name: "Jordanian Dinar"),
        Currency(code: "JPY", locale: "ja-JP", name: "Japanese Yen"),
        Currency(code: "KES", locale: "so-KE", name: "Kenyan Shilling"),
        Currency(code: "KGS", locale: "ky-KG", name: "Som"),
        Currency(code: "KHR", locale: "km-KH", name: "Kampuchean Riel"),
        Currency(code: "KRW", locale: "ko-KR", name: "Korean Won"),
        Currency(code: "KWD", locale: "ar-KW", name: "Kuwaiti Dinar"),
        Currency(code: "KZT", locale: "kk-KZ", name: "Kazakhstan Tenge"),
        Currency(code: "LBP", locale: "ar-LB", name: "Lebanese Pound"),
        Currency(code: "LKR", locale: "ta-LK", name: "Sri Lanka Rupee"),
        Currency(code: "MAD", locale: "ar-EH", name: "Malagasy Franc"),
        Currency(code: "MDL", locale: "ro-MD", name: "Moldovan Leu"),
        Currency(code: "MGA", locale: "mg-MG", name: "Malagasy Ariary"),
        Currency(code: "MMK", locale: "my-MM", name: "Myanmar Kyat"),
        Currency(code: "MOP", locale: "pt-MO", name: "Macau Pataca"),
        Currency(code: "MUR", locale: "fr-MU", name: "Mauritius Rupee"),
        Currency(code: "MWK", locale: "en-MW", name: "Malawi Kwacha"),
        Currency(code: "MXN", locale: "es-MX", name: "Mexican Nuevo Peso"),
        Currency(code: "MYR", locale: "ta-MY", name: "Malaysian Ringgit"),
        Currency(code: "MZN", locale: "pt-MZ", name: "Mozambique Metical"),
        Currency(code: "NAD", locale: "af-NA", name: "Namibian Dollar"),
        Currency(code: "NGN", locale: "yo-NG", name: "Nigerian Naira"),
        Currency(code: "NOK", locale: "nn-NO", name: "Norwegian Krone"),
        Currency(code: "NPR", locale: "ne-NP", name: "Nepalese Rupee"),
        Currency(code: "NZD", locale: "en-NZ", name: "New Zealand Dollar"),
        Currency(code: "OMR", locale: "ar-OM", name: "Omani Rial"),
        Currency(code: "PAB", locale: "es-PA", name: "Panamanian Balboa"),
        Currency(code: "PEN", locale: "es-PE", name: "Kampuchean Riel"),
        Currency(code: "PHP", locale: "es-PH", name: "Philippine Peso"),
        Currency(code: "PKR", locale: "ur-PK", name: "Pakistan Rupee"),
        Currency(code: "PLN", locale: "pl-PL", name: "Polish Zloty"),
        Currency(code: "PYG", locale: "es-PY", name: "Paraguay Guarani"),
        Currency(code: "QAR", locale: "ar-QA", name: "Qatari Rial"),
        Currency(code: "RON", locale: "ro-RO", name: "Romanian New Leu"),
        Currency(code: "RSD", locale: "sr-RS", name: "Dinar"),
        Currency(code: "RUB", locale: "ru-RU", name: "Russian Ruble"),
        Currency(code: "RWF", locale: "rw-RW", name: "Rwanda Franc"),
        Currency(code: "SAR", locale: "ar-SA", name: "Saudi Riyal"),
        Currency(code: "SEK", locale: "se-SE", name: "Swedish Krona"),
        Currency(code: "SGD", locale: "zh-SG", name: "Singapore Dollar"),
        Currency(code: "SZL", locale: "en-SZ", name: "Swaziland Lilangeni"),
        Currency(code: "THB", locale: "th-TH", name: "Thai Baht"),
        Currency(code: "TND", locale: "ar-TN", name: "Tunisian Dollar"),
        Currency(code: "TRY", locale: "tr-TR", name: "Turkish Lira"),
        Currency(code: "TTD", locale: "es-TT", name: "Trinidad and Tobago Dollar"),
        Currency(code: "TWD", locale: "zh-TW", name: "Taiwan Dollar"),
        Currency(code: "TZS", locale: "sw-TZ", name: "Tanzanian Shilling"),
        Currency(code: "UAH", locale: "uk-UA", name: "Ukraine Hryvnia"),
        Currency(code: "UGX", locale: "sw-UG", name: "Uganda Shilling"),
        Currency(code: "USD", locale: "en-US", name: "US Dollar"),
        Currency(code: "UYU", locale: "es-UY", name: "Uruguayan Peso"),
        Currency(code: "UZS", locale: "uz-UZ", name: "Uzbekistan Sum"),
        Currency(code: "VEF", locale: "es-VE", name: "Venezuelan Bolivar"),
        Currency(code: "VND", locale: "vi-VN", name: "Vietnamese Dong"),
        Currency(code: "VUV", locale: "fr-VU", name: "Vanuatu Vatu"),
        Currency(code: "XAF", locale: "fr-GA", name: "CFA Franc BEAC"),
        Currency(code: "XOF", locale: "fr-CI", name: "CFA Franc BCEAO"),
        Currency(code: "ZAR", locale: "zu-ZA", name: "South African Rand"),
        Currency(code: "ZMW", locale: "en-ZM", name: "Zambian Kwacha")
    ]
    
    private class func initialzieCurrenciesDictionary() -> [String:Currency] {
        var currencies:[String:Currency] = [:]
        for currency in Currencies.allCurrenciesList {
            currencies[currency.code] = currency
        }
        
        return currencies
    }
}
