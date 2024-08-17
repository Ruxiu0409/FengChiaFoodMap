//
//  StatementView.swift
//  FengChiaFoodMap
//
//  Created by 蔡承曄 on 2024/8/17.
//

import SwiftUI

let statements: [String] = [
    "「逢甲美食地圖」商家資料皆為團隊人員自網路或地圖搜集，任何資訊仍以現場資料為準。",
    "照片資料皆由團隊人員或使用者拍攝，若有使用其他照片，皆經拍攝者授權授權。",
    "逢甲美食地圖團隊目前人手不足，最新資料無法立刻上架，若有最新資料請至「聯絡我們」聯絡團隊。",
    "當您開始使用本應用程式時，即表示已同意以上聲明。"
]

struct StatementView: View {
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading){
                ForEach(statements.indices,id: \.self){ index in
                    HStack(alignment: .firstTextBaseline){
                        Text("\(String(index+1)). ")
                        Text(statements[index])
                    }
                    .font(.title2)
                    .padding()
                }
                Spacer()
            }
            
            
            .navigationTitle("資料聲明")
        }
    }
}

//struct TextView: UIViewRepresentable {
//    var text: String
//    
//    func makeUIView(context: Context) -> UITextView {
//        let textView = UITextView()
//        textView.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.title2)
//        textView.textAlignment = .justified
//        textView.scrollsToTop = false
//        return textView
//    }
//    
//    func updateUIView(_ uiView: UITextView, context: Context) {
//        uiView.text = text
//    }
//}

#Preview {
    StatementView()
}
