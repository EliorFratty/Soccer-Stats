//
//  RulesPopUpView.swift
//  Soccer
//
//  Created by User on 16/10/2019.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit

class RulesPopUpView: UIView {
    
    let containerWidth =  UIScreen.main.bounds.width * 0.75
    let containerHeight = UIScreen.main.bounds.height * 0.45
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.gray.withAlphaComponent(0.6)
        
        setupTapGestureRecognizer()
        
        addSubview(container)
        
        animateIn()
        setupAnchors()
    }
    
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.alwaysBounceVertical = true
        sv.backgroundColor = UIColor.clear
        sv.bounces = false
        sv.showsVerticalScrollIndicator = false
        
        return sv
    }()
    
    fileprivate let container: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 24
        return v
    }()

    lazy var messageTextFiled: UITextView = {
        let tv = UITextView()
        tv.layer.borderWidth = 1
        tv.layer.borderColor = UIColor.lightGray.cgColor
        tv.layer.cornerRadius = 5
        tv.attributedText = attributedText()
        
        return tv
    }()

    
    func setupAnchors(){
        
        container.centerInSuperview(size: CGSize(width: containerWidth, height: containerHeight))
        
        container.addSubviews(scrollView, messageTextFiled)
        scrollView.anchor(top: container.topAnchor, leading: container.leadingAnchor, bottom: container.bottomAnchor, trailing: container.trailingAnchor)
        
      //  scrollView.addSubview(messageTextFiled)
        messageTextFiled.anchor(top: scrollView.topAnchor, leading: scrollView.leadingAnchor, bottom: scrollView.bottomAnchor, trailing: scrollView.trailingAnchor)
   
    }
    
    func attributedText() -> NSAttributedString {
        
        let string = """
        
        איזו קבוצה משחקת ראשונה?
        * שתי הקבוצות שהכי הרבה שחקנים שלהן כבר הגיעו.
        * במידה ויש צורך בהכרעה, מבצעים משחקון משלוש יוצא אחד (האחד משחק) ולאחר מכן משחקון זוג או פרט.
        
        מי שוער?
        * שחקן א’ מהקבוצה מחלק לכל שחקן בקבוצה מספר. שחקן ב’ מבקש משחקן רחוק מקבוצה אחרת שיבחר מספר (מ-1 עד 5, אם מדובר ב-5 על 5 וכן הלאה) וכך נקבע סדר העמידה.
        * כל שחקן עומד במשך משחק שלם, ללא קשר לכמות השערים שספג.
        * שחקן שלא יכול לעמוד – יוצא בתורו למשחק אחד החוצה, אלא אם שחקן מהקבוצה שלו מסכים לעמוד במקומו.
        * שחקן שהתעייף ונכנס לשער, עדיין מחויב לעמוד בתורו, אלא אם סיכם אחרת עם המוחלף.
        
        כמה זמן?
        כדורגל בשכונה משחקים 8\\10 דקות (על פי כמות הקבוצות). 2 דקות הארכה במקרה של תיקו.
        
        ואם נגמר תיקו?
        שיטת פנדלים רגילה ומייגעת.

        התקפה אחרונה
        * מסתיימת כאשר נגמר הזמן

        שחקן מחליף
        במידה ושחקן נפצע במהלך המשחק, יש להכניס במקומו שחקן ברמת בחירה מקבילה לשחקן שיצא.
        
        שוער תגבור
        במידה ולקבוצה חסר שחקן באופן קבוע, יש לבחור שוער סביר לכל הדעות מהקבוצה המזמינה. כדי להיות ברורים, ניתן לקבוע כי לקבוצה היריבה יש זכות וטו אחת על שחקן אחד שלא יוכל להיות שוער מתגבר. השוער יוכל לקחת חלק פעיל בדו-קרב פנדלים, במידה ויתקיים כזה.
        
        שוער עולה
        שוער הוא שחקן לכל דבר ועניין. אלא אם מדובר במגרש קטן באופן חריג, אז יש להגביל את השוער לבעיטה לפני קו מחצית המגרש בלבד.
        
        חוצים
        * תמיד משחקים עם חוצים. אנחנו כבר מזמן לא בני 15 ואין לנו אוויר לשטויות האלה.
        * חוץ מוציאים ביד
        * על השחקן היריב לשמור מרחק של רדיוס שני צעדים ממוציא החוצה.
        
        נגיעת יד
        * כל כדור צמוד לגוף – לא נחשב ליד.
        * במידה ויש ספק, השחקן שכביכול נגע ביד הוא זה שקובע אם הוא נגע או לא.
        * אין צורך בשתי נגיעות בבעיטה.
        * שוער לא יכול לתפוס ביד מסירת רגל מכוונת שקיבל משחקן מהקבוצה שלו. במידה ויעשה זאת, תזכה הקבוצה היריבה בכדור חופשי בלתי ישיר (שתי נגיעות).
        * במידה ושחקן מונע בעזרת היד שער של 100% (סוארז סטייל), מדובר בגול לקבוצה התוקפת. זאת מאחר שבשכונה אין הרחקות.
        
        פאול
        * ביקשת, קיבלת.
        * על השחקן שהוכשל להגיד “פאול” או “עבירה” תוך 3 שניות מביצוע העבירה. צעקות ויבבות כמו “איי” “איה” “אאוץ'” או “מה זה?!” לא יתקבלו כלל.
             
        בעיטה חופשית
        * על החומה לעמוד כשלושה צעדים מהכדור, על פי אורך הרגליים של השחקן הבועט.
        * אסור לעמוד מאחורי הכדור.
        * אם השוער רוצה לסדר חומה, שיבקש. אחרת הכל חוקי.
        
        """ as NSString
        
        let attributedString = NSMutableAttributedString(string: string as String, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 18.0)])
        
        let boldFontAttribute = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20.0)]
        
        // Part of string to be bold
        attributedString.addAttributes(boldFontAttribute, range: string.range(of: "איזו קבוצה משחקת ראשונה?"))
        attributedString.addAttributes(boldFontAttribute, range: string.range(of: "בעיטה חופשית"))
        attributedString.addAttributes(boldFontAttribute, range: string.range(of: "ואם נגמר תיקו"))
        attributedString.addAttributes(boldFontAttribute, range: string.range(of:  "נגיעת יד"))
        attributedString.addAttributes(boldFontAttribute, range: string.range(of: "שוער תגבור"))
        attributedString.addAttributes(boldFontAttribute, range: string.range(of: "שחקן מחליף"))
        attributedString.addAttributes(boldFontAttribute, range: string.range(of: "חוצים"))
        attributedString.addAttributes(boldFontAttribute, range: string.range(of: "שוער עולה"))
        attributedString.addAttributes(boldFontAttribute, range: string.range(of: "פאול"))
        attributedString.addAttributes(boldFontAttribute, range: string.range(of: "מי שוער?"))
        attributedString.addAttributes(boldFontAttribute, range: string.range(of: "כמה זמן?"))
        attributedString.addAttributes(boldFontAttribute, range: string.range(of: "התקפה אחרונה"))
        attributedString.addAttributes(boldFontAttribute, range: string.range(of: "חוצים"))

        return attributedString
    }
    
    @objc fileprivate func animateOut() {
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.container.transform = CGAffineTransform(translationX: 0, y: +self.frame.height)
            self.alpha = 0
        }) { (complete) in
            if complete {
                self.removeFromSuperview()
            }
        }
    }
    
    @objc fileprivate func animateIn() {
        self.container.transform = CGAffineTransform(translationX: 0, y: +self.frame.height)
        self.alpha = 1
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.container.transform = .identity
            self.alpha = 1
        })
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


extension RulesPopUpView: UIGestureRecognizerDelegate{
    
    func setupTapGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(animateOut))
        tap.delegate = self
        self.addGestureRecognizer(tap)
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view == container {
            return false
        }
        return true
    }
    
}
