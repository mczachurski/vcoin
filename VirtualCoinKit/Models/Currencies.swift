//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import Foundation

public class Currencies {
    public static var allCurrenciesDictionary: [String: Currency] = Currencies.initialzieCurrenciesDictionary()

    public static var allCurrenciesList = [
        Currency(id: "united-arab-emirates-dirham", symbol: "AED", locale: "ar-AE", name: "Arab Emirates Dirham"),
        Currency(id: "afghan-afghani", symbol: "AFN", locale: "fa-AF", name: "Afghanistan Afghani"),
        // Currency(id: "", symbol: "ALL", locale: "sq-AL", name: "Albanian Lek"),
        Currency(id: "armenian-dram", symbol: "AMD", locale: "hy-AM", name: "Armenian Dram"),
        Currency(id: "angolan-kwanza", symbol: "AOA", locale: "pt-AO", name: "Angolan Kwanza"),
        Currency(id: "argentine-peso", symbol: "ARS", locale: "es-AR", name: "Argentine Peso"),
        Currency(id: "australian-dollar", symbol: "AUD", locale: "en-AU", name: "Australian Dollar"),
        Currency(id: "azerbaijani-manat", symbol: "AZN", locale: "az-AZ", name: "Azerbaijan New Manat"),
        Currency(id: "bosnia-herzegovina-convertible-mark", symbol: "BAM", locale: "bs-BA", name: "Marka"),
        Currency(id: "bangladeshi-taka", symbol: "BDT", locale: "bh-BD", name: "Bangladeshi Taka"),
        Currency(id: "bulgarian-lev", symbol: "BGN", locale: "bg-BG", name: "Bulgarian Lev"),
        Currency(id: "bahraini-dinar", symbol: "BHD", locale: "ar-BH", name: "Bahraini Dinar"),
        Currency(id: "burundian-franc", symbol: "BIF", locale: "fr-BI", name: "Burundi Franc"),
        Currency(id: "brunei-dollar", symbol: "BND", locale: "ms-BN", name: "Brunei Dollar"),
        Currency(id: "bolivian-boliviano", symbol: "BOB", locale: "es-BO", name: "Boliviano"),
        Currency(id: "brazilian-real", symbol: "BRL", locale: "es-BR", name: "Brazilian Real"),
        Currency(id: "botswanan-pula", symbol: "BWP", locale: "en-BW", name: "Botswana Pula"),
        Currency(id: "belarusian-ruble", symbol: "BYN", locale: "be-BY", name: "Belarusian ruble"),
        Currency(id: "canadian-dollar", symbol: "CAD", locale: "fr-CA", name: "Canadian Dollar"),
        Currency(id: "swiss-franc", symbol: "CHF", locale: "fr-CH", name: "Swiss Franc"),
        Currency(id: "chilean-peso", symbol: "CLP", locale: "es-CL", name: "Chilean Peso"),
        Currency(id: "chinese-yuan-renminbi", symbol: "CNY", locale: "ii-CN", name: "Yuan Renminbi"),
        Currency(id: "colombian-peso", symbol: "COP", locale: "es-CO", name: "Colombian Peso"),
        Currency(id: "costa-rican-colón", symbol: "CRC", locale: "es-CR", name: "Costa Rican Colon"),
        Currency(id: "czech-republic-koruna", symbol: "CZK", locale: "cs-CZ", name: "Czech Koruna"),
        Currency(id: "danish-krone", symbol: "DKK", locale: "da-DK", name: "Danish Krone"),
        Currency(id: "dominican-peso", symbol: "DOP", locale: "es-DO", name: "Dominican Peso"),
        Currency(id: "algerian-dinar", symbol: "DZD", locale: "ar-DZ", name: "Algerian Dinar"),
        Currency(id: "egyptian-pound", symbol: "EGP", locale: "ar-EG", name: "Egyptian Pound"),
        Currency(id: "ethiopian-birr", symbol: "ETB", locale: "so-ET", name: "Ethiopian Birr"),
        Currency(id: "euro", symbol: "EUR", locale: "fr-FR", name: "Euro"),
        Currency(id: "british-pound-sterling", symbol: "GBP", locale: "en-GB", name: "Pound Sterling"),
        Currency(id: "georgian-lari", symbol: "GEL", locale: "ka-GE", name: "Georgian Lari"),
        Currency(id: "ghanaian-cedi", symbol: "GHS", locale: "ha-GH", name: "Ghanaian Cedi"),
        Currency(id: "gibraltar-pound", symbol: "GIP", locale: "en-GI", name: "Gibraltar Pound"),
        Currency(id: "guatemalan-quetzal", symbol: "GTQ", locale: "es-GT", name: "Guatemalan Quetzal"),
        Currency(id: "hong-kong-dollar", symbol: "HKD", locale: "zh-HK", name: "Hong Kong Dollar"),
        Currency(id: "honduran-lempira", symbol: "HNL", locale: "es-HN", name: "Honduran Lempira"),
        Currency(id: "croatian-kuna", symbol: "HRK", locale: "hr-HR", name: "Croatian Kuna"),
        Currency(id: "hungarian-forint", symbol: "HUF", locale: "hu-HU", name: "Hungarian Forint"),
        Currency(id: "indonesian-rupiah", symbol: "IDR", locale: "id-ID", name: "Indonesian Rupiah"),
        Currency(id: "israeli-new-sheqel", symbol: "ILS", locale: "en-IL", name: "Israeli New Shekel"),
        Currency(id: "indian-rupee", symbol: "INR", locale: "ml-IN", name: "Indian Rupee"),
        Currency(id: "iraqi-dinar", symbol: "IQD", locale: "ar-IQ", name: "Iraqi Dinar"),
        Currency(id: "iranian-rial", symbol: "IRR", locale: "fa-IR", name: "Iranian Rial"),
        Currency(id: "icelandic-króna", symbol: "ISK", locale: "is-IS", name: "Iceland Krona"),
        Currency(id: "jamaican-dollar", symbol: "JMD", locale: "en-JM", name: "Jamaican Dollar"),
        Currency(id: "jordanian-dinar", symbol: "JOD", locale: "ar-JO", name: "Jordanian Dinar"),
        Currency(id: "japanese-yen", symbol: "JPY", locale: "ja-JP", name: "Japanese Yen"),
        Currency(id: "kenyan-shilling", symbol: "KES", locale: "so-KE", name: "Kenyan Shilling"),
        Currency(id: "kyrgystani-som", symbol: "KGS", locale: "ky-KG", name: "Som"),
        Currency(id: "cambodian-riel", symbol: "KHR", locale: "km-KH", name: "Kampuchean Riel"),
        Currency(id: "south-korean-won", symbol: "KRW", locale: "ko-KR", name: "Korean Won"),
        Currency(id: "kuwaiti-dinar", symbol: "KWD", locale: "ar-KW", name: "Kuwaiti Dinar"),
        Currency(id: "kazakhstani-tenge", symbol: "KZT", locale: "kk-KZ", name: "Kazakhstan Tenge"),
        Currency(id: "lebanese-pound", symbol: "LBP", locale: "ar-LB", name: "Lebanese Pound"),
        Currency(id: "sri-lankan-rupee", symbol: "LKR", locale: "ta-LK", name: "Sri Lanka Rupee"),
        // Currency(id: "", symbol: "MAD", locale: "ar-EH", name: "Malagasy Franc"),
        Currency(id: "moldovan-leu", symbol: "MDL", locale: "ro-MD", name: "Moldovan Leu"),
        Currency(id: "malagasy-ariary", symbol: "MGA", locale: "mg-MG", name: "Malagasy Ariary"),
        Currency(id: "myanma-kyat", symbol: "MMK", locale: "my-MM", name: "Myanmar Kyat"),
        Currency(id: "macanese-pataca", symbol: "MOP", locale: "pt-MO", name: "Macau Pataca"),
        Currency(id: "mauritian-rupee", symbol: "MUR", locale: "fr-MU", name: "Mauritius Rupee"),
        Currency(id: "malawian-kwacha", symbol: "MWK", locale: "en-MW", name: "Malawi Kwacha"),
        Currency(id: "mexican-peso", symbol: "MXN", locale: "es-MX", name: "Mexican Nuevo Peso"),
        Currency(id: "malaysian-ringgit", symbol: "MYR", locale: "ta-MY", name: "Malaysian Ringgit"),
        Currency(id: "mozambican-metical", symbol: "MZN", locale: "pt-MZ", name: "Mozambique Metical"),
        Currency(id: "namibian-dollar", symbol: "NAD", locale: "af-NA", name: "Namibian Dollar"),
        Currency(id: "nigerian-naira", symbol: "NGN", locale: "yo-NG", name: "Nigerian Naira"),
        Currency(id: "norwegian-krone", symbol: "NOK", locale: "nn-NO", name: "Norwegian Krone"),
        Currency(id: "nepalese-rupee", symbol: "NPR", locale: "ne-NP", name: "Nepalese Rupee"),
        Currency(id: "new-zealand-dollar", symbol: "NZD", locale: "en-NZ", name: "New Zealand Dollar"),
        Currency(id: "omani-rial", symbol: "OMR", locale: "ar-OM", name: "Omani Rial"),
        Currency(id: "panamanian-balboa", symbol: "PAB", locale: "es-PA", name: "Panamanian Balboa"),
        Currency(id: "peruvian-nuevo-sol", symbol: "PEN", locale: "es-PE", name: "Kampuchean Riel"),
        Currency(id: "philippine-peso", symbol: "PHP", locale: "es-PH", name: "Philippine Peso"),
        Currency(id: "pakistani-rupee", symbol: "PKR", locale: "ur-PK", name: "Pakistan Rupee"),
        Currency(id: "polish-zloty", symbol: "PLN", locale: "pl-PL", name: "Polish Zloty"),
        Currency(id: "paraguayan-guarani", symbol: "PYG", locale: "es-PY", name: "Paraguay Guarani"),
        Currency(id: "qatari-rial", symbol: "QAR", locale: "ar-QA", name: "Qatari Rial"),
        Currency(id: "romanian-leu", symbol: "RON", locale: "ro-RO", name: "Romanian New Leu"),
        Currency(id: "serbian-dinar", symbol: "RSD", locale: "sr-RS", name: "Dinar"),
        Currency(id: "russian-ruble", symbol: "RUB", locale: "ru-RU", name: "Russian Ruble"),
        Currency(id: "rwandan-franc", symbol: "RWF", locale: "rw-RW", name: "Rwanda Franc"),
        Currency(id: "saudi-riyal", symbol: "SAR", locale: "ar-SA", name: "Saudi Riyal"),
        Currency(id: "swedish-krona", symbol: "SEK", locale: "se-SE", name: "Swedish Krona"),
        Currency(id: "singapore-dollar", symbol: "SGD", locale: "zh-SG", name: "Singapore Dollar"),
        Currency(id: "swazi-lilangeni", symbol: "SZL", locale: "en-SZ", name: "Swaziland Lilangeni"),
        Currency(id: "thai-baht", symbol: "THB", locale: "th-TH", name: "Thai Baht"),
        Currency(id: "tunisian-dinar", symbol: "TND", locale: "ar-TN", name: "Tunisian Dollar"),
        Currency(id: "turkish-lira", symbol: "TRY", locale: "tr-TR", name: "Turkish Lira"),
        Currency(id: "trinidad-and-tobago-dollar", symbol: "TTD", locale: "es-TT", name: "Trinidad and Tobago Dollar"),
        Currency(id: "new-taiwan-dollar", symbol: "TWD", locale: "zh-TW", name: "Taiwan Dollar"),
        Currency(id: "tanzanian-shilling", symbol: "TZS", locale: "sw-TZ", name: "Tanzanian Shilling"),
        Currency(id: "ukrainian-hryvnia", symbol: "UAH", locale: "uk-UA", name: "Ukraine Hryvnia"),
        Currency(id: "ugandan-shilling", symbol: "UGX", locale: "sw-UG", name: "Uganda Shilling"),
        Currency(id: "united-states-dollar", symbol: "USD", locale: "en-US", name: "US Dollar"),
        Currency(id: "uruguayan-peso", symbol: "UYU", locale: "es-UY", name: "Uruguayan Peso"),
        Currency(id: "uzbekistan-som", symbol: "UZS", locale: "uz-UZ", name: "Uzbekistan Sum"),
        Currency(id: "venezuelan-bolívar-fuerte", symbol: "VEF", locale: "es-VE", name: "Venezuelan Bolivar"),
        Currency(id: "vietnamese-dong", symbol: "VND", locale: "vi-VN", name: "Vietnamese Dong"),
        Currency(id: "vanuatu-vatu", symbol: "VUV", locale: "fr-VU", name: "Vanuatu Vatu"),
        Currency(id: "cfa-franc-beac", symbol: "XAF", locale: "fr-GA", name: "CFA Franc BEAC"),
        Currency(id: "cfa-franc-bceao", symbol: "XOF", locale: "fr-CI", name: "CFA Franc BCEAO"),
        Currency(id: "south-african-rand", symbol: "ZAR", locale: "zu-ZA", name: "South African Rand"),
        Currency(id: "zambian-kwacha", symbol: "ZMW", locale: "en-ZM", name: "Zambian Kwacha")
    ]

    public class func getDefaultCurrency() -> Currency {
        return Currency(id: "united-states-dollar", symbol: "USD", locale: "en-US", name: "US Dollar")
    }
    
    private class func initialzieCurrenciesDictionary() -> [String: Currency] {
        var currencies: [String: Currency] = [:]
        for currency in Currencies.allCurrenciesList {
            currencies[currency.symbol] = currency
        }

        return currencies
    }
}
