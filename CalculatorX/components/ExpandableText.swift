//
//  ExpandableText.swift
//  CalculatorX
//
//  Created by Hau Nguyen on 15/09/2022.
//

import SwiftUI

struct ExpandableText: View {
    @State private var expanded: Bool = false
    @State private var truncated: Bool = false
    private var text: String
    
    var lineLimit: Int
    
    init(_ text: String, lineLimit: Int) {
        self.text = text
        self.lineLimit = lineLimit
    }
    
    private var moreLessText: String {
        if !truncated {
            return ""
        } else {
            return self.expanded ? "read less" : " read more"
        }
    }
    
    var body: some View {
        VStack(alignment: .trailing) {
            Text(text)
                .lineLimit(expanded ? nil : lineLimit)
                .multilineTextAlignment(.trailing)
                .background(
                    Text(text)
                        .lineLimit(lineLimit)
                        .background(
                            GeometryReader { visibleTextGeometry in
                                ZStack { //large size zstack to contain any size of text
                                    Text(self.text)
                                        .background(GeometryReader { fullTextGeometry in
                                            Color.clear.onAppear {
                                                self.truncated = fullTextGeometry.size.height > visibleTextGeometry.size.height
                                            }
                                        })
                                }
                                .frame(height: .greatestFiniteMagnitude)
                            }
                        )
                        .hidden() //keep hidden
                )
                .contextMenu {
                    Menu("This is a menu") {
                        Button {
                            
                        } label: {
                            Text("Do something")
                        }
                    }
                    
                    Button {
                        
                    } label: {
                        Text("Something")
                    }
                    
                    Divider()
                    
                    Button(role: .destructive) {
                        
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
         
            showMoreButton
        }
    }
    
    @ViewBuilder var showMoreButton: some View {
        if truncated {
            Button(action: {
                withAnimation {
                    expanded.toggle()
                }
            }, label: {
                Text(moreLessText)
            })
        }
    }
}


struct ExpandableText_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading, spacing: 10) {
            ExpandableText("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Sed ut laborum", lineLimit: 6)
            ExpandableText("Small text", lineLimit: 3)
            ExpandableText("Render the limited text and measure its size, R", lineLimit: 1)
            ExpandableText("Create a ZStack with unbounded height to allow the inner Text as much, Render the limited text and measure its size, Hide the background Indicates whether the text has been truncated in its display.", lineLimit: 3)
            
            
        }.padding()
    }
}