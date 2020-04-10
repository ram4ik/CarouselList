//
//  ContentView.swift
//  CarouselList
//
//  Created by Ramill Ibragimov on 10.04.2020.
//  Copyright © 2020 Ramill Ibragimov. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Home()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home: View {
    @State private var x: CGFloat = 0
    @State private var count: CGFloat = 0
    @State private var screen = UIScreen.main.bounds.width - 30
                
    @State var data = [
        Card(id: 0, img: "p0", name: "Jill", show: false),
        Card(id: 1, img: "p1", name: "Emma", show: false),
        Card(id: 2, img: "p2", name: "Catherine", show: false),
        Card(id: 3, img: "p3", name: "Justine", show: false),
        Card(id: 4, img: "p4", name: "Juliana", show: false),
        Card(id: 5, img: "p5", name: "Lilly", show: false),
        Card(id: 6, img: "p6", name: "Moana", show: false),
        Card(id: 7, img: "p7", name: "Emily", show: false),
        Card(id: 8, img: "p0", name: "Jillian", show: false)
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                HStack(spacing: 15) {
                    ForEach(data) { i in
                        CardView(data: i)
                            .offset(x: self.x)
                            .highPriorityGesture(DragGesture()
                                .onChanged({ (value) in
                                    if value.translation.width > 0 {
                                        self.x = value.location.x
                                    } else {
                                        self.x = value.location.x - self.screen
                                    }
                                })
                                .onEnded({ (value) in
                                    if value.translation.width > 0 {
                                        if value.translation.width > ((self.screen - 80) / 2) && Int(self.count) != self.getMid() {
                                            self.count += 1
                                            self.updateHeight(value: Int(self.count))
                                            self.x = (self.screen + 15) * self.count
                                        } else {
                                            self.x = (self.screen + 15) * self.count
                                        }
                                    } else {
                                        if -value.translation.width > ((self.screen - 80) / 2) && -Int(self.count) != self.getMid() {
                                            self.count -= 1
                                            self.updateHeight(value: Int(self.count))
                                            self.x = (self.screen + 15) * self.count
                                        } else {
                                            self.x = (self.screen + 15) * self.count
                                        }
                                    }
                                })
                        )
                    }
                }
                Spacer()
            }
            .background(Color.black.opacity(0.07).edgesIgnoringSafeArea(.all))
            .navigationBarTitle("Profiles Carousel")
            .animation(.spring())
            .onAppear() {
                self.data[self.getMid()].show = true
            }
        }
    }
    
    func getMid() -> Int {
        return data.count / 2
    }
    
    func updateHeight(value: Int) {
        var id: Int
        
        if value < 0 {
            id = -value + getMid()
        } else {
            id = getMid() - value
        }
        
        for i in 0..<data.count {
            data[i].show = false
        }
        
        data[id].show = true
    }
}

struct CardView: View {
    var data: Card
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Image(data.img)
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width - 30, height: data.show ? 460 : 400)
            
            Text(data.name)
                .fontWeight(.bold)
                .padding(.vertical, 13)
                .padding(.horizontal, 70)
                .background(Color.gray.opacity(0.3))
        }
        .background(Color.white)
        .cornerRadius(25)
    }
}

struct Card: Identifiable {
    var id: Int
    var img: String
    var name: String
    var show: Bool
}
