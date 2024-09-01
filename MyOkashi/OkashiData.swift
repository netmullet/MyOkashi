//
//  OkashiData.swift
//  MyOkashi
//
//  Created by Otsuka on 2024/07/28.
//
// お菓子データをWeb APIから取得する

import SwiftUI
// ResultJsonからデータを詰め替える構造体、Idetifiableプロトコル
struct OkashiItem: Identifiable {
    let id = UUID()
    let name: String
    let link: URL
    let image: URL
}

// お菓子データ検索用クラス
@Observable class OkashiData {
    // JSONのデータ構造、Codableプロトコル
    struct ResultJson: Codable {
        struct Item: Codable {
            let name: String?
            let url: URL?
            let image: URL?
        }
        // Item構造体の配列
        let item: [Item]?
    }
    
    // OkashiItem型のリスト
    var okashiList: [OkashiItem] = []
    // WebページのURLを格納する変数
    var okashiLink: URL?
    
    func searchOkashi(keyword: String) {
        // 非同期処理を実行
        Task {
            // 非同期で検索処理を実行
            await search(keyword: keyword)
        }
    }
    // メインスレッド
    @MainActor
    // 非同期でお菓子データを取得
    private func search(keyword: String) async {
        // お菓子の検索キーワードをURLエンコードする
        guard let keyword_encode = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        // リクエストURLの組み立て
        guard let req_url = URL(string: "https://www.sysbird.jp/toriko/api/?apikey=guest&format=json&keyword=\(keyword_encode)&max=10&order=r") else {
            return
        }
        
        do {
            // リクエストURLからダウンロード、タプルの宣言、_は使わない値を表す（Data, URLResponse）
            let (data, _) = try await URLSession.shared.data(from: req_url)
            // JSONDecoderのインスタンス生成
            let decoder = JSONDecoder()
            // 受け取ったレスポンスデータをJSONデータにパースして格納
            let json = try decoder.decode(ResultJson.self, from: data)
            
            // jsonデータが存在する場合、items変数に格納
            guard let items = json.item else { return }
            
            // 2回目以降の検索のためにokashiListを初期化
            okashiList.removeAll()
            // for-in文
            for item in items {
                // アンラップ
                if let name = item.name,
                   let link = item.url,
                   let image = item.image {
                    // 1つのお菓子を構造体でまとめて管理
                    let okashi = OkashiItem(name: name, link: link, image: image)
                    // okashiList配列にokashiを追加
                    okashiList.append(okashi)
                }
            }
            print(okashiList)
        } catch {
            print("Error")
        }
    }
}
