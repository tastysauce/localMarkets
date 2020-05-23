//
//  MarketsAPIClient+Testing.swift
//  LocalMarkets
//
//  Created by Michael Koch on 5/23/20.
//  Copyright © 2020 Michael Koch. All rights reserved.
//

import Foundation

extension MarketsAPIClient {

    static let fullMarketsPrefilledData = """
    {
        "results": [
            {"id":"1011488","marketname":"1.8 Belmont Certified Farmers' Market"},
            {"id":"1011494","marketname":"2.4 San Mateo @ 25th Ave. Certified Farmers' Market"},
            {"id":"1007861","marketname":"2.5 San Carlos CFM"},
            {"id":"1011495","marketname":"2.5 College of San Mateo Certified Farmers' Market"},
            {"id":"1007859","marketname":"2.5 San Mateo Event Center CFM"},
            {"id":"1005620","marketname":"4.0 PJCC Farmers' Market at Foster City"},
            {"id":"1007863","marketname":"4.1 Urban Table Certified Farmer's Market"},
            {"id":"1000791","marketname":"4.2 Redwood City Kiwanis Farmers Market"},
            {"id":"1011485","marketname":"4.6 Kaiser Redwood City Certified Farmers' Market"},
            {"id":"1005322","marketname":"5.2 Burlingame Fresh Market Farmers Market"},
            {"id":"1007860","marketname":"6.2 The Fresh Market Burlingame (2)"},
            {"id":"1002905","marketname":"7.7 Menlo Park Farmers' Market"},
            {"id":"1018163","marketname":"7.7 Coastside Farmers' Market - Half Moon Bay "},
            {"id":"1003182","marketname":"7.9 Millbrae Farmers Market"},
            {"id":"1019721","marketname":"9.1 Downtown Palo Alto Farmers' Market"},
            {"id":"1000291","marketname":"9.3 Stanford CFM"},
            {"id":"1005342","marketname":"9.7 East Palo Alto Community Farmers Market"},
            {"id":"1006596","marketname":"10.8 San Bruno Farmers' Market"},
            {"id":"1011498","marketname":"11.5 VA Palo Alto Farmers' Market"}
        ]
    }
    """.data(using: .utf8)!

    // Matches the # of entries in partialMarketDetailsPrefilledData
    static let partialMarketsPrefilledData = """
    {
        "results": [
               {"id":"1011488","marketname":"1.8 Belmont Certified Farmers' Market"},
               {"id":"1011494","marketname":"2.4 San Mateo @ 25th Ave. Certified Farmers' Market"},
               {"id":"1007861","marketname":"2.5 San Carlos CFM"},
               {"id":"1011495","marketname":"2.5 College of San Mateo Certified Farmers' Market"},
               {"id":"1007859","marketname":"2.5 San Mateo Event Center CFM"}
        ]
    }
    """.data(using: .utf8)!

    static let partialMarketDetailsPrefilledData = """
    {
        "marketdetails": {
            "Address": "El Camino Real and O'Neill St., Belmont, California, 94002",
            "GoogleLink": "http://maps.google.com/?q=37.518818%2C%20-122.2736%20(%22Belmont+Certified+Farmers'+Market%22)",
            "Products": "Baked goods; Cut flowers; Eggs; Fish and/or seafood; Fresh fruit and vegetables; Fresh and/or dried herbs; Honey; Meat; Plants in containers",
            "Schedule": "01/01/2015 to 12/31/2015 Sun: 9:00 AM-1:00 PM;<br> <br> <br> "
        }
    }
    {
        "marketdetails": {
            "Address": "25th Ave. and Hacienda St., San Mateo, California, 94403",
            "GoogleLink": "http://maps.google.com/?q=37.543846%2C%20-122.30961%20(%22San+Mateo+%40+25th+Ave.+Certified+Farmers'+Market%22)",
            "Products": "Eggs; Fish and/or seafood; Fresh fruit and vegetables; Honey; Nuts; Prepared foods (for immediate consumption)",
            "Schedule": "05/05/2015 to 10/13/2015 Tue: 4:00 PM-7:30 PM;<br> <br> <br> "
        }
    }
    {
        "marketdetails": {
            "Address": "Laurel St btwn Olive & cherry, San Carlos, California",
            "GoogleLink": "http://maps.google.com/?q=37.504299%2C%20-122.259%20(%22San+Carlos+CFM%22)",
            "Products": "",
            "Schedule": " <br> <br> <br> "
        }
    }
    {
        "marketdetails": {
            "Address": "1700 W. Hillsdale Blvd., San Mateo , California, 94403",
            "GoogleLink": "http://maps.google.com/?q=37.533092%2C%20-122.33785%20(%22College+of+San+Mateo+Certified+Farmers'+Market%22)",
            "Products": "Baked goods; Cheese and/or dairy products; Crafts and/or woodworking items; Cut flowers; Eggs; Fish and/or seafood; Fresh fruit and vegetables; Fresh and/or dried herbs; Honey; Canned or preserved fruits, vegetables, jams, jellies, preserves, salsas, pickles, dried fruit, etc.; Meat; Nuts; Poultry; Prepared foods (for immediate consumption); Soap and/or body care products; Trees, shrubs; Wine, beer, hard cider",
            "Schedule": "01/01/2015 to 12/31/2015 Sat: 9:00 AM-1:00 PM;<br> <br> <br> "
        }
    }
    {
        "marketdetails": {
            "Address": "2495 South Delaware Street, San Mateo Event Center, San Mateo, California",
            "GoogleLink": "http://maps.google.com/?q=37.546001%2C%20-122.303%20(%22San+Mateo+Event+Center+CFM%22)",
            "Products": "",
            "Schedule": " <br> <br> <br> "
        }
    }
    """.data(using: .utf8)!

}
