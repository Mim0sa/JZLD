//
//  FlippableCard.swift
//  JZLD
//
//  Created by 吉彦臻 on 2024/10/25.
//

import SwiftUI

struct FlippableCard<Front: View, Back: View>: View {
    
    @Binding var isFront: Bool
    let front: () -> Front
    let back: () -> Back
    @State var isFrontInAnimation: Bool = false
    
    var angle: Double {
        isFront ? 180 : 0
    }
    
    var body: some View {
        ZStack {
            back()
                .rotation3DEffect(.degrees(angle), axis: (x: 0, y: 1, z: 0))
                .opacity(isFrontInAnimation ? 0 : 1)
                .onTapGesture {
                    isFront.toggle()
                }
                .modifier(FlipEffect(flipped: $isFrontInAnimation, angle: angle))
            front()
                .rotation3DEffect(.degrees(angle), axis: (x: 0, y: 1, z: 0))
                .opacity(isFrontInAnimation ? 1 : 0)
                .onTapGesture {
                    isFront.toggle()
                }
                .modifier(FlipEffect(flipped: $isFrontInAnimation, angle: angle))
        }
        .animation(.linear(duration: 0.4), value: isFront)
    }
}

struct FlipEffect: GeometryEffect {
    
    // SwiftUI 的动画就是通过时间函数操作 animatableData 变量
    var animatableData: Double {
        get { angle }
        set { angle = newValue }
    }
    
    @Binding var flipped: Bool  // 绑定卡片当前的状态
    
    var angle: Double  // 翻转角度变量
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        let new = angle >= 90 && angle < 270
        if new != flipped {
            DispatchQueue.main.async {
                flipped = new
            }
        }
        return ProjectionTransform(.identity)
    }
    
}

#Preview {
    @Previewable @State var isFront: Bool = false
    return FlippableCard(isFront: $isFront, front: {
        RoundedRectangle(cornerRadius: 8)
            .fill(.teal)
            .frame(width: 80, height: 120)
    }, back: {
        RoundedRectangle(cornerRadius: 8)
            .fill(.gray)
            .frame(width: 80, height: 120)
    })
}
