//
//  ContentView.swift
//  Pinch
//
//  Created by hazem smawy on 9/1/22.
//

import SwiftUI

struct ContentView: View {
    //MARK PROPARTY
    @State private var isAnimating :Bool = false
    @State private var imageScale :CGFloat = 1
    @State private var imageOffset:CGSize = .zero
    @State private var isDrawerOpen :Bool = false
    
    let pages :[Page] = pagesData
    @State private var pageIndex:Int = 1
    //MARK FUNCTION
    func restImageState () {
        return withAnimation(.spring()) {
            imageScale = 1
            imageOffset = .zero
        }
    }
    func currentPage() -> String {
        return pages[pageIndex - 1].imageName
    }
    var body: some View {
        NavigationView {
            ZStack {
                
                Color.clear
                //MARK image page
                Image(currentPage())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .shadow(color: .black.opacity(0.2), radius:12 , x: 2, y: 2)
                    .cornerRadius(10)
                    .padding()
                    .opacity(isAnimating ? 1 : 0)
                    .offset(x: imageOffset.width, y: imageOffset.height)
                    .animation(.linear(duration: 1), value: isAnimating)
                    .scaleEffect(imageScale)
                    //MARK -1. tap gesture
                    .onTapGesture(count: 2, perform: {
                        if imageScale == 1 {
                            withAnimation(.spring()) {
                                imageScale = 5
                            }
                        }else {
                            restImageState()
                        }
                    })
                    //MARK -2. DRAG GESTURE
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                withAnimation(.linear(duration: 1)) {
                                    imageOffset = value.translation
                                }
                            }
                            .onEnded { _ in
                               restImageState()
                            }
                    )
                    .gesture(
                        MagnificationGesture()
                            .onChanged { value in
                                withAnimation(.linear(duration: 1)){
                                    if imageScale >= 1 && imageScale <= 5 {
                                        imageScale = value
                                    }else if imageScale > 5 {
                                        imageScale = 5
                                    }
                                }
                            }
                            .onEnded { _ in
                                if imageScale > 5 {
                                    imageScale = 5
                                } else if imageScale <= 1 {
                                    restImageState()
                                }
                            }
                    )
            }//:ZSTAK
            .navigationTitle("Pinch & Zoom")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                isAnimating = true
            }
            .overlay(
                InfoPanelView(scale: imageScale, offset: imageOffset)
                    .padding(.horizontal)
                    .padding(.top,30)
                ,alignment: .top
            )
            .overlay(
                Group{
                    HStack {
                        Button {
                            withAnimation(.spring()){
                                if imageScale > 1 {
                                    imageScale -= 1
                                }
                                if imageScale <= 1 {
                                    restImageState()
                                }
                            }
                        } label: {
                            ControllsView(icon: "minus.magnifyingglass")
                        }
                        Button {
                            restImageState()
                        } label: {
                            ControllsView(icon: "arrow.up.left.and.down.right.magnifyingglass")
                        }
                        Button {
                            withAnimation(.spring()) {
                                if imageScale < 5 {
                                    imageScale += 1
                                }
                                if imageScale > 5 {
                                    imageScale = 5
                                }
                            }
                        } label: {
                            ControllsView(icon: "plus.magnifyingglass")
                        }

                    }
                    .padding(EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20))
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .opacity(isAnimating ? 1 : 0)
                }
                .padding(.bottom,30)
                ,alignment: .bottom
            )
            .overlay(
                HStack(spacing:12) {
                    Image(systemName:isDrawerOpen ?"chevron.compact.right" : "chevron.compact.left")
                        .resizable()
                        .scaledToFit()
                        .frame(height:40)
                        .foregroundColor(.secondary)
                        .padding(8)
                        .onTapGesture(perform: {
                            withAnimation(.easeOut) {
                                isDrawerOpen.toggle()
                            }
                        })
                          
                    ForEach(pages){ item in
                        Image(item.thumbnailName)
                            .resizable()
                            .scaledToFit()
                            .frame(width:80)
                            .cornerRadius(8)
                            .shadow(radius: 4)
                            .opacity(isDrawerOpen ? 1 : 0)
                            .animation(.easeOut(duration:0.5),value:isDrawerOpen)
                            .onTapGesture {
                                isAnimating = true
                                if pageIndex != item.id {
                                    restImageState()
                                }
                                pageIndex = item.id
                            }
                    }
                        
                    Spacer()
                }
                    .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .opacity(isAnimating ? 1 : 0)
                    .frame(width:260)
                    .padding(.top,UIScreen.main.bounds.height / 12)
                    .offset(x: isDrawerOpen ? 20 : 215)
                , alignment:.topTrailing
                
            )
        }//:NAVIGITION
        .navigationViewStyle(.stack)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
        
            ContentView()
                .preferredColorScheme(.light)
        }
    }
}
