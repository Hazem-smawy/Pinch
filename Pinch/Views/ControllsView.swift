//
//  ControllsView.swift
//  Pinch
//
//  Created by hazem smawy on 9/5/22.
//

import SwiftUI

struct ControllsView: View {
    let icon :String
    var body: some View {
        Image(systemName: icon)
            .font(.system(size:36))
    }
}

struct ControllsView_Previews: PreviewProvider {
    static var previews: some View {
        ControllsView(icon: "minus.magnifyingglass")
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
