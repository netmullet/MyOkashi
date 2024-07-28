//
//  ContentView.swift
//  MyOkashi
//
//  Created by Otsuka on 2024/07/28.
//

import SwiftUI

struct ContentView: View {
    // OkashiDataクラスのインスタンスを生成
    var okashiDataList = OkashiData()
    
    @State var inputText = ""
    // SafariViewの表示有無を管理する変数
    @State var isShowSafari = false
    
    var body: some View {
        VStack {
            TextField("キーワード", text: $inputText, prompt: Text("キーワードを入力してください"))
                .onSubmit {
                    okashiDataList.searchOkashi(keyword: inputText)
                }
                // キーボードの改行を検索に変更する
                .submitLabel(.search)
                .padding()
            
            List(okashiDataList.okashiList) { okashi in
                
                Button {
                    okashiDataList.okashiLink = okashi.link
                    
                    isShowSafari.toggle()
                } label: {
                    HStack {
                        // 画像を非同期で読み込む
                        AsyncImage(url: okashi.image) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(height: 40)
                        } placeholder: {
                            // 画像読み込み中（非同期処理中）はインジケータを表示する
                            ProgressView()
                        }
                        Text(okashi.name)
                    }
                }
            }
            .sheet(isPresented: $isShowSafari, content: {
                SafariView(url: okashiDataList.okashiLink!)
                    .ignoresSafeArea(edges: [.bottom])
            })
        }
    }
}

#Preview {
    ContentView()
}
