# RequestImgDemoMVVM
using MVVM design pattern


### MVVM設計模式 ###

為什麼想用MVVM模式呢？

1. 畫面的邏輯，包在另一個model，不要讓controller太沈重
2. 邏輯行為拆開，在串接其他的controller或是 data會更容易
3. 容易維護與檢測
4. 潮


什麼狀況下會較適合使用？

1. 列表型的畫面（tableview, collection view )
2. 重用性很高的畫面

MVVM架構困難點

1. 在更新資料時，ViewModel更新時，通知畫面做更新
2. code的搬移，哪些該放viewcontroller，哪些該放viewmodel



在更新資料時，ViewModel更新，如何通知畫面更新？


1. 做一個protocol ，數值更新 delegate到vc 做更新
2. 使用KVO方式，如果data更新，view也會更新
3. 利用closure來做畫面更新
4. 使用套件 (RxSwift) 來幫助


第一種是大家很喜歡方法
第二種在oc很棒的方式，但在swift反而比較不常用
第三種可用很快的方式 很懶建立protocol
