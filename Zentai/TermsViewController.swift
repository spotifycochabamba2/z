//
//  TermsViewController.swift
//  zentai
//
//  Created by Wilson Balderrama on 11/25/16.
//  Copyright © 2016 Zentai. All rights reserved.
//

import UIKit
import BonMot

class TermsViewController: UIViewController {
  @IBOutlet weak var blurView: UIView!
  @IBOutlet weak var upperView: UIView!
  @IBOutlet weak var closeButton: UIButton!
  @IBOutlet weak var textView: UITextView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
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
    
    let string3 = NSAttributedString.composed(of: [
      "Effective Date: Nov 15, 2016\n\n",
      "1",
      Tab.headIndent(22),
      ], baseStyle: privacyStyle)
    
    let attributedString3 = "Our Terms".styled(with: privacyStyle, .underline(.styleDouble, UIColor.hexStringToUIColor(hex: "#484646")))
    
    let attributedString4 = "<bold>Information about Zentai and contact details</bold>".styled(with: privacyStyle, .underline(.styleDouble, UIColor.hexStringToUIColor(hex: "#484646")))
    
    let attributedString5 = "<bold>Changes to the Site and these Terms</bold>".styled(with: privacyStyle, .underline(.styleDouble, UIColor.hexStringToUIColor(hex: "#484646")))
    
    let attributedString6 = "<bold>Service Description and Participation/Account Creation/Eligibility</bold>".styled(with: privacyStyle, .underline(.styleDouble, UIColor.hexStringToUIColor(hex: "#484646")))
    
    let attributedString7 = "<bold>Acceptable Use</bold>".styled(with: privacyStyle, .underline(.styleDouble, UIColor.hexStringToUIColor(hex: "#484646")))
    
    let attributedString8 = "<bold>Mobile Application License</bold>".styled(with: privacyStyle, .underline(.styleDouble, UIColor.hexStringToUIColor(hex: "#484646")))
    
    let attributedString9 = "<bold>Payments, Cancellation and Rescheduling</bold>".styled(with: privacyStyle, .underline(.styleDouble, UIColor.hexStringToUIColor(hex: "#484646")))
    
    let attributedString10 = "<bold>Ownership and Copyright</bold>".styled(with: privacyStyle, .underline(.styleDouble, UIColor.hexStringToUIColor(hex: "#484646")))
    
    let attributedString11 = "<bold>Our Responsibility for Loss or Damage TO INDIVIDUAL CUSTOMERS THE LAWS OF CERTAIN JURISDICTIONS DO NOT ALLOW THE  EXCLUSION OR LIMITATION OF LEGAL WARRANTIES, CONDITIONS,  LIABILITY OR CERTAIN DAMAGES OR LIMITATIONS OF  REPRESENTATIONS MADE CONCERNING GOODS OR SERVICES. IF  THESE LAWS APPLY TO YOU, SOME OR ALL OF THE BELOW  EXCLUSIONS OR LIMITATIONS MAY NOT APPLY TO YOU.</bold>".styled(with: privacyStyle, .underline(.styleDouble, UIColor.hexStringToUIColor(hex: "#484646")))
    
    let attributedString12 = "<bold>TO CORPORATE CUSTOMERS AND THERAPISTS</bold>".styled(with: privacyStyle, .underline(.styleDouble, UIColor.hexStringToUIColor(hex: "#484646")))
    
    let attributedString13 = "<bold>TO INDIVIDUAL CUSTOMERS, CORPORATE CUSTOMERS AND THERAPISTS</bold>".styled(with: privacyStyle, .underline(.styleDouble, UIColor.hexStringToUIColor(hex: "#484646")))
    
    let attributedString14 = "<bold>Third Party Links and App Store</bold>".styled(with: privacyStyle, .underline(.styleDouble, UIColor.hexStringToUIColor(hex: "#484646")))
    
    let attributedString15 = "<bold>Termination</bold>".styled(with: privacyStyle, .underline(.styleDouble, UIColor.hexStringToUIColor(hex: "#484646")))
    
    let attributedString16 = "<bold>Other Important Terms</bold>".styled(with: privacyStyle, .underline(.styleDouble, UIColor.hexStringToUIColor(hex: "#484646")))
    
    let string4 = NSAttributedString.composed(of: [
      "\n1.1",
      Tab.headIndent(14),
      "IMPORTANT — THIS AGREEMENT (<bold>“AGREEMENT​</bold>”) IS A LEGAL AGREEMENT BETWEEN YOU (EITHER AN INDIVIDUAL OR ENTITY) (<bold>“YOU​”</bold> OR “YOUR​”) AND BER DEV PARTNERS DBA ZENTAI. (HEREINAFTER <bold>“ZENTAI​,”</bold> <bold>“WE​”</bold>, <bold>“US​”</bold> OR <bold>“OUR​”</bold>) THAT SETS FORTH THE LEGAL TERMS AND CONDITIONS FOR YOUR ACCESS TO AND USE OF WWW.ZENTAIWELLNESS.COM AND ANY OTHER WEBSITE OWNED AND OPERATED BY ZENTAI (THE <bold>“WEBSITE(S)​”</bold> OR <bold>“SITE(S)​”</bold>) AND ANY ZENTAI SOFTWARE, INCLUDING ANY ZENTAI MOBILE APPLICATIONS (THE “APP(S)​”) OR OTHER SERVICES OFFERED BY ZENTAI FROM TIME TO TIME A (COLLECTIVELY, THE WEBSITE(S), APP(S) AND SERVICES ARE REFERRED TO AS <bold>“SERVICE(S)​”</bold>).\n",
      "1.2",
      Tab.headIndent(14),
      "<bold>Which terms will govern you? DEPENDING UPON THE JURISDICTION IN WHICH YOU ARE LOCATED, DIFFERENT TERMS THROUGHOUT THIS DOCUMENT WILL APPLY TO YOU. FOR EXAMPLE, IF YOU ARE A USER LOCATED WITHIN THE UNITED STATES OR CANADA ACCESSING THE SERVICE(S), THE MANDATORY ARBITRATION LANGUAGE INCLUDED IN SECTION 12.6 BELOW WILL APPLY.</bold>\n",
      "1.3",
      Tab.headIndent(14),
      "Why should you read these Terms?​ These terms create a legally binding agreement between you and us. By accessing or using the Site, you are accepting this Agreement and agreeing to use the Services in accordance with the terms and conditions in this Agreement. Some of our Services may have additional rules, policies, and procedures. Where such additional terms apply, we will make them available for you. A copy of these Terms and Conditions may be downloaded, saved and printed for your reference.\n",
      "1.4",
      Tab.headIndent(14),
      "<bold>You confirm that you can enter the Agreement.</bold>​ As a condition of your use of the Services, you confirm and warrant to us that you meet the eligibility requirements set out in Section 4.3 and have the right, authority, and capacity to enter into these terms or, if you are under the age of majority in your jurisdiction of residence, you have have obtained the consent of your parent or legal guardian to this Agreement,.\n",
      "1.5",
      Tab.headIndent(14),
      "<bold>Which provisions of the terms should you pay particular attention to?​</bold> Thekey terms that you should consider in particular detail are: <bold>3. Changes to the Site and these Terms;​ 9. Our responsibility for loss or damage;​</bold> and <bold>11.Termination​</bold>.\n",
      "1.6",
      Tab.headIndent(14),
      "<bold>What to do if you don’t want to accept these terms?</bold>​ If you do not agree with all of the provisions of these terms, do not access and/or use the Services.\n",
      "2",
      Tab.headIndent(22)
      
      ], baseStyle: privacyStyle)
    
    let string5 = NSAttributedString.composed(of: [
      "\n2.1",
      Tab.headIndent(14),
      "<bold>Who we are​.</bold> Zentai is a company registered in California, USA.\n",
      "2.2",
      Tab.headIndent(14),
      "Where we are based​. Our registered office is at 7083 Hollywood Blvd., Los  Angeles, CA 90028.\n",
      "2.3",
      Tab.headIndent(14),
      "How to contact us​. You can contact us by writing to us at 7998 Santa Monica Blvd., West Hollywood, CA 90046, or calling us on (800) 960-7668.\n",
      "2.4",
      Tab.headIndent(14),
      "How we may contact you​. If we have to contact you we may do so by telephone or by email to the number and/or address you provided when you registered for an Account.\n",
      "2.5",
      Tab.headIndent(14),
      "mail counts as “in writing”​. When we use the words “writing” or “written” inthese Terms, this includes emails. For contractual purposes, you consent to receiving communications from Zentai by email.\n",
      "3",
      Tab.headIndent(22)
      ], baseStyle: privacyStyle)
    
    let string6 = NSAttributedString.composed(of: [
      "\n3.1",
      Tab.headIndent(14),
      "<bold>Small changes​.</bold>We reserve the right to change the terms and conditions of this Agreement or to modify or discontinue the Services offered by Zentai at anytime. Those changes will go into effect on the effective date shown in the revised agreement. If we change this Agreement, we will give you notice by posting the revised agreement on the applicable website(s) or app(s) and sending an email notice to you using the contact information provided by you. Therefore, you agree to keep your contact information up-to-date and that notice sent to the last email address you provided shall be considered effective. We also encourage you to check this Agreement from time to time to see if it has been updated.\n",
      "3.2",
      Tab.headIndent(14),
      "<bold>More significant changes​.</bold> In addition, we may make more significant changesto the Site and/or these Terms, but if we do so and these changes materially or adversely impact your rights or use of the Site, we will notify you by email of such changes using the contact information provided by you. We may require you to provide consent to the updated agreement before further use of the Services is permitted. By continuing to use any Services after the new effective date, you agree to be bound by such changes. If the modified terms are not acceptable to you, please cease using the Services.\n",
      "4",
      Tab.headIndent(22),
      ], baseStyle: privacyStyle)
    
    let string7 = NSAttributedString.composed(of: [
      "<bold>Service Description and Participation​.</bold> Zentai is an online platform that connects Acupuncture therapists (<bold>“Therapists​”</bold>) with individuals (<bold>“Individual Customers​”</bold>) or businesses (<bold>“Corporate Customers​”</bold>) that want to purchase and/or receive Acupuncture therapy, together herein referred to as (<bold>“Customers​”</bold>). As auser of the Services (including a Therapist or a Customer), you agree to provideus with complete and accurate information (if requested) and to update such information to keep it accurate, current and complete. You understand that any personal information you provide will be treated in accordance with Zentai’s Privacy Policy available https://www.zentai.com/privacy-policy. <bold>YOU UNDERSTAND AND AGREE THAT ZENTAI HAS NO CONTROL OVER THECONDUCT OF THE THERAPISTS OR CUSTOMERS.</bold>\n",
      "4.2",
      Tab.headIndent(14),
      "<bold>Account Creation​.</bold> In order to access certain features of the Website and Appsand to use certain Services, you may be required to register to create an account(<bold>“Account​”</bold>). In connection with setting up your Account with Zentai, we may supply you with a user identification and/or password. In connection with any future use, you may be asked to input your user identification and/or password from time to time. You agree to be responsible for all activity that occurs under your Account and agree to be responsible for maintaining the security of your password and user identification. You agree to immediately notify Zentai of any unauthorized use of your user identification or password or any other breach ofsecurity. You can delete your Account at any time, for any reason, by calling Zentai at 1-866-238-5709.\n",
      "4.3",
      Tab.headIndent(14),
      "<bold>Eligibility​.</bold> Persons under 13 are prohibited from providing personal informationon our Websites or via our Apps. If you are under the age of majority in your jurisdiction of residence, you may use the Services only with the involvement ofyour parent or guardian. Make sure that you review these terms with your parentor guardian so that you both understand all your rights and responsibilities. If you are under the age of majority in your jurisdiction of residence, you represent and warrant that you have obtained the consent of your parent or legal guardian to this Agreement.\n",
      "5",
      Tab.headIndent(22)
      ], baseStyle: privacyStyle)
    
    let string8 = NSAttributedString.composed(of: [
      "\n5.1",
      Tab.headIndent(14),
      "You are responsible for your use of the Services, and for any use of the Services made using your Account. Our goal is to create a positive experience in connection with our Services. To promote this goal, we prohibit certain kinds of conduct that may be harmful to other users or to Zentai.\n",
      "5.2",
      Tab.headIndent(14),
      "If you are a Therapist or Customer, you agree not to attempt to contact each other directly about the Services outside of the Services for a period of 6 months after the date of your last visit to the Services, except as may be permitted by these Terms or Zentai, or otherwise circumvent your relationship with Zentai.\n",
      "5.3",
      Tab.headIndent(14),
      "When you use the Services, you agree that you will not: (a) violate this Agreement or any Zentai rules regarding use of the Services;(b) violate any law or regulation;(c) breach any agreements you enter into with any third parties;(d) violate, infringe, or misappropriate other people’s intellectual property, privacy, publicity, or other legal rights;(e) engage in any behavior that is abusive, harassing, indecent, profane, obscene, hateful or otherwise objectionable, including sexual misconduct;(f) stalk, harass, or harm another individual;(g) for the purpose of misleading others, create a false identity of the sender or the origin of a message, forge headers or otherwise manipulate identifiers in order to disguise the origin of any material transmitted through the Services or in connection with Zentai;(h) impersonate any person or entity or perform any other similar fraudulent activity;(i) harvest or otherwise collect or store any information (including personally identifiable information) about other users of the Services, including e-mail addresses, without the express consent of such users or alter transmission data;(j) collect, distribute or gather personal or aggregate information, including Internet, e-mail or other electronic addresses, about Zentai’s customers orother users;(k) upload, post, e-mail or otherwise transmit any material that constitutes unsolicited or unauthorized advertising, promotional materials, “junk mail,““spam,“ “chain letters,“ “pyramid schemes,“ or any other form of solicitation orcommercial electronic message;(l) use any means to scrape or crawl any Web pages or Content contained in the Websites or Apps (although Zentai may allow operators of public search engines to use spiders to index materials from the Websites for the sole purpose of creating publicly available searchable indices of the materials, andZentai reserves the right to revoke these exceptions either generally or in specific cases);(m)attempt to circumvent any technological measure implemented by Zentai orany of Zentai’s providers or any other third party (including another user) to protect the Websites or Apps; to the extent permitted by applicable law,attempt to decipher, decompile, disassemble, or reverse engineer any of the software used to provide the Websites or Apps; or(n) advocate, encourage, or assist any third party in doing any of the foregoing.\n",
      "6",
      Tab.headIndent(22)
      ], baseStyle: privacyStyle)
    
    let string9 = NSAttributedString.composed(of: [
      "\n6.1",
      Tab.headIndent(14),
      "Subject at all times to this Agreement, if you elect to download the App, thefollowing also applies: Zentai grants you a license to download, install and use a copy of the App on a single mobile device or computer that you own or control solely for your personal and professional use on the basis that the license is:(a)revocable – we have the right to remove your ability to use the App in accordance with these Terms;(b)non-exclusive – other people can access and use the App;(c)non-transferable – you can’t pass this right to someone else or sublicense the license; and(d)limited – the license does not extend beyond what has just been described above.\n",
      "6.2",
      Tab.headIndent(14),
      "urthermore, with respect to any App accessed through or downloaded from an App Store such as Google Play or the Apple App Store (an “App Store SourcedApplication​”), you will only use the App Store Sourced Application: (1) on aproduct that runs the operating system for which it was intended and (2) as permitted by the “Usage Rules” set forth in the corresponding App Store. Use of the App from a third party App Store is also subject to the provisions of Section10.\n",
      "7",
      Tab.headIndent(22)
      ], baseStyle: privacyStyle)
    
    let string10 = NSAttributedString.composed(of: [
      "\n7.1",
      Tab.headIndent(14),
      "<bold>Where to find the price​.</bold> We may charge fees in connection with your use of theServices. The price of the product will be the price indicated on the order pages when you placed your order. We use our best efforts to ensure that the price advised to you is correct. However please see Section 7.2 for what happens ifwe discover an error in the price of your order.\n",
      "7.2",
      Tab.headIndent(14),
      "What happens if we got the price wrong?​ It is always possible that, despite our best efforts, some of the Services may be incorrectly priced. We will normally check prices before accepting your order so that, where the correct price at your order date is less than our stated price at your order date, we will charge the lower amount. If the correct price at your order date is higher than the price stated to you, we will contact you for your instructions before we accept your order.\n",
      "7.3",
      Tab.headIndent(14),
      "<bold>When you must pay and how you must pay.</bold>​ You agree to pay all charges  incurred by you or any users of your Account and payment card (or other  applicable payment mechanism) at the amounts in effect when such charges are  incurred. Customers must provide Zentai with a valid credit or debit card (Visa,  MasterCard, or any other accepted issuer) or use Apple Pay or any other  payment or financial mechanism specified by Zentai (“Payment Provider​”) as a  condition to making any payments. Therapists must support the use of the  Payment Providers and provide Zentai with valid bank account information (e.g.  account and routing number) as a condition to receiving any payments. The  Customer’s Payment Provider agreement governs its use of the designated  credit or debit card or other mechanism, and the Customer should refer to that  agreement and not this Agreement to determine its rights and liabilities. By  providing Zentai with your payment and/or financial information, you agree that  Zentai and any of its third party payment processors are authorized to  immediately debit or credit your account for all applicable fees and charges and  that no additional notice or consent is required. You agree to immediately notify  Zentai of any change in your payment and financial information. Zentai reserves  the right at any time to change its prices and billing methods. All information that  you provide to us or our third party payment processors must be accurate,  current and complete. You will also be responsible for paying any applicable  taxes relating to payments that you make or that you receive.\n",
      "7.4",
      Tab.headIndent(14),
      "<bold>For Therapists.</bold>​ Each Therapist hereby appoints Zentai as the Therapist’s  limited payment collection agent solely for the purpose of accepting applicable  payment from Customers. Each Therapist agrees that payment made by a  Customer through Zentai shall be considered the same as a payment made  directly to the Therapist, and the Therapist will provide its services to the  Customer in the agreed-upon manner as if the Therapist has received the  payment. Each Therapist understands that Zentai accepts payments from  Customers as the Therapist’s limited payment collection agent and that Zentai’s  obligation to pay the Therapist is subject to and conditional upon successful  receipt of the associated payments from Customers. Zentai does not guarantee  payments to Therapists for amounts that have not been successfully received by  Zentai from Customers. In accepting appointment as the limited payment  collection agent of the Therapist, Zentai assumes no liability for any acts or  omissions of the Customers. Each Customer acknowledges and agrees that  Zentai reserves the right, in its sole discretion, to charge Customer for and  collect fees from the Customer. Zentai reserves the right at its discretion to  cancel or reverse any payment, even if it has been previously confirmed by  Zentai, as a result of any mistake or error, including any mistaken pricing or  service description or other error.\n",
      "7.5",
      Tab.headIndent(14),
      "<bold>Cancellations and Rescheduling.</bold>​ If you are a Therapist or Customer, you  agree to Zentai’s cancellation and rescheduling policy and the associated  charges and payments, the terms of which are located here  https://www.zentai.com/cancellation and are incorporated herein by reference.\n",
      "8",
      Tab.headIndent(22),
      ], baseStyle: privacyStyle)
    
    let string11 = NSAttributedString.composed(of: [
      "\n8.1",
      Tab.headIndent(14),
      "<bold>Ownership.</bold>​ The parties agree that all proprietary rights in the Services are and  will remain the property of Zentai. This includes non-personally identifiable  aggregate data collected by Zentai in connection with providing the Services,  including usage statistics and traffic patterns, any and all rights, title and interest  to which are hereby assigned to Zentai by you.\n",
      "8.2",
      Tab.headIndent(14),
      "<bold>Copyright Restrictions.</bold> (a)The Websites and Apps, including but not limited to software, content, text,  photographs, images, graphics, video, audio and the compilation as a whole  (“Content​”), are copyrighted under U.S. and Canadian copyright​, trademark  and other laws by Zentai or its licensors, unless otherwise noted. You must  abide by all additional copyright notices or restrictions contained in the  Websites, Apps or elsewhere. You may not delete any legal or proprietary  notices in the Websites, Apps or elsewhere.  (b)Except as noted in Section 6 above: (1) the Websites and Apps may not be  used, displayed, copied, reproduced, distributed, republished, uploaded,  downloaded, posted, transmitted, mirrored or modified; and (2) except to the  extent permitted by applicable law, you may not redistribute, sell, translate,  modify, reverse-engineer or reverse-compile or decompile, disassemble or  make derivative works of the Websites, Apps or any Content or components  that are available on the Websites or Apps.  (c)You agree not to interfere or take action that results in interference with or  disruption of the Websites or Apps or servers or networks connected to the  Websites or Apps. You agree not to attempt to gain unauthorized access to  other computer systems or networks connected to the Websites or Apps.  Zentai reserves all other rights. Except as expressly provided herein, nothing  on the Websites or as part of the Services will be construed as conferring any  license under Zentai’s and/or any third party’s intellectual property rights.  Notwithstanding anything herein to the contrary, Zentai may revoke any of the  foregoing rights and/or your access to the Services, including the App, or any  part thereof, at any time without prior notice.\n",
      "8.3",
      Tab.headIndent(14),
      "<bold>Copyright Permission.</bold>​ Permission is granted for viewing the Website pages  and Content on the Internet and via the Apps for your own informational  purposes, subject to the terms and conditions of this Agreement. In the event  that information is downloaded from the Websites or Apps, the information,  including any Content, data or files incorporated in or generated by the Websites  or Apps are owned by Zentai and Zentai retains complete title to the information  and all property rights therein. All other rights are reserved. Reproduction of  multiple copies of the Content, in whole or in part, for resale or distribution, is  strictly prohibited except with the prior written permission of Zentai. To obtain  written consent for such reproduction, please contact us at legal@zentai.com.\n",
      "8.4",
      Tab.headIndent(14),
      "<bold>Content License.</bold>​ As part of the Services, we may, if our sole discretion, permit  you to post, upload, publish, submit or transmit certain content (“Your  Materials​”). We may also post a photograph or other visual likeness of you  (“Your Image​”). By making available any of Your Materials on or through the  Services or if we make available Your Image on or through the Services, you (i)  hereby grant to Zentai the right to use Your Materials and Your Image as  necessary to provide the Services, promote the Services and improve the  Services, and (ii) waive any and all moral rights that you may have in and to  Your Materials and Your Image with respect to these uses. Zentai does not claim  any ownership rights in any of Your Materials and nothing in this Agreement will  be deemed to restrict any rights that you may have to use and exploit any of  Your Materials. If you do not want to grant us permission to use Your Material or  Your Image in accordance with this Agreement, please do not post, upload,  publish, submit or transmit Your Materials or Your Image.\n",
      "8.5",
      Tab.headIndent(14),
      "<bold>Copyright Policy.</bold>​ You acknowledge and agree that you are solely responsible  for all of Your Materials that you make available through the Services. You  represent and warrant that: (1) you either are the sole and exclusive owner of all  of Your Materials that you make available through the Services or you have all  rights, licenses, consents and releases that are necessary to grant to Zentai (or,  the Therapist or Customer as applicable) the rights in Your Materials, as  contemplated under this Agreement; and (2) neither Your Materials nor your  posting, uploading, publication, submission or transmittal of Your Materials or  Zentai’s (or, the Therapist’s or Customer’s as applicable) use of Your Materials  or Your Image (or any portion thereof) on, through or by means of the Services  will infringe, misappropriate or violate any patent, copyright, trademark, trade  secret, moral rights or other proprietary or intellectual property rights, or rights of  publicity or privacy, or result in the violation of any applicable law or regulation.\n",
      "8.6",
      Tab.headIndent(14),
      "<bold>Trademarks/Use of Name or Brand.</bold>​ All Content, product names, trademarks,  service marks and logos appearing as part of the Services, unless otherwise  noted, are wholly owned or validly licensed by Zentai. Trademarks, service  marks and logos owned by third parties remain the property of such third parties.\n",
      "8.7",
      Tab.headIndent(14),
      "<bold>Feedback.</bold>​ If you submit any ideas, suggestions or testimonials “Feedback” to  Zentai, you hereby transfer to us all rights in such Feedback without charge. You  also agree that Zentai shall have the right to use and fully exploit such Feedback  in any manner that we consider appropriate, including posting on the Internet.  Please note that the Feedback you provide to us will not be treated as  confidential information – accordingly, you agree not to submit to us any  information or ideas that you consider to be confidential or proprietary.You may  only submit ideas and material if you have obtained appropriate copyright and  other permission to submit such materials and to permit Zentai to use such  material without restriction. You agree that you will not violate or infringe the  rights of third parties, including privacy, publicity and intellectual and proprietary  rights, such as copyright or trademark rights.\n",
      "9",
      Tab.headIndent(22),
      ], baseStyle: privacyStyle)
    
    let string12 = NSAttributedString.composed(of: [
      "\n9.1",
      Tab.headIndent(14),
      "<bold>DISCLAIMER.</bold>​ ZENTAI DOES NOT MAKE ANY REPRESENTATIONS,  CONDITIONS OR WARRANTIES, EXPRESS OR IMPLIED, INCLUDING  WITHOUT LIMITATION, WARRANTIES OF MERCHANTABILITY,  SATISFACTORY QUALITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE,  COMPATIBILITY, SECURITY, ACCURACY, OR USEFULNESS WITH  RESPECT TO THE SERVICES. YOU AGREE THAT ANY CLAIMS OR  CAUSES OF ACTION ARISING OUT OF ANY ACTION OR INACTION OF ANY  THERAPISTS OR CUSTOMERS, SHALL BE EXCLUSIVELY BETWEEN YOU  AND THE THERAPIST OR CUSTOMER (AS APPLICABLE) AND NOT ZENTAI.  THE SERVICES ARE PROVIDED “AS IS.” YOU AGREE TO USE THE  SERVICES SOLELY AT YOUR OWN RISK. YOU ASSUME FULL  RESPONSIBILITY AND RISK OF LOSS RESULTING FROM YOUR USE OF  THE SERVICES. ALTHOUGH WE INTEND TO TAKE REASONABLE STEPS  TO PREVENT ANY DAMAGES TO YOU, WE ARE NOT LIABLE FOR ANY  DAMAGES OR HARM ATTRIBUTABLE TO THE FOREGOING. YOU  UNDERSTAND AND ACKNOWLEDGE THAT ZENTAI ONLY PROVIDES A  PLATFORM FOR COMMUNICATION BETWEEN THERAPISTS AND  CUSTOMERS, AND AS SUCH ZENTAI DISCLAIMS ANY AND ALL LIABILITY  RELATING TO YOUR INTERACTIONS WITH ANY THERAPIST(S) OR OTHER  CUSTOMER(S). ANY REPRESENTATIONS MADE TO YOU BY ANY  THERAPIST(S) ARE MADE SOLELY AT THE DISCRETION OF THE  THERAPIST AND ZENTAI HAS NO WAY TO MONITOR OR VALIDATE, AND  SHALL NOT BE RESPONSIBLE OR LIABLE IN ANY WAY FOR, ANY  REPRESENTATIONS OR STATEMENTS MADE TO YOU BY THE  THERAPIST(S). YOU UNDERSTAND AND ACKNOWLEDGE THAT ZENTAI  SHALL HAVE NO LIABILITY TO YOU FOR ANY STATEMENTS OR  REPRESENTATIONS MADE BY THE THERAPIST TO YOU AS A RESULT OF  YOUR USE OF THE SERVICE(S).\n",
      "9.2.",
      Tab.headIndent(14),
      "<bold>THE SITE IS NOT BESPOKE TO YOU.</bold>​ YOU ACKNOWLEDGE THAT THE  SITE HAS NOT BEEN DEVELOPED TO MEET YOUR INDIVIDUAL  REQUIREMENTS, AND THAT IT IS THEREFORE YOUR RESPONSIBILITY TO  ENSURE THAT THE FACILITIES AND FUNCTIONS OF THE SITE MEET  YOUR REQUIREMENTS.\n",
      "9.3",
      Tab.headIndent(14),
      "<bold>WE ARE RESPONSIBLE TO YOU ONLY FOR FORESEEABLE LOSS AND  DAMAGE CAUSED BY US.</bold>​ IF WE FAIL TO COMPLY WITH THESE TERMS,  WE ARE RESPONSIBLE FOR LOSS OR DAMAGE YOU SUFFER THAT IS A  FORESEEABLE RESULT OF OUR BREAKING THESE TERMS OR OUR  FAILURE TO USE REASONABLE CARE AND SKILL, BUT WE ARE NOT  RESPONSIBLE FOR ANY LOSS OR DAMAGE THAT IS NOT FORESEEABLE.  LOSS OR DAMAGE IS FORESEEABLE IF EITHER IT IS OBVIOUS THAT IT  WILL HAPPEN OR IF, AT THE TIME THESE TERMS ARE ENTERED INTO  AND BOTH WE AND YOU KNEW IT MIGHT HAPPEN.\n",
      "9.4",
      Tab.headIndent(14),
      "<bold>WE ARE NOT LIABLE FOR BUSINESS LOSSES.</bold>​ IF YOU ARE AN  INDIVIDUAL CUSTOMER, WE ONLY MAKE THE SITE AVAILABLE FOR  YOUR DOMESTIC AND PRIVATE USE. IF YOU ARE A THERAPIST AND USE  THE SITE FOR ANY COMMERCIAL, BUSINESS OR RE-SALE PURPOSE WE  WILL HAVE NO LIABILITY TO YOU FOR ANY LOSS OF PROFIT, LOSS OF  BUSINESS, BUSINESS INTERRUPTION, OR LOSS OF BUSINESS  OPPORTUNITY.\n",
      "9.5",
      Tab.headIndent(14),
      "<bold>NO LIABILITY FOR DAMAGE CAUSED BY UNAUTHORISED ACCESS.</bold>​ WE  WILL NOT BE RESPONSIBLE FOR ANY LOSS OR DAMAGE INCURRED AS  A RESULT OF UNAUTHORISED ACCESS TO YOUR ACCOUNT WHICH IS  NOT WITHIN OUR REASONABLE CONTROL.\n",
      ], baseStyle: privacyStyle)
    
    let string13 = NSAttributedString.composed(of: [
      "\n9.6",
      Tab.headIndent(14),
      "<bold>DISCLAIMER.</bold>​ ZENTAI DOES NOT MAKE ANY REPRESENTATIONS,  CONDITIONS OR WARRANTIES, EXPRESS OR IMPLIED, INCLUDING  WITHOUT LIMITATION, WARRANTIES OF MERCHANTABILITY,  SATISFACTORY QUALITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE,  COMPATIBILITY, SECURITY, ACCURACY, OR USEFULNESS WITH  RESPECT TO THE SERVICES. YOU AGREE THAT ANY CLAIMS OR  CAUSES OF ACTION ARISING OUT OF ANY ACTION OR INACTION OF ANY  THERAPISTS OR CUSTOMERS, SHALL BE EXCLUSIVELY BETWEEN YOU  AND THE THERAPIST OR CUSTOMER (AS APPLICABLE) AND NOT ZENTAI.  THE SERVICES ARE PROVIDED “AS IS.” YOU AGREE TO USE THE  SERVICES SOLELY AT YOUR OWN RISK. YOU ASSUME FULL  RESPONSIBILITY AND RISK OF LOSS RESULTING FROM YOUR USE OF  THE SERVICES. ALTHOUGH WE INTEND TO TAKE REASONABLE STEPS  TO PREVENT ANY DAMAGES TO YOU, WE ARE NOT LIABLE FOR ANY  DAMAGES OR HARM ATTRIBUTABLE TO THE FOREGOING. YOU  UNDERSTAND AND ACKNOWLEDGE THAT ZENTAI ONLY PROVIDES A  PLATFORM FOR COMMUNICATION BETWEEN THERAPISTS AND  CUSTOMERS, AND AS SUCH ZENTAI DISCLAIMS ANY AND ALL LIABILITY  RELATING TO YOUR INTERACTIONS WITH ANY THERAPIST(S) OR OTHER  CUSTOMER(S). ANY REPRESENTATIONS MADE TO YOU BY ANY  THERAPIST(S) ARE MADE SOLELY AT THE DISCRETION OF THE  THERAPIST AND ZENTAI HAS NO WAY TO MONITOR OR VALIDATE, AND  SHALL NOT BE RESPONSIBLE OR LIABLE IN ANY WAY FOR, ANY  REPRESENTATIONS OR STATEMENTS MADE TO YOU BY THE  THERAPIST(S). YOU UNDERSTAND AND ACKNOWLEDGE THAT ZENTAI  SHALL HAVE NO LIABILITY TO YOU FOR ANY STATEMENTS OR  REPRESENTATIONS MADE BY THE THERAPIST TO YOU AS A RESULT OF  YOUR USE OF THE SERVICE(S).\n",
      "9.7",
      Tab.headIndent(14),
      "LIMITED LIABILITY. TO THE MAXIMUM EXTENT PERMITTED BY  APPLICABLE LAWS, YOU AGREE THAT ZENTAI, ITS AFFILIATES, AGENTS  AND THEIR RESPECTIVE OFFICERS, DIRECTORS, SHAREHOLDERS,  EMPLOYEES, CONTRACTORS, REPRESENTATIVES AND AGENTS WILL  NOT BE LIABLE WHETHER IN CONTRACT, TORT (INCLUDING  NEGLIGENCE), FOR BREACH OF STATUTORY DUTY, OR OTHERWISE,  ARISING UNDER OR IN CONNECTION WITH THIS AGREEMENT FOR: (A)  ANY LOSS OF PROFITS; (B) ANY INDIRECT OR CONSEQUENTIAL LOSS;  OR (C) TO THE EXTENT THAT YOU EXPERIENCE ANY LOSS OR DAMAGES  RESULTING FROM YOUR USE OF THE SERVICES, INTERACTIONS WITH  THERAPIST(S) OR OTHER CUSTOMERS.\n",
      "9.8",
      Tab.headIndent(14),
      "INDEMNIFICATION.​ YOU AGREE TO INDEMNIFY AND HOLD HARMLESS  ZENTAI, ITS AFFILIATES, AGENTS, CONTRACTORS, AND THEIR  RESPECTIVE OFFICERS, DIRECTORS, SHAREHOLDERS, EMPLOYEES,  CONTRACTORS, REPRESENTATIVES AND AGENTS, FROM ANY AND ALL  LIABILITIES, CLAIMS, EXPENSES AND DAMAGES, INCLUDING  REASONABLE ATTORNEYS’ FEES AND COSTS, ARISING OUT OF OR IN  ANY WAY RELATED TO YOUR BREACH OF THIS AGREEMENT.\n",
      
      ], baseStyle: privacyStyle)
    
    let string14 = NSAttributedString.composed(of: [
      "\n9.9",
      Tab.headIndent(14),
      "<bold>LIABILITY CAP.</bold>​ EXCEPT WHERE PROHIBITED BY APPLICABLE LAW, THE  AGGREGATE LIABILITY OF ZENTAI, ITS AFFILIATES, AGENTS AND THEIR  RESPECTIVE OFFICERS, DIRECTORS, SHAREHOLDERS, EMPLOYEES,  CONTRACTORS, REPRESENTATIVES AND AGENTS TO YOU FOR ALL  CLAIMS ARISING FROM OR RELATING TO THIS AGREEMENT OR YOUR  USE OF THE SERVICES, INCLUDING, WITHOUT LIMITATION, YOUR  INTERACTION WITH ANY THERAPIST(S) OR OTHER CUSTOMER(S), ANY  CAUSE OF ACTION SOUNDING IN CONTRACT, TORT, OR STRICT  LIABILITY, WILL NOT EXCEED THE GREATER OF: (A) THE TOTAL AMOUNT  RECEIVED BY ZENTAI FROM YOU DURING THE SIX-MONTH PERIOD  PRIOR TO THE ACT, OMISSION OR OCCURRENCE GIVING RISE TO SUCH  LIABILITY, OR (B) $100.\n",
      "9.10",
      Tab.headIndent(12),
      "THIS LIMITATION OF LIABILITY IS INTENDED TO APPLY WITHOUT  REGARD TO WHETHER OTHER PROVISIONS OF THIS AGREEMENT HAVE  BEEN BREACHED OR HAVE PROVEN INEFFECTIVE OR IF A REMEDY  FAILS OF ITS ESSENTIAL PURPOSE. SOME JURISDICTIONS DO NOT  ALLOW FOR LIMITED LIABILITY OR EXCLUSION OF CERTAIN  WARRANTIES, CONDITIONS OR REPRESENTATIONS SO NOT ALL OF THE  ABOVE LIMITATIONS MAY APPLY TO YOU. YOU ACKNOWLEDGE AND  UNDERSTAND THAT THE DISCLAIMERS, EXCLUSIONS AND LIMITATIONS  OF LIABILITY SET FORTH HEREIN FORM AN ESSENTIAL BASIS OF THE  AGREEMENT BETWEEN THE PARTIES HERETO, THAT THE PARTIES  HAVE RELIED UPON SUCH DISCLAIMERS, EXCLUSIONS AND  LIMITATIONS OF LIABILITY, AND THAT ABSENT SUCH DISCLAIMERS,  EXCLUSIONS AND LIMITATIONS OF LIABILITY, THE TERMS AND  CONDITIONS OF THIS AGREEMENT WOULD BE SUBSTANTIALLY  DIFFERENT\n",
      "9.11",
      Tab.headIndent(12),
      "<bold>WHAT WE DO NOT EXCLUDE.</bold>​ EXCEPT WHERE PROHIBITED BY  APPLICABLE LAW, NOTHING IN THESE TERMS SHALL LIMIT OR EXCLUDE  OUR LIABILITY FOR:  (a)DEATH OR PERSONAL INJURY RESULTING SOLELY FROM OUR  NEGLIGENCE OR THE NEGLIGENCE OF OUR EMPLOYEES, AGENTS OR  SUBCONTRACTORS;  (b)FRAUD OR FRAUDULENT MISREPRESENTATION;  (c)ANY OTHER LIABILITY THAT CANNOT BE EXCLUDED BY APPLICABLE  LAW.\n",
      "10",
      Tab.headIndent(22),
      ], baseStyle: privacyStyle)
    
    let string15 = NSAttributedString.composed(of: [
      "\n10.1",
      Tab.headIndent(12),
      "Third Party Links and Ads The Site may contain links to third-party websites and  services, and/or display advertisements for third parties (collectively, “Third-Party  Links & Ads”). Where the Site contains links to Third-Party Links & Ads, these  links are provided for your information and convenience only. We have no  control over the contents of those sites or resources. Zentai does not review,  approve, endorse or make any promises with respect to Third-Party Links & Ads.  You use Third-Party Links & Ads at your own risk. You use all Third-Party Links  & Ads at your own risk, and should apply a suitable level of caution and  discretion in doing so. When you click on any of the Third-Party Links & Ads, the  applicable third party’s terms and policies apply, not these Terms.\n",
      "10.2",
      Tab.headIndent(12),
      "<bold>App Store.</bold>​ When you download our Apps, you may do so through a third party’s  App Store. You acknowledge that the terms of this Agreement are between you  and us and not with the owner or operator of the App Store (“App Store  Owner​”). As between the App Store Owner and us, we, and not the App Store  Owner, are solely responsible for the Services, including the App, the content,  maintenance, support services, and warranty, and addressing any claims  relating thereto (e.g., product liability, legal compliance or intellectual property  infringement). In order to use the App, you must have access to a wireless  network, and you agree to pay all fees associated with such access. You also  agree to pay all fees (if any) charged by the App Store Owner in connection with  the Services, including the App. The following applies to any App Store Sourced  Application (as such term is defined in Section 6):  (a)Your use of the App Store Sourced Application must comply with the App  Store’s “Terms of Service” or equivalent terms.  (b)You acknowledge that the App Store Owner has no obligation whatsoever to  furnish any maintenance and support services with respect to the App Store  Sourced Application.  (c)In the event of any failure of the App Store Sourced Application to conform to  any applicable warranty, you may notify the App Store Owner, and the App  Store Owner will refund the purchase price for the App Store Sourced  Application to you (if any) and to the maximum extent permitted by applicable  law, the App Store Owner will have no other warranty obligation whatsoever  with respect to the App Store Sourced Application. As between Zentai and the  App Store Owner, any other claims, losses, liabilities, damages, costs or  expenses attributable to any failure to conform to any warranty will be the sole  responsibility of Zentai.  (d)You and we acknowledge that, as between Zentai and the App Store Owner,  the App Store Owner is not responsible for addressing any claims you have or  any claims of any third party relating to the App Store Sourced Application or  your possession and use of the App Store Sourced Application, including, but  not limited to: (1) product liability claims; (2) any claim that the App Store  Sourced Application fails to conform to any applicable legal or regulatory  requirement; and (3) claims arising under consumer protection or similar  legislation.  (e)You and we acknowledge that, in the event of any third-party claim that the  App Store Sourced Application or your possession and use of that App Store  Sourced Application infringes that third party’s intellectual property rights, as  between Zentai and the App Store Owner, Zentai, not the App Store Owner,  will be solely responsible for the investigation, defense, settlement and  discharge of any such intellectual property infringement claim to the extent  required by this Agreement.  (f) You and we acknowledge and agree that the App Store Owner, and the App  Store Owner’s subsidiaries, are third-party beneficiaries of this Agreement as  related to your license of the App Store Sourced Application, and that, upon  your acceptance of this Agreement, the App Store Owner will have the right  (and will be deemed to have accepted the right) to enforce the terms of this  Agreement as related to your license of the App Store Sourced Application  against you as a third-party beneficiary thereof.  (g)You represent and warrant that (1) you are not located in a country that is  subject to a U.S. Government embargo, or that has been designated by the  U.S. Government as a “terrorist supporting” country; and (2) you are not listed  on any U.S. Government list of prohibited or restricted parties.  (h)Without limiting any other terms in this Agreement, you must comply with all  applicable third-party terms of agreement when using the App Store Sourced  Application.\n",
      "11",
      Tab.headIndent(22)
      ], baseStyle: privacyStyle)
    
    let string16 = NSAttributedString.composed(of: [
      "\n11.1",
      Tab.headIndent(12),
      "<bold>When we might suspend or terminate your Account or Site access.​</bold> We  may, subject to applicable law, in our discretion and without liability to you, with  or without cause, with or without prior notice and at any time: (a) terminate this  Agreement and/or your access to the Services, and (b) deactivate or cancel your  Account.\n",
      "11.2",
      Tab.headIndent(12),
      "<bold>What happens when these Terms terminate?</bold>​ Upon termination we will  promptly pay you any amounts that we reasonably determine we owe you (if  any) in our discretion. In the event Zentai terminates this Agreement or your  access to the Services or deactivates or cancels your Account, you will remain  liable for all amounts due hereunder.\n",
      "11.3",
      Tab.headIndent(12),
      "<bold>Your right to cancel.</bold>​ You may cancel your Account at any time by contacting  us at the contact information set out in Section 2. Please note that if your  Account is cancelled, we do not have any obligation to delete or return to you  any of Your Materials that you have posted to the Services, including, but not  limited to, any reviews or Feedback.\n",
      "11.4",
      Tab.headIndent(12),
      "<bold>Our right to cancel.</bold>​ If we terminate this Agreement and/or your access to the  Services as a result of your violation of any applicable law or regulation, we may  also, at our sole discretion, inform law enforcement or regulatory authorities of  the circumstances surrounding such termination.\n",
      "12",
      Tab.headIndent(22)
      ], baseStyle: privacyStyle)
    
    let string17 = NSAttributedString.composed(of: [
      "\n12.1",
      Tab.headIndent(12),
      "<bold>Privacy Policy.</bold>​ Please refer to our Privacy Policy  https://www.zentai.com/privacy-policy for more information on the manner in  which Zentai collects, uses, discloses and otherwise treats your personal  information. The Privacy Policy is fully incorporated herein by reference.\n",
      "\n12.2",
      Tab.headIndent(12),
      "<bold>Anti-Spam.</bold>​ Zentai prohibits the sending of unsolicited email or text messages  (spam) or other communications that violate applicable privacy and anti-spam  legislation. Spam is defined for this purpose as sending any message that  encourages participation in a commercial activity or multiple messages similar in  content to any person(s), entity(ies), newsgroup(s), forum(s), email list(s), or  other group(s), individual(s) or list(s) unless prior authorization has been  obtained from the recipient or unless a business or personal relationship has  already been established with the recipient in accordance with the requirements  under applicable law. Zentai also prohibits using false headers in emails or  falsifying, forging or altering the origin of any email or text message in  connection with Zentai, and/or any products and Services. Zentai prohibits  engaging in any of the foregoing activities by using the service of another  provider, remailer service, or otherwise. IF YOU OR ANYONE YOU KNOW IS  “SPAMMED” BY SOMEONE IN RELATION TO ZENTAI’S SERVICES, PLEASE  CONTACT US PROMPTLY VIA THE CONTACT MECHANISM MADE  AVAILABLE VIA THE WEBSITE SO THAT WE MAY TAKE APPROPRIATE  ACTION.",
      "\n12.3",
      Tab.headIndent(12),
      "<bold>Governing Law and Jurisdiction.</bold>​ To the extent permitted by applicable by law,  this Agreement will be governed by and interpreted in accordance with the laws  of the State of California and we both agree to submit to the non-exclusive  jurisdiction of the District Courts of California. This means that, if you are a  citizen of a country in the EU, you may bring a claim to enforce your consumer  protection rights in connection with these Terms in California or in the EU  country in which you live.\n",
      "\n12.4",
      Tab.headIndent(12),
      "<bold>Even if we delay in enforcing these Terms, we can still enforce it later.</bold>​ If we  do not insist immediately that you do anything you are required to do under  these Terms, or if we delay in taking steps against you in respect of your  breaking these Terms, that will not mean that you do not have to do those things  and it will not prevent us taking steps against you at a later date\n",
      "\n12.5",
      Tab.headIndent(12),
      "<bold>Rights and Remedies.</bold>​ Unless stated otherwise, all remedies provided for in this  Agreement shall be cumulative and in addition to and not in lieu of any other  remedies available to either party at law, in equity, or otherwise.\n",
      "\n12.6",
      Tab.headIndent(12),
      "Mandatory Arbitration and Dispute Resolution for United States and  Canadian Users.​ Please read this Arbitration Agreement carefully. It is part of  your contract with Zentai and affects your rights. It contains procedures for  MANDATORY BINDING ARBITRATION AND A CLASS ACTION WAIVER.  (a) Applicability of Arbitration Agreement. To the extent permitted by applicable  law, all claims and disputes (excluding claims for injunctive or other equitable  relief as set forth below) in connection with the Terms or the use of the  Services provided by Zentai that cannot be resolved informally or in small  claims court shall be resolved by binding arbitration on an individual basis  under the terms of this Arbitration Agreement. Unless otherwise agreed, all  arbitration proceedings shall be held in English. This Arbitration Agreement  applies to you and Zentai, and to any subsidiaries, affiliates, agents,  employees, predecessors in interest, successors, and assigns, as well as all  authorized or unauthorized users or beneficiaries of services or goods  provided under the Terms.  (b) Notice Requirement and Informal Dispute Resolution. Before either party may  seek arbitration, the party must first send to the other party a written Notice of  Dispute (<bold>“Notice​”</bold>) describing the nature and basis of the claim or dispute,  and the requested relief. A Notice to Zentai should be sent to: Director of  Operations, Zentai, Inc. 7083 Hollywood Blvd, Los Angeles, CA 90028. After  the Notice is received, you and Zentai may attempt to resolve the claim or  dispute informally. If you and Zentai do not resolve the claim or dispute within  thirty (30) days after the Notice is received, either party may begin an  arbitration proceeding. The amount of any settlement offer made by any party  may not be disclosed to the arbitrator until after the arbitrator has determined  the amount of the award, if any, to which either party is entitled.  (c) Arbitration Rules. Arbitration shall be initiated through JAMS, an established  alternative dispute resolution provider (“ADR Provider​”) that offers arbitration  as set forth in this section. If JAMS is not available to arbitrate, the parties  shall agree to select an alternative ADR Provider. The rules of the ADR  Provider shall govern all aspects of the arbitration, including but not limited to  the method of initiating and/or demanding arbitration, except to the extent  such rules are in conflict with the Terms. The arbitration shall be conducted  by a single, neutral arbitrator. Any claims or disputes where the total amount  of the award sought is less than Ten Thousand U.S. Dollars (US $10,000.00)  may be resolved through binding non-appearance-based arbitration, at the  option of the party seeking relief. For claims or disputes where the total  amount of the award sought is Ten Thousand U.S. Dollars (US $10,000.00)  or more, the right to a hearing will be determined by the Arbitration Rules.  Any hearing will be held in a location within 100 miles of your residence,  unless you reside outside of the United States, and unless the parties agree  otherwise. If you reside outside of the U.S., the arbitrator shall give the  parties reasonable notice of the date, time and place of any oral hearing. Any  judgment on the award rendered by the arbitrator may be entered in any  court of competent jurisdiction. If the arbitrator grants you an award that is  greater than the last settlement offer that Zentai made to you prior to the  initiation of arbitration, Zentai will pay you the greater of the award or fifty  dollars ($50). Each party shall bear its own costs (including attorney’s fees)  and disbursements arising out of the arbitration and shall pay an equal share  of the fees and costs of the ADR Provider.  (d) Additional Rules for Non-Appearance Based Arbitration. If non-appearance  based arbitration is elected, the arbitration shall be conducted by telephone,  online and/or based solely on written submissions; the specific manner shall  be chosen by the party initiating the arbitration. The arbitration shall not  involve any personal appearance by the parties or witnesses unless  otherwise agreed by the parties.  (e) Time Limits. If you or Zentai pursues arbitration, the arbitration action must  be initiated and/or demanded within the statute of limitations (i.e., the legal  deadline for filing a claim) and within any deadline imposed under the AAA  Rules for the pertinent claim.  (f) Authority of Arbitrator. If arbitration is initiated, the arbitrator will decide the  rights and liabilities, if any, of you and Zentai, and the dispute will not be  consolidated with any other matters or joined with any other cases or parties.  The arbitrator shall have the authority to grant motions dispositive of all or  part of any claim. The arbitrator shall have the authority to award monetary  damages, and to grant any non-monetary remedy or relief available to an  individual under applicable law, the AAA Rules, and the Terms. The arbitrator  shall issue a written award and statement of decision describing the essential  findings and conclusions on which the award is based, including the  calculation of any damages awarded. The arbitrator has the same authority to  award relief on an individual basis that a judge in a court of law would have.  The award of the arbitrator is final and binding upon you and Zentai.  (g) Waiver of Jury Trial. THE PARTIES HEREBY WAIVE THEIR  CONSTITUTIONAL AND STATUTORY RIGHTS TO GO TO COURT AND  HAVE A TRIAL IN FRONT OF A JUDGE OR A JURY, instead electing that  all claims and disputes shall be resolved by arbitration under this Arbitration  Agreement. Arbitration procedures are typically more limited, more efficient  and less costly than rules applicable in a court and are subject to very limited  review by a court. In the event any litigation should arise between you and  Zentai in any state or federal court in a suit to vacate or enforce an arbitration  award or otherwise, YOU AND COMPANY WAIVE ALL RIGHTS TO A JURY  TRIAL, instead electing that the dispute be resolved by a judge.  (h) Waiver of Class or Consolidated Actions. TO THE EXTENT PERMITTED BY  APPLICABLE LAW, ALL CLAIMS AND DISPUTES WITHIN THE SCOPE OF  THIS ARBITRATION AGREEMENT MUST BE ARBITRATED OR  LITIGATED ON AN INDIVIDUAL BASIS AND NOT ON A CLASS BASIS,  AND CLAIMS OF MORE THAN ONE CUSTOMER OR USER CANNOT BE  ARBITRATED OR LITIGATED JOINTLY OR CONSOLIDATED WITH  THOSE OF ANY OTHER CUSTOMER OR USER.  (i) Confidentiality. All aspects of the arbitration proceeding, including but not  limited to the award of the arbitrator and compliance therewith, shall be  strictly confidential. The parties agree to maintain confidentiality unless  otherwise required by law. This paragraph shall not prevent a party from  submitting to a court of law any information necessary to enforce this  Agreement, to enforce an arbitration award, or to seek injunctive or equitable  relief.  (j) Severability. If any part or parts of this Arbitration Agreement are found under  the law to be invalid or unenforceable by a court of competent jurisdiction,  then such specific part or parts shall be of no force and effect and shall be  severed and the remainder of the Agreement shall continue in full force and  effect.  (k) Right to Waive. Any or all of the rights and limitations set forth in this  Arbitration Agreement may be waived by the party against whom the claim is  asserted. Such waiver shall not waive or affect any other portion of this  Arbitration Agreement.  (l) Survival of Agreement. This Arbitration Agreement will survive the termination  of your relationship with Zentai.  (m)Small Claims Court. Notwithstanding the foregoing, either you or Zentai may  bring an individual action in small claims court.  (n) Emergency Equitable Relief. Notwithstanding the foregoing, either party may  seek emergency equitable relief before a state or federal court in order to  maintain the status quo pending arbitration. A request for interim measures  shall not be deemed a waiver of any other rights or obligations under this  Arbitration Agreement.  (o) Claims Not Subject to Arbitration. Notwithstanding the foregoing, claims of  defamation, violation of the Computer Fraud and Abuse Act, and infringement  or misappropriation of the other party’s patent, copyright, trademark or trade  secrets shall not be subject to this Arbitration Agreement.  (p) Courts. In any circumstances where the foregoing Arbitration Agreement  permits the parties to litigate in court, the parties hereby agree to submit to  the personal jurisdiction of the courts located within Los Angeles County,  California, for such purpose.\n",
      "\n12.7",
      Tab.headIndent(12),
      "<bold>If a court finds part of these Terms illegal, the rest will continue in force.</bold>  Each of the Sections of these Terms operates separately. If any court or relevant  authority decides that any of them are unlawful, the remaining Sections will  remain in full force and effect.\n",
      "\n12.8",
      Tab.headIndent(12),
      "<bold>We may transfer these Terms to someone else.​</bold> We may transfer our rights  and obligations under these Terms to another organization – for example, this  could include another member of our group of companies or someone who buys  our business. We will always tell you in writing if this happens and we will ensure  that the transfer will not affect your rights under these Terms.\n",
      "\n12.9",
      Tab.headIndent(12),
      "<bold>Nobody else has any rights under these Terms.</bold>​ These Terms are between  you and us. No other person shall have any rights to enforce any of its terms.\n",
      "PLEASE PRINT A COPY OF THIS AGREEMENT FOR YOUR RECORDS AND  PLEASE CHECK BACK FREQUENTLY FOR ANY CHANGES TO THIS AGREEMENT."
      ], baseStyle: privacyStyle)
    
    
    let combination = NSMutableAttributedString()
    combination.append(string3)
    combination.append(attributedString3)
    combination.append(string4)
    combination.append(attributedString4)
    combination.append(string5)
    combination.append(attributedString5)
    combination.append(string6)
    combination.append(attributedString6)
    combination.append(string7)
    combination.append(attributedString7)
    combination.append(string8)
    combination.append(attributedString8)
    combination.append(string9)
    combination.append(attributedString9)
    combination.append(string10)
    combination.append(attributedString10)
    combination.append(string11)
    combination.append(attributedString11)
    combination.append(string12)
    combination.append(attributedString12)
    combination.append(string13)
    combination.append(attributedString13)
    combination.append(string14)
    combination.append(attributedString14)
    combination.append(string15)
    combination.append(attributedString15)
    combination.append(string16)
    combination.append(attributedString16)
    combination.append(string17)
    
    textView.attributedText = combination
    
    view.backgroundColor = .clear
    blurView.backgroundColor = .clear
    
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
