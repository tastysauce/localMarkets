//
//  ListRow.swift
//  LocalMarkets
//
//  Created by Michael Koch on 3/9/21.
//  Copyright © 2021 Michael Koch. All rights reserved.
//

import SwiftUI

struct ListRow<Content: View>: View {

    let title: String
    let content: Content

    init(title: String, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        HStack {
            Text(title)
                .bold()
            content
        }
    }
}

struct ListRow_Previews: PreviewProvider {
    static var previews: some View {
        ListRow(title: "Name:") {
            Text("Content")
        }
    }
}
