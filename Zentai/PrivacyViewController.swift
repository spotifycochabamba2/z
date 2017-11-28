//
//  PrivacyViewController.swift
//  zentai
//
//  Created by Wilson Balderrama on 11/25/16.
//  Copyright © 2016 Zentai. All rights reserved.
//

import UIKit
import BonMot

class PrivacyViewController: UIViewController {
  @IBOutlet weak var blurView: UIView!
  @IBOutlet weak var upperView: UIView!
  @IBOutlet weak var closeButton: UIButton!
  @IBOutlet weak var textView: UITextView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .clear
    blurView.backgroundColor = .clear
    
    let boldStyle = StringStyle(
      .font(Constants.Font.sfBoldFont!)
    )
    
    let lightStyle = StringStyle(
      .font(Constants.Font.sfLightFont!)
    )
    
    let privacyStyle = StringStyle(
      .color(UIColor.hexStringToUIColor(hex: "#484646")),
      .font(Constants.Font.sfLightFont!),
      .xmlRules([
        XMLStyleRule.style("bold", boldStyle)
        ])
    )
    
    let bulletPoints1 = NSAttributedString.composed(of: [
      Tab.headIndent(10),
      "\u{2022}",
      Tab.headIndent(10),
      "Provision and Monitoring of the Services: We will use your Personal Information to provide you with access to and to support your use of the Services, to administer your account, process payments and to better understand your use of the Services. For example, if you are a Customer, we may provide your Personal Information to a Therapist to facilitate the Therapist’s provision of Services to you and if you are a Therapist, we may provide your Personal Information to a Customer to facilitate the Customer’s receipt of Services. We also may send or facilitate communications between Customers and Therapists. We will also give you the opportunity to store, review and edit Personal Information and other information in your account.\n",
      Tab.headIndent(10),
      "\u{2022}",
      Tab.headIndent(10),
      "Surveys and Other Special Offers: From time to time, we may offer our users the opportunity to participate in surveys and other special offers. If you elect to participate in these services, we will collect certain Personal Information in order to provide you with the surveys and other special offers.\n",
      Tab.headIndent(10),
      "\u{2022}",
      Tab.headIndent(10),
      "Questions and Requests: If you contact us by e-mail or otherwise, we will use the Personal Information you provide to answer your question or resolve your problem.\n",
      Tab.headIndent(10),
      "\u{2022}",
      Tab.headIndent(10),
      "Contacting You About Other Products, Services and Events: If you opt-in, Zentai and/or third parties may use your Personal Information to contact you in the future to tell you about products, services and events that may be of interest to you. You can unsubscribe at any time.\n",
      Tab.headIndent(10),
      "\u{2022}",
      Tab.headIndent(10),
      "Research and Data Analysis: In an ongoing effort to better understand and serve the users of the Services, Zentai may conduct research on its users’ demographics, interests and behavior based on Usage Data and other information. This data may be compiled and analyzed on an aggregate basis, and Zentai may share this data with advertisers, researchers, business partners, publications, and other third parties. This information will not identify you personally.\n",
      Tab.headIndent(10),
      "\u{2022}",
      Tab.headIndent(10),
      "Service Improvement: We may use your Personal Information, aggregated Personal Information and other information collected through the Services to help us improve the content and functionality of the Website or Apps, to better understand our users and to improve the Services.\n\n"
      ], baseStyle: privacyStyle)
    
    //    UIFontTextStyle(
    let string = "Effective Date: Nov 15, 2016 \n\nWelcome to the website and/or mobile application of Ber Dev partners DBA Zentai. (<bold>\"Zentai​\"</bold>, <bold>\"we\"</bold>, <bold>\"us​\"</bold> and/or <bold>\"our​\"</bold>). We have prepared this Privacy Policy to explain how we collect, use, protect and disclose information and data when you use the Zentai website (<bold>\"Website​\"</bold>) and any Zentai software, including any Zentai mobile applications (the <bold>\"App(s)​\"</bold>) or other services offered by Zentai from time to time (collectively, the Website(s), App(s) and services are referred to as <bold>\"Services​\"</bold>). <bold>\"You​\"</bold> refers to you as a user of the Services.\nFor the purpose of the Data Protection Directive 95/46/EC (the Directive), the data controller is Zentai, Inc. of 1. 7083 Hollywood Blvd., Los Angeles, CA 90028, (786) 554-2211.\n<bold>Please read the following carefully to understand our views and practices regarding your personal data and how we will treat it. We draw your attention in particular to International Data Transfer” and “Communications.” BY USING THE SERVICES YOU CONSENT TO THIS PRIVACY POLICY.</bold>\n\n<bold>Background/Managing Your Information Preferences</bold>\n\nZentai provides an online platform that connects Acupuncture therapists (“<bold>Therapists</bold>​”) with individuals that want to purchase and/or receive Acupuncture therapy (“<bold>Customers</bold>​”). You can always review, correct, or update your Personal Information by changing the relevant settings in your Zentai account. Applicable law (such as the Directive) may also give you the right to access, update and correct inaccuracies in information about you in our custody or control. If you wish to exercise this right, please contact us at privacy@zentai.com.\n\n<bold>Communications</bold>\n\nWith your consent, we may send you marketing emails and SMS text messages, such as newsletters, offers and promotions. You can opt out of receiving marketing and promotional emails by changing notification settings on the Website or in our Apps or clicking the unsubscribe mechanism provided in an email or other electronic communication. If you opt out, we may still send you non-marketing emails, SMS text messages or other communications, which include transactional information about your accounts and our business dealings with you. If you have questions or concerns regarding this Privacy Policy, please contact us at privacy@zentai.com.\n\n<bold>Information We Collect</bold>\n\nPersonal Information\nWe collect personally identifiable information, such as your name, username, email address, mailing address, phone number, photo (if you choose to provide it) and other personally identifiable information when you sign up for or use the Services <bold>(“Personal Information​”)</bold>. Personal Information shall, for the purposes of this Privacy Policy include “personal data” as defined in the Directive or as otherwise defined under applicable law. Specifically, Zentai may request that Therapists provide: (i) first and last name, (ii) email address, (iii) mailing address, (iv) phone number, (v) bank account number and routing number, and (v) address of the bank account holder. Zentai may request that Customers provide: (i) first and last name, (ii) email address, (iii) mailing address, (iv) phone number, (v) Acupuncture preferences, and (vi) payment account information such as a credit card number with the name as shown on the card and billing zip or postal code, expiration month and year and CVV2. If you choose not to provide the requested information, you may not be able to use some or all of the features of the Services. We may also collect other Personal Information from you when you access the Services and/or other parts of the Website and/or Apps and elect to provide Personal Information.\nWe also collect transaction details related to your use of the Services, including the service requested, date, time and location where the service was provided, amount charged, and other related transaction details. The Services facilitate communications between Therapists and Customers. In connection with facilitating these communications, we may receive call or SMS message data, including the date and time of the call or SMS message, the parties’ phone numbers, and the content of the SMS message. We use this information solely for the purpose of facilitating such communications.\nOur App may collect certain additional information automatically, including, but not limited to, the type of mobile device you use, your mobile device’s unique device ID, the IP address of your mobile device, your mobile operating system, the type of mobile may also use GPS technology (or other similar technology) to determine your current location. For example, if you permit the App to access location services through the permission system used by your mobile operating system, we may also collect the precise location of your device when the App is running in the foreground or background. We may also determine your approximate location from your IP address.\nUsage Data and Activity\nWe may collect and aggregate information or content about the use of our Website or Apps in a way that does not directly identify an individual user (<bold>“Usage Data​”</bold>). Usage Data helps us understand trends in our users’ needs so that we can better consider new features or otherwise tailor or enhance our Services. This Privacy Policy in no way restricts or limits our collection and use of Usage Data, and we may share Usage Data about our users with our third party service providers for various purposes, including to help us better understand our customers’ needs and improve our Services. For example, each time you use the Website or Apps, we may automatically collect the type of Web browser you use, the pages you view, how you interact with links on the Services and the time and duration of your use of the Website or Apps. We may use such information and pool it with other information to track, for example, the total number of visitors to our Website or users of the Apps, the number of visitors to each page of our Website, number of App downloads, aggregated details related to use of the Services etc.\nCookies and Web Beacons\nWe use cookies (a small text file placed on your computer to identify your computer and browser). We may also use Web beacons (a file placed on a website that monitors usage). We may use both session cookies (which expire once you close your web browser) and persistent cookies (which stay on your computer until you delete them) to provide you with a more personal and interactive experience on our Site. We use cookies and Web beacons to improve the experience of the Website and Services, such as pre-populating your username for easier login. Most Web browsers are initially set up to accept cookies. At this time, Zentai does not recognize automated browser signals regarding tracking, including “do-not-track” signals. However, you can opt-out of interest-based advertisements by following the instructions under “Interest-Based Advertising” below. You can remove persistent cookies and change your privacy preferences by following directions provided in your Internet browser’s “help” directory. However, certain features of the Services may not work if you delete or disable cookies. Some of our Service Providers may use their own cookies and Web beacons in connection with the services they perform on our behalf, as further explained below.\n\n<bold>How We Use Information and When We May Share and Disclose Information Generally</bold>\n\nWe may use your Personal Information for the purpose for which it was provided, including without limitation for the purposes described further below:\n"
    
    let string2 = "<bold>Information You Make Available to Others</bold>\n\nBy using the Services, including creation of a profile on Zentai or submission of public queries, you may make certain of your Personal Information available to others, such as your name, your username, and your picture. This information may be accessed by users who use the Services and may be accessed by commercial search engines. You should exercise caution before posting any Personal Information on a public area of the Services.\n\n<bold>Service Providers</bold>\n\nFrom time to time, we may establish a business relationship with other businesses that we believe to be trustworthy and have privacy practices consistent with ours, including our affiliates (<bold>“Service Providers​”</bold>). For example, we may contract with Service Providers to provide certain services, such as hosting and maintenance, payment processing, data storage and management, marketing and promotions and customer research/analytics. We only provide our Service Providers with the information necessary for them to perform these services on our behalf. Each Service Provider must agree to use reasonable security procedures and practices, appropriate to the nature of the information involved, in order to protect your Personal Information from unauthorized access, use or disclosure. Service Providers are prohibited from using or disclosing Personal Information other than as specified by Zentai.\n\n<bold>Interest-Based Advertising</bold>\n\nWe may use third party advertising companies to serve advertisements on our behalf on our and other websites across the Internet, and to track and report on the performance of those advertisements. These entities may use cookies, web beacons and other technologies to identify your device when you use the Services and to report certain information about your visits to our Services and other websites (such as web pages you visit and your response to ads) in order to measure the effectiveness of our marketing campaigns and to deliver ads that are more relevant to you, both on and off our Services. We do not share your Personal Information with third parties for the third parties’ direct marketing purposes unless you provide us with consent to do so. For Canadian users, to learn more and to opt-out of having your information used by these companies for online behavioral advertising purposes, please visit the Digital Advertising Alliance of Canada at http://youradchoices.ca/choices\n\n<bold>Other Transfers</bold>\n\nWe may share Personal Information and Usage Data with businesses controlling, controlled by, or under common control with Zentai. If Zentai is merged, acquired, or sold, or in the event of a transfer of some or all of our assets or equity, we may disclose or transfer Personal Information and Usage Data in connection with such prospective or completed transaction.\n\n<bold>Compliance with Laws and Law Enforcement</bold>\n\nZentai and its Service Providers may disclose Personal Information to applicable US, UK, Canadian or other regulatory, government or law enforcement officials, courts or private parties if, in our discretion, we believe it is necessary or appropriate in order to respond to legal requests (including court orders and subpoenas), to protect the safety, property or rights of Zentai or of any third party, to prevent or stop any illegal, fraudulent, unethical, or legally actionable activity, or where required or permitted under applicable US, UK, Canadian or other foreign law.\n\n<bold>Be Careful When You Share Information with Others</bold>\n\nPlease be aware that whenever you share information on a publicly available page or any other public forum, others may access that information. In addition, please remember that when you share information in any other communications with third parties, that information may be passed along or made public by others. This means that anyone with access to such information can potentially use it for any purpose, including sending unsolicited communications. You should exercise caution before posting any Personal Information on a public available page.\n\n<bold>Exclusions</bold>\n\nThis Privacy Policy shall not apply to any unsolicited information you provide to Zentai through the Services or through any other means. This includes, but is not limited to, information posted to any public areas of the Website, such as bulletin boards, any ideas for new products or modifications to existing products, and other unsolicited submissions (collectively, <bold>“Unsolicited Information​”</bold>). All Unsolicited Information shall be deemed to be non-confidential and Zentai shall be free, and you hereby grant Zentai the right, to reproduce, use, disclose, and distribute such Unsolicited Information to others without limitation or attribution.\n\n<bold>Security</bold>\n\nWe maintain reasonable physical, electronic, and procedural safeguards in an effort to protect the confidentiality and security of Personal Information in our custody and control. However, no data transmission over the Internet or other network can be guaranteed to be 100% secure. As a result, while we strive to protect information transmitted on or through the Services, we cannot and do not guarantee the security of any information you transmit on or through the Services, and you do so at your own risk.\n\n<bold>Links</bold>\n\nOur Website and Apps may contain links or integrate with other websites and online services. Zentai is not responsible or liable for any damage or loss related to your use of any third-party website or online service or for the privacy practices of such third parties. You should always read the terms and conditions and privacy policy of a third-party website or online service before using it, whether directly or in connection with your use of the Services.\n\n<bold>Children’s Privacy</bold>\n\nWe do not knowingly collect Personal Information from children under the age of 13. If we become aware that we have inadvertently received Personal Information from a child under the age of 13, we will delete such information from our records.\n\n<bold>International Data Transfer</bold>\n\nPlease be aware that your Personal Information and communications may be transferred to, stored at, processed and maintained on servers or databases located outside your jurisdiction of residence (such as outside of the EEA), including, but not limited to the United States, where data protection and privacy regulations may not offer the same level of protection as in other parts of the world. By using this Site, you agree to this transfer, storing and/or processing. We will take all steps reasonably necessary to ensure that your data is treated securely and in accordance with this Privacy Policy. Unfortunately, the transmission of information via the internet is not completely secure. Although we will do our best to protect your personal data, we cannot guarantee the security of your data transmitted to our site; any transmission is at your own risk. Once we have received your information, we will use strict procedures and security features in an effort to prevent loss, theft and unauthorized access, use and disclosure.\n\n<bold>Privacy Policy Changes</bold>\n\nFrom time to time, we may change this Privacy Policy. If we change this Privacy Policy, we will give you notice by posting the revised Privacy Policy on the Website and Apps and sending an email notice to you using the contact information provided by you. Those changes will go into effect on the effective date shown in the revised Privacy Policy. By continuing to use the Services, you consent to the revised Privacy Policy. <bold>PLEASE PRINT A COPY OF THIS PRIVACY POLICY FOR YOU RECORDS AND PLEASE CHECK THE WEBSITE FREQUENTLY FOR ANY CHANGES TO THIS PRIVACY POLICY.</bold>"
    
    
    let attributedString1 = string.styled(with: privacyStyle)
    let attributedString2 = string2.styled(with: privacyStyle)
    
    let combination = NSMutableAttributedString()
    combination.append(attributedString1)
    combination.append(bulletPoints1)
    combination.append(attributedString2)
    //
    //    "".
    
    
    //
    //
    //    let combination = NSMutableAttributedString()
    //    combination.append(string3)
    //    combination.append(attributedString3)
    //    combination.append(string4)
    //    combination.append(attributedString4)
    //    combination.append(string5)
    //    combination.append(attributedString5)
    //    combination.append(string6)
    //    combination.append(attributedString6)
    //    combination.append(string7)
    //    combination.append(attributedString7)
    //    combination.append(string8)
    //    combination.append(attributedString8)
    //    combination.append(string9)
    //    combination.append(attributedString9)
    //    combination.append(string10)
    //    combination.append(attributedString10)
    //    combination.append(string11)
    //    combination.append(attributedString11)
    //    combination.append(string12)
    //    combination.append(attributedString12)
    //    combination.append(string13)
    //    combination.append(attributedString13)
    //    combination.append(string14)
    //    combination.append(attributedString14)
    //    combination.append(string15)
    //    combination.append(attributedString15)
    //    combination.append(string16)
    //    combination.append(attributedString16)
    //    combination.append(string17)
    
    textView.attributedText = combination
    
    blurView.makeMeBlur()
    
    textView.isScrollEnabled = false
    
    let viewTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
    viewTapGestureRecognizer.numberOfTapsRequired = 1
    viewTapGestureRecognizer.numberOfTouchesRequired = 1
    view.addGestureRecognizer(viewTapGestureRecognizer)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    textView.isScrollEnabled = true
    //    textView.isSelectable = false
  }
  
  func viewTapped() {
    dismiss(animated: true, completion: nil)
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    let maskPath: UIBezierPath = UIBezierPath(roundedRect: self.closeButton.bounds, byRoundingCorners: ([.bottomLeft, .bottomRight]), cornerRadii: CGSize(width: 5.0, height: 5.0))
    let maskLayer: CAShapeLayer = CAShapeLayer()
    maskLayer.frame = self.closeButton.bounds
    maskLayer.path = maskPath.cgPath
    self.closeButton.layer.mask = maskLayer
    
    
    upperView.makeMeRounded()
    upperView.applyBlackTransparentShadow()
  }
  
  @IBAction func closeButtonTouched() {
    dismiss(animated: true, completion: nil)
  }
}
