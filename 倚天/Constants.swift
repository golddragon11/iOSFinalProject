import Foundation
import UIKit

enum Constants{
    
    static let keyNormalColour: UIColor = .white
    static let keyPressedColour: UIColor = .lightText
    static let specialKeyNormalColour: UIColor = .gray

    static let letterKeys = [
        ["·", "˙", "ˊ", "ˇ", "ˋ", "５", "６", "ㄑ", "ㄢ", "ㄣ", "ㄤ", "ㄥ", "ㄦ"],
        ["ㄚ", "ㄙ", "ㄉ", "ㄈ", "ㄐ","ㄏ", "ㄖ", "ㄎ", "ㄌ", "ㄗ", "ㄘ"],
        ["ㄠ", "ㄨ", "ㄒ", "ㄍ", "ㄅ", "ㄋ", "ㄇ", "ㄓ", "ㄔ", "ㄕ", "⌫"],
        ["123", "space", "↩"]
    ]
    static let numberKeys = [
        ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0",],
        ["-", "/", ":", ";", "(", ")", "$", "@", "「", "」"],
        ["#+=","。", "，", "、", "?", "!", ".", "⌫"],
        ["注音", "space", "↩"]
    ]
    
    static let symbolKeys = [
        ["[", "]", "{", "}", "#", "%", "^", "*", "+", "="],
        ["_", "—", "\\", "|", "~", "", ">", "¥", "&", "·"],
        ["123","···", "，", "^_^", "?", "!", "‘", "⌫"],
        ["注音", "space", "↩"]
    ]
}
