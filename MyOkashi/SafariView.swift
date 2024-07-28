//
//  SafariView.swift
//  MyOkashi
//
//  Created by Otsuka on 2024/08/10.
//

import SwiftUI
import SafariServices

// SFSafariViewControllerを起動する構造体
struct SafariView: UIViewControllerRepresentable {
    // ホームページのURLを格納する変数
    let url: URL
    // Viewを生成するタイミングで自動的に実行されるメソッド
    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    // Viewが更新されたときに自動的に実行されるメソッド
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        // 処理なし
    }
}
