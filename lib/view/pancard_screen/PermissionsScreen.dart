import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../../utils/common_elevted_button.dart';

class PermissionsScreen extends StatelessWidget {
  const PermissionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          top: true,
          bottom: true,
          child: PermissionsWidget()),
    );
  }
}

class PermissionsWidget extends StatefulWidget {
  @override
  _PermissionsWidget createState() => _PermissionsWidget();
}

class _PermissionsWidget extends State<PermissionsWidget> {
  @override
  Widget build(BuildContext context) {
    var accecptPermissions = false;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    // Handle tap event here
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    height: 20,
                    width: 20,
                    child: SvgPicture.asset(
                      'assets/icons/close_dilog_icons.svg',
                      semanticsLabel: 'My SVG Image',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'to setup your account, we need a few permissions',
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 20, color: Color(0xff0196CE)),
            ),
            const SizedBox(height: 20),
            const Text(
              'We need some permissions to make your experience better',
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
            const SizedBox(height: 20),
            ListTile(
              title: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    child: SvgPicture.asset(
                      'assets/icons/mobile_icon.svg',
                      semanticsLabel: 'mobile_icon',
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Adjust the spacing between icon and text
                        Text(
                          'Read Phone State & Phone Number',
                          style:
                              TextStyle(fontSize: 15, color: Color(0xff0196CE)),
                        ),
                        Text(
                          'This will help us in reading your mobile number and securely link your account',
                          style: TextStyle(fontSize: 15, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              dense: true,
              enabled: false,
              selected: true,
            ),
            ListTile(
              title: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    child: SvgPicture.asset(
                      'assets/icons/call_icon.svg',
                      semanticsLabel: 'Call_icon',
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Adjust the spacing between icon and text
                        Text(
                          'sms (send/read)',
                          style:
                              TextStyle(fontSize: 15, color: Color(0xff0196CE)),
                        ),
                        Text(
                          'Our app collects SMS data to assess your profile for various Scaleup products and/or services, including those offered in partnership with lending partners and other financial services providers. Additionally, send SMS access is required to verify your phone number and other verification purposes. This data may be collected even when the app is closed or not in use.',
                          style: TextStyle(fontSize: 15, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              dense: true,
              enabled: false,
              selected: true,
            ),
            ListTile(
              title: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    child: SvgPicture.asset(
                      'assets/icons/camera_icon.svg',
                      semanticsLabel: 'camera_icon',
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Adjust the spacing between icon and text
                        Text(
                          'Camera & Microphone Permission',
                          style:
                              TextStyle(fontSize: 15, color: Color(0xff0196CE)),
                        ),
                        Text(
                          'This app needs camera access so that you can easily scan or capture required KYC documents or to initiate an audio/video call for KYC purpose. This ensures that you are provided with a seamless experience while using the app.',
                          style: TextStyle(fontSize: 15, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              dense: true,
              enabled: false,
              selected: true,
            ),
            ListTile(
              title: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    child: SvgPicture.asset(
                      'assets/icons/file_icon.svg',
                      semanticsLabel: 'file_icon',
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Adjust the spacing between icon and text
                        Text(
                          'Storage',
                          style:
                              TextStyle(fontSize: 15, color: Color(0xff0196CE)),
                        ),
                        Text(
                          'This app can access the file stored on your device to help you submit your KYC documents, Bank statement and other required documents to complete the loan application process.',
                          style: TextStyle(fontSize: 15, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              dense: true,
              enabled: false,
              selected: true,
            ),
            ListTile(
              title: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    child: SvgPicture.asset(
                      'assets/icons/location_icon.svg',
                      semanticsLabel: 'location_icon',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Adjust the spacing between icon and text
                        Text(
                          'Location',
                          style:
                              TextStyle(fontSize: 15, color: Color(0xff0196CE)),
                        ),
                        Text(
                          'This will help us in showing Cash Deposit Points near you',
                          style: TextStyle(fontSize: 15, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              dense: true,
              enabled: false,
              selected: true,
            ),
            SizedBox(height: 20),
            HtmlWidget(
                '''<p>  <b>DIGITAL LENDING TERMS & CONDITIONS</b> Scaleupfincap Private Limited <b>(“Scaleup”, “we”, “our” or “us”)</b>is acting as an intermediary for making available loans, credit facilities in the nature of buy now pay later limits <b>(“Scaleup Pay”)</b> , business loans and any other similar product (together <b>“Lending Services”</b>) to its users <b>(“Users” or “you”)</b> on Scaleup (including sub-domains and microsites) as well as any other mobile website or mobile application related, linked, or otherwise connected thereto (collectively, the <b>“Platform”</b>) in collaboration with our lending partners and co-lender, if any, engaged by lending partner from time to time (collectively, <b>“Lenders”</b>). A list of our Lenders is provided in <b>Annexure I</b>. These Digital Lending Terms and Conditions (<b>“Terms”</b>) constitute a legally binding agreement made between you and Scaleup, concerning your access to and use of the Lending Services. You agree that by availing the Lending Services, you have read, understood, and agree to be bound by:these Terms; the Privacy Notice documented in <b>Annexure II </b>of these Terms; and the Scaleup Terms and Conditions which govern the provision of the Scaleup Services documented in <b>Annexure III</b> of these Terms;
<br><b>IF YOU DO NOT AGREE WITH THESE TERMS, THEN YOU ARE PROHIBITED FROM USING THE LENDING SERVICES AND YOU MUST DISCONTINUE USING THE SAME IMMEDIATELY.</b><br>
Supplemental terms and conditions or documents that may be posted on the Platform from time to time and are hereby expressly incorporated herein by reference. We reserve the right, in our discretion, to make changes or modifications to these Terms at any time and for any reason. We will alert you about any changes by updating the ‘Last updated’ date of these Terms and you waive any right to receive specific notice of each such change. It is your responsibility to periodically review these Terms to stay informed of such updates. You will be subject to and will be deemed to have been made aware of and to have accepted, the changes in any revised Terms by your continued use of the Lending Services after the date such revised terms are posted.
<br><b>1. DEFINITIONS</b><br>
In these Terms, capitalized words not already defined shall have the following meaning:
<br><b>Credit Information Companies/CIC</b><br>
TransUnion CIBIL Limited (Formerly Credit Information Bureau (India) Limited), Equifax Credit Information Services Private Limited, Experian Credit Information Company of India Private Limited, CRIF High Mark Credit Information Services Private Limited or any other credit information companies which has been granted a certificate of registration by Reserve Bank of India (RBI).
Credit Information
Any information relating to (i) the amounts and the nature of loans or advances, amounts outstanding under credit cards and other credit facilities granted or to be granted, by a credit institution to any User; (ii) the nature of security taken or proposed to be taken by a credit institution from any User for credit facilities granted or proposed to be granted to him; (iii) the guarantee furnished or any other non-fund based facility granted or proposed to be granted by a credit institution for any User; (iv) the credit worthiness of any User as a borrower of credit institutions; or (v) income and/or expense details of any User and any other matter which the Reserve Bank of India may, consider as credit information.
<br><b>Data</b><br>
Personal information, including sensitive personal information (as defined under Data Protection Laws) about you, which we collect, receive, or otherwise process in connection with your use of our Lending Services and as more specifically set out in Clause 3.4. below.
<br><b>Data Protection Laws</b>><br>
Any applicable law in India for the time being in force relating to the processing of Data.
<br><b>KYC</b><br>
Documents under the ‘know your customer’ guidelines issued by the Reserve Bank of India and shall include address proof, identity proof, income proof, PAN or such other officially valid documents.
<br><b>2. REGISTRATION</b><br>
<br><b>2.1 Eligibility</b><br>
To avail Lending Services on our Platform you must: be at least 18 years of age; be a citizen and tax resident of India and not resident of any other country; not be barred from or otherwise legally prohibited from accessing or availing the Lending Services or any other service of Scaleup; be capable of entering into a contract/legally binding agreement; avail the Lending Services and any loan proceeds only for legitimate purposes and not use the Lending Services and any loan proceeds for any illegal or prohibited purposes. If you do not meet our eligibility requirements, you may not be able to avail the Lending Services. We reserve the right to refuse access to or to discontinue Lending Services to any person or entity, at any time for any reason.
<br><b>2.2 Credentials and Security</b><br>
To avail and access the Lending Services, you shall have an active account on the Platform (<b>“Membership Account”</b>). Your email address/phone number and a password that you select will be used to access the Platform (<b>“Credentials”</b>). We treat all activities under a Membership Account to be those of the registered User. User shall avail the Lending Services only through their own Membership Account and not on behalf of any other person or entity. You shall update registration information linked to the Membership Account promptly upon any change and ensure that it is complete and accurate at all times. You are responsible for maintaining the secrecy and security of your Credentials and for restricting access to personal devices and systems that may store the Credentials, and you agree to accept responsibility for all activities that occur under your Membership Account or Credentials. You should not disclose your Credentials to any third party. You are responsible for all losses relating to an unauthorized transaction from your Membership Account and/or using your Credentials including but not limited to when you have acted fraudulently or failed, either intentionally or negligently, to use your Membership Account in accordance with these Terms, to protect your Credentials, or to notify us of any unauthorized transaction at: Customercare@scaleupfin.com. We will not be responsible for any unauthorized transactions_screen undertaken through your Membership Account and/or using your Credentials.
<br><b>2.3 User Representations</b><br>
i. By using the Lending Services, you represent and warrant that: all information you submit will be true, accurate, current, complete, and not misleading; you will maintain the accuracy your information and promptly update such information as necessary; and you will not use the Lending Services for any illegal or unauthorized purpose.
ii. In case of a breach of the representations in this Clause 2.3.1 or of any other part of these Terms, we and/or our Lenders have the right to: suspend or terminate your use of Lending Services and take any such recourse, as available to us and/or our Lenders under applicable law.
<br><b>3. OUR ROLE</b><br>
<br><b>3.1 Disclaimer & Disclosures</b><br>
As a lending service provider, we only provide you the Platform through which you can avail the Lending Services from the Lenders. It is clarified that we do not provide the loan and/or under the Lending Services to the User and our Lenders are the entities registered with RBI and authorised to provide the relevant loan and/or credit under the Lending Services. Lending Services including but not limited to approval, issuance, extension and closure shall be subject to and governed by the Lender’s terms and conditions, loan agreement, loan application form, privacy policy and/or any other documents accepted or executed by the you as part of the loan processing process (<b>“Loan Documents”</b>).
The Loan Documents shall govern the borrower and lender relationship between you and the Lender. The Lender will share these documents through email/SMS with you and/or will make it available on the Lender’s website/app. We may also make some of the documents/information available on the Platform as per your consent and/or the information provided by the Lender. We shall not take any responsibility or be held liable in any manner whatsoever for the Lending Services being offered by the Lenders on the Platform or any acts or omissions of the Lender or any other person (other than Scaleup) acting on behalf of the Lender. We will do credit analysis, KYC documentation of clients. The sanction/approval of loan shall be subject to credit analysis, completion of KYC requirement, and execution of Loan Document by the User to the satisfaction of the Lender. We will not mediate disputes between you and any Lender or enforce or execute the performance of any Loan Documents. We may receive fees or commission from the Lender for providing the Lending Services to the Lender or making the Platform available to the Lender. We will endeavor to provide the Lending Services on a best effort basis, and do not guarantee, represent or undertake that the Lending Services will be available all times, to all Users or will be free of any errors or defects. We shall not be held liable for any interruptions in providing the Lending Services. Further, Users’ access to the Platform or Membership Account for availing Lending Services may also be occasionally suspended or restricted to allow for repairs, maintenance, or the introduction of new facilities or services at any time without prior notice.
<br><b>3.2 Disbursement</b><br>
On completion of entire loan application process including but not limited to KYC procedure, credit analysis, acceptance of Loan Documents, setting up of eNach/Physical mandate or any other method for repayment and/or payment of fees/charges, the Lender shall disburse the loan amount directly into the bank account of the User or the final third-party beneficiary (example, relevant merchant).
<br><b>3.3 Repayment Facilitation</b><br>
Repayment of the loan and/or credit granted under the Lending Services is governed by the terms of the Loan Documents or as notified by the Lenders from time to time. We and our Lending Partners may make various modes and mediums available for repayment. You authorize us to send SMS, push notification or show alerts through the Platform to show the details of the pending amount to be paid by you to the Lender, and/or to nudge you to make the payment to the Lender directly, as the case maybe. Any such amount shall be displayed by us basis the information received from the Lenders. You agree and understand that it is your obligation to make the repayment under the Lending Services to the Lender on the due date. In case of non-payment on the due date, the Lender may charge default interest, additional fees or penalty as per the Loan Documents. The User understands and undertakes that User cannot change and shall not close this bank account till any amount is outstanding under the Lending Services provided by the Lender. You agree and understand that in case of default of payment of the outstanding amount or breach of any terms and condition of the Loan Documents, We both (the lender and company) may, at their discretion, initiate appropriate legal/recovery proceedings or take any other action against you as per applicable law and/or as per the Loan Documents. You understand and agree that we shall not be liable for any such action initiated by the Lender.
<br><b>3.4 Usage And Sharing of Data</b><br>
You understand that based on Data (including but not limited to name, age, address, PAN, identity documents or other data collected with your consent) and other information (including but not limited to transaction value/volume through the Platform and information in your existing Membership Account) available with us, you may be shown indicative loan offers. It is not a commitment from us and/or the Lenders to provide any loan/credit Lending Services. You agree and acknowledge that for undertaking the Lending Service, we (or the Lender) may seek additional Data or other information from the Users which you are obliged to give, for ascertaining eligibility for availing the loan and processing your application under the Lending Services. You agree that we may share your existing as well as any additional Data and other information including KYC details/documents, bank account details, and/or transaction value/volume with our group entities/Lenders/third party entities or Credit Information Companies for the purpose of fulfilling the Lending Services. You agree and understand that the KYC procedure may be carried out by the Lenders through any permissible means including through Central KYC Records Registry, DigiLocker, Aadhar based offline or online KYC, Video KYC and/or Digital KYC or a combination of permissible means as per applicable laws, and consent to the Lender carrying out the KYC procedure. You further authorize the Lender to share loan related information including but not limited to loan amount, loan agreement, disbursal, repayment, collection, and any other information from time to time with us. You further authorize us to access your loan related information and use the information to send notifications on the Platform and/or to provide Scaleup services from time to time. We may make, directly or through any third party, any inquiries we consider necessary to validate information that you provide to us. You may also be required to provide one time access to your location, mobile camera, device id or select other security access keys or credentials that may be used to enable your access to the Lending Services and authorize transactions_screen. You agree and understand that basis your consent we and/or the Lenders shall pull your Credit Information from CICs, for the purpose of assessing your credit worthiness. The Lender shall use, collect, verify and process the Credit Information received from CICs or from other sources for the purpose of the credit checks and processing of loan application.
<br><b>4. TERM AND TERMINATION</b><br>

<br><b>4.1 Term.</b><br>
These Terms commence on the date that you apply/register on platform to avail Lending Services on the Platform from any of the Lenders. These Terms shall continue unless and until terminated in accordance with the provisions of this Clause 4.
<br><b>4.2 Termination</b><br>
You may initiate termination of these Terms before availing lending services or after clearance of all dues by contacting us at customercare@scaleupfin.com. We may terminate the provision of the Lending Services and these Terms, for any reason at any time without written notice to you. Further, we may suspend your access to our Platform and block access to your Membership Account and deactivate it under the following circumstances: you have violated the terms of these Terms; you provide or have provided false, incomplete, inaccurate, or misleading information or otherwise engaged in fraudulent or illegal conduct; we have security concerns regarding your User Account, including your Credentials; or we suspect unauthorized or fraudulent use of your Membership Account. In such cases we will inform you of the deactivation of your Membership Account and the reasons for it, where possible, before the deactivation and in any event promptly thereafter, unless we determine that giving such information would compromise security concerns or is prohibited by applicable law. We will reactivate your Membership Account or Credentials, or replace it or them, as applicable, once we have resolved the reasons for deactivation to our satisfaction.
<br><b>4.3 Effect of Termination</b><br>
Upon termination of these Terms for any reason: Your existing relationship with any Lender (including any Loan Documents executed between you and the Lenders) will continue in accordance with the terms as determined by the Lenders; you will remain liable to the Lenders for all re-payment obligations including any interest, charges, penalties and other obligations that have been incurred by you with respect to your use of Lending Services; your access to the Platform will be terminated and your Membership Account will be deactivated.
<br><b>4.4 Survival</b><br>
Clauses 3 (Our Role), 4.3 (Effect of Termination), 5 (Communications), 6 (Intellectual Property), 7 (Indemnity and Limitation of Liability) and 8 (Miscellaneous) of these Terms shall survive and remain in effect upon the termination of these Terms.
<br><b>5. COMMUNICATIONS</b><br>
We may communicate with you by e-mail, SMS, phone call or by posting notices on the Platform or by any other mode of communication. Through your use of our Platform and the Lending Services, you consent to receiving communications including SMS, WhatsApp, e-mail or phone calls from us with respect to your use of the Lending Services.
<br><b>6. INTELLECTUAL PROPERTY</b><br>
6.1 Scaleup, its licensors and their respective affiliates, as the case maybe, are the sole and exclusive owners or licensees of the trademarks, service marks, trade names, logos, and copyrighted or copyrightable materials of Scaleup and its affiliates. The Users shall not use the Intellectual Property in any manner whatsoever without our prior written consent. Users shall not, directly or indirectly, interfere with, challenge, file applications for, or claim ownership of these trademarks anywhere in the world.
6.2 All material on the Platform is protected by copyrights, trademarks, and other intellectual property rights. You must not copy, reproduce, republish, upload, post, transmit or distribute such material in any way, including by email or other electronic means and whether directly or indirectly and you must not assist any other person to do so. Without our prior written consent, modification of the materials, use of the materials on any other platform or networked computer environment or use of the materials for any purpose other than personal, non-commercial use is a violation of the copyrights, trademarks and other proprietary rights, and is prohibited.
<br><b>7. INDEMNITY AND LIMITATION OF LIABILITY</b><br>
<br><b>7.1 Indemnity</b><br>
You shall indemnify and hold harmless Scaleup and its affiliates, and their respective officers, directors, agents, employees and representatives, from any claim or demand, or actions including reasonable attorney's fees, made by any third party or penalty imposed due to or arising out of: your use of Lending Services; breach of your representations, warranties, or obligations set forth in these Terms; any dispute or litigation caused by your actions or omissions; your negligence or violation or alleged violation of any applicable law, rules or regulations or the rights of any third party; any unauthorised transaction using your Credentials under the Lending Services.
<br><b>7.2 Release</b><br>
7.2.1 You hereby expressly release Scaleup and its affiliates and/or any of their directors, officers, employees, agents and representatives from any direct or indirect cost, damage, liability or other consequence of any actions or omissions of any Lender and specifically waive any claims or demands that you may have in this regard under any statute or contract, in equity, or otherwise.
7.2.2 We and our affiliates are not responsible for examining or evaluating, and we do not warrant or endorse the offerings of any Lenders, or assume any liability for the actions or omissions, the content of their marketing materials, websites or other sales channels and any other third-parties.
<br><b>8. MISCELLANEOUS</b><br>
<br><b>8.1 Disclaimer of Warranties</b> THE LENDING SERVICES AND ALL RELATED INFORMATION, CONTENT, MATERIALS, AND SERVICES MADE AVAILABLE TO YOU ARE PROVIDED BY US ON AN "AS IS" AND "AS AVAILABLE" BASIS. SCALEUP MAKES NO REPRESENTATIONS OR WARRANTIES OF ANY KIND, EXPRESS OR IMPLIED, AS TO LENDING SERVICES OR THE PLATFORM INCLUDING WITHOUT LIMITATION: (A) ANY IMPLIED WARRANTIES OF MERCHANTABILITY, SATISFACTORY QUALITY, SUITABILITY, RELIABILITY, COMPLETENESS, PERFORMANCE, FITNESS FOR A PARTICULAR PURPOSE, TITLE, OR NON-INFRINGEMENT; (B) THAT THE LENDING SERVICES WILL MEET YOUR REQUIREMENTS, WILL ALWAYS BE AVAILABLE, ACCESSIBLE, UNINTERRUPTED, TIMELY, SECURE, OPERATE WITHOUT ERROR, OR WILL CONTAIN ANY PARTICULAR FEATURES OR FUNCTIONALITY; (C) ANY IMPLIED WARRANTY ARISING FROM COURSE OF DEALING OR TRADE USAGE, UNLESS OTHERWISE SPECIFIED IN WRITING. TO THE FULLEST EXTENT PERMITTED BY APPLICABLE LAW, WE AND OUR AFFILIATES (AND OUR AND THEIR RESPECTIVE EMPLOYEES, DIRECTORS, AGENTS AND REPRESENTATIVES) WILL NOT BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, PUNITIVE, OR CONSEQUENTIAL DAMAGES ARISING OUT OF OR IN CONNECTION WITH THESE TERMS OR THE LENDING SERVICES. IN ADDITION, AND WITHOUT LIMITING THE FOREGOING, TO THE FULLEST EXTENT PERMITTED BY APPLICABLE LAW, WE AND OUR AFFILIATES (AND OUR AND THEIR RESPECTIVE EMPLOYEES, DIRECTORS, AGENTS AND REPRESENTATIVES) WILL NOT BE LIABLE FOR ANY DIRECT OR INDIRECT DAMAGES ARISING OUT OF OR IN CONNECTION WITH THE LENDING SERVICES.
<br><b>8.2 APPLICABLE LAW </b>The laws of India without regard to the principles of conflict of laws will govern these Terms and any dispute of any kind that may arise between you and Scaleup.
<br><b>8.3 DISPUTES</b><br>
8.3.1 To expedite resolution and control the cost of any dispute, controversy, or claim related to these Terms (each a <b>"Dispute"</b>) brought by either you or us (individually, a <b>“Party”</b> and collectively, the <b>“Parties”</b>), the Parties agree to first attempt to negotiate any Dispute (except those Disputes expressly provided below) informally for at least ninety (90)days before initiating arbitration. Such informal negotiations commence upon written notice from one Party to the other Party.
8.3.2 If the Parties are unable to resolve a Dispute through informal negotiations, the Dispute (except those Disputes expressly excluded below) will be finally and exclusively resolved by binding arbitration in accordance with the Arbitration and Conciliation Act, 1996, as amended, and judgment upon the award rendered by the arbitrators may be entered in any court having jurisdiction in respect thereof. The terms of this Agreement have been executed and delivered and shall be interpreted, construed and enforced in accordance with the laws of India. The venue for arbitration shall be Indore, Madhya Pradesh. 19.4 Any party to the dispute shall be entitled to serve a notice invoking this clause and making a reference to a sole arbitrator to be jointly appointed by the disputing Parties. If the Parties are unable to appoint the arbitrator hereunder by mutual agreement, the arbitrator shall be appointed in accordance with the Arbitration and Conciliation Act, 1996 (“Arbitration Act”). The arbitration proceedings shall be carried out in accordance with the Arbitration Act which shall be deemed to be incorporated into this Clause. The decision of the arbitrator shall be binding and in writing. Except as may be otherwise determined by the arbitrator, each Party shall pay its own fees, disbursements and other charges of its counsels, and the fees and expenses of the arbitrator shall be shared equally by the Parties.
8.3.3 You agree that you shall only be entitled to pursue remedies under this Clause 8.3 in case of any Dispute with Scaleup or in case of a Dispute with any other person, including any Lender, to which Scaleup is sought to be made a party by you or such other person, and that you shall not seek any other relief or initiate any other proceedings, including under the Consumer Protection Act, 2019.
<br><b>Exceptions to Arbitration</b><br>
The Parties agree that the following Disputes are not subject to the above provisions concerning binding arbitration: any Dispute seeking to enforce or protect, or concerning the validity of, any of the intellectual property rights of a Party; any Dispute related to, or arising from, allegations of theft, piracy, invasion of privacy, or unauthorized use; and any claim for injunctive relief. Subject to foregoing provisions of this Clause 8.3, Disputes arising from or relating to Lending Services shall be subject to the exclusive jurisdiction of courts at Indore, India.
<br><b>8.4 SEVERABILITY</b><br>
If any of the terms and conditions of these Terms shall be deemed invalid, void, or for any reason unenforceable, such terms and conditions shall be deemed severable and shall not affect the validity and enforceability of any remaining terms and conditions of these Terms.
<br><b>8.5 ASSIGNMENT</b><br>
You may not assign or transfer any rights, obligations, or privileges that you have under these Terms without the prior written consent of us and our Lenders. Subject to the foregoing, these Terms will be binding on each party’s successors and permitted assigns. Any assignment or transfer in violation of these Terms will be deemed null and void. We shall have the right to assign these Terms without your prior consent or intimation to you.
<br><b>8.6 WAIVER</b><br>
Our waiver of any breach of these Terms by any User will not constitute a waiver of any other prior or subsequent breach of these Terms. Our failure to insist upon strict compliance with the provisions of these Terms by any User will not be deemed a waiver of any rights or remedies that we may have against that or any other User. We may waive compliance with these Terms in our sole discretion.
<br><b>8.7 ENTIRE AGREEMENT</b><br>
These Terms, together with any other terms and conditions, rules, or regulations incorporated herein or referred to herein constitute the entire agreement between you and us relating to the subject matter hereof and supersede any prior understandings or agreements (whether oral or written) regarding the subject matter and may not be amended or modified except in writing or by making such amendments or modifications available on the Platform.
<br><b>8.8 LEGAL ACTION</b><br>
Nothing contained in these Terms will limit us or our affiliates in the exercise of any legal or equitable rights or remedies.
<br><b>8.9 GRIEVANCE REDRESSAL</b><br>
The User may reach out to Scaleup for any complaints/queries/issues in relation to the loan at the below mentioned details: Name: Vishal Bhatt – Grievance Officer E-mail ID: grievance@scaleupfin.com We shall endeavour to resolve any such complaints/queries/issues in coordination with the Lenders. We may have to direct the User to the Lenders for resolutions of some of the complaints/queries/issue. Alternatively, the User may reach out to the Lenders for any complaints/queries/issues as per details mentioned in the Loan Documents.
<br><b>Annexure I</b><br>
<br><b>AUTHORISED LENDERS</b><br>
A list of our authorized Lenders is as follows:
1. Blacksoil Capital Private Limited 2. Arthmate Financing India Private Limited (formerly known as Mamta Projects Pvt Ltd) Please note that the above list may be modified from time to time. We advise you to periodically review this list to stay informed of updates regarding our authorized Lenders.
<br><b>Annexure II</b><br>
<br><b>DIGITAL LENDING PRIVACY NOTICE</b><br>
Scaleupfincap Private Limited <b>(“Scaleup” “we”, “our” or “us”)</b> is acting as an intermediary for making available loans, credit facilities in the nature of buy now pay later limits (<b>“Scaleup Pay”</b>) and personal loans and any other similar product (together “Lending Services”) to its users(<b>“Users” or “you”</b>), on Scaleup (including sub-domains and microsites), as well as any other mobile website or mobile application related, linked, or otherwise connected thereto (collectively, the “Platform”) in collaboration with our lending partners and co-lender, if any, engaged by lending partner from time to time (collectively, “Lenders”). We take the privacy of your information seriously. This Privacy Notice describes the types of personal information we collect from you through our Platform and all other mediums through which we offer Lending Services. It also describes the purposes for which we collect that personal information, the other parties with whom we may share it and the measures we take to protect the security of your data. It also tells you about your rights and choices with respect to your personal information, and how you can contact us about our privacy practices. You are advised to carefully read this Privacy Notice before using or availing any Lending Services through our Platform.
<br><b>1. DEFINITIONS AND KEY CONCEPTS</b><br>
In this Privacy Notice, the following definitions are used:
<br><b>Data</b><br>
Personal information, including sensitive personal information (as defined under Data Protection Laws) about you, which we collect, receive, or otherwise process in connection with your use of our Platform and as more specifically set out in Clause 2 below.
<br><b>Cookies</b><br>
A small file placed on your device by our Platform when you either visit or use certain features of our Platform. A cookie generally allows a website or mobile application to remember your actions or preference for a certain period of time.
<br><b>Data Protection Laws></b><br>
Any applicable law in India for the time being in force relating to the processing of Data.
<br><b>Lending Partners</b><br>
Select banks, non-banking financial institutions (including the co-lenders, if any, engaged by Lending Partner from time to time) and other financial institutions with whom we have contracts for the purposes described in this Privacy Notice.
<br><b>Service Providers</b><br>
Entities (including financial institutions and Credit Information Companies) which provide services to us and to whom we may disclose your Data for a specific purpose pursuant to a written contract.
<br><b>Scaleupfincap Private Limited (“Scaleup”)</b><br>
Scaleupfincap Private Limited, a company incorporated in India whose registered office is at 1501, 15th Floor, SKYE Corporate Park, Scheme No. 78, Part-II, Sector-B, Vijay Nagar, Indore-452010, M.P. India.
<br><b>User or you</b><br>
The natural person who accesses our Platform and accesses or avails the Lending Services.
<br><b>2. WHAT DATA DO WE COLLECT ABOUT YOU</b><br>
When you visit our Platform or avail any Lending Services, we may collect certain Data about you. This Data includes, without limitation, the following categories:
<br><b>Personal information:</b> first and last name, age, employment status, nationality, date of birth, gender and other similar data.
<br><b>Contact information:</b> email address, postal address, country, phone number and other similar contact data.
<br><b>Financial information:</b> credit limit, credit score, credit information report, payment information (such as method, mode and manner of payment), preferences, spending pattern or trends and other similar data.
<br><b>Transaction information:</b> date of the transaction, transaction amount, transaction history and related details.
<br><b>Facility specific information:</b> photograph, signature image/specimen, proof of income, PAN, address proof, identity proof and such other similar information.
<br><b>Technical information:</b> Platform usage, Internet Protocol (IP) address, your participation in any marketing program, promotions, one time access to your device (such as camera, microphone or location for onboarding/KYC requirements) and similar information collected via automated means, such as cookies, pixels and similar technologies which collect information in relation to the applications on your device and your financial SMSs.
<br><b>Feedback information:</b> Your reviews, feedback, opinions, correspondences about our Platform, products and services. In addition to the above we also collect your Data in the following manner for providing better Lending Services to You:
<br><b>I. COLLECTION OF FINANCIAL SMS INFORMATION</b><br>
We don’t collect, read or store your personal SMS from your inbox. We collect and monitor only financial SMS sent by 6-digit alphanumeric senders from your inbox which helps us in identifying the various bank accounts that you may be holding, cash flow patterns, description and amount of the transactions_screen undertaken by you as a user to help us perform a credit risk assessment which enables us to determine your risk profile and to provide you with the appropriate credit analysis. This process will enable you to take Lending Services from Lending Partners available on the Platform. This Financial SMS data also includes your historical data.
<br><b>II. COLLECTION OF DEVICE INFORMATION</b><br>
Information the Platform collects, and its usage, depends on how you manage your privacy controls on your device. When you install the Platform, we store the information we collect with unique identifiers tied to the device you are using. We collect information from the device when you download and install the Platform and explicitly seek permissions from You to get the required information from the device. The information we collect from your device includes the hardware model, build model, RAM, storage; unique device identifiers like serial number, SSAID; SIM information that includes network operator, roaming state, MNC and MCC codes, WIFI information that includes MAC address and mobile network information to uniquely identify the devices and ensure that no unauthorized device acts on your behalf to prevent frauds.
<br><b>III. COLLECTION OF INSTALLED APPLICATIONS</b><br>
We collect a list of the installed applications’ metadata information which includes the application name, package name, installed time, updated time, version name and version code of each installed application on your device to assess your credit worthiness and enrich your profile with pre-approved customized loan offers. Our Platform has a link to a registered third-party SDK which collects Data on our behalf and Data is stored to a secured server to perform a credit risk assessment. We ensure that our third-party Service Provider takes extensive security measures in order to protect your Data against loss, misuse or alteration of the Data. Our third-party service provider employs separation of environments and segregation of duties and have strict role-based access control on a documented, authorized, need-to-use basis. The stored Data is protected and stored by application-level encryption. They enforce key management services to limit access to Data. Furthermore, our registered third-party service provider provides hosting security - they use industry-leading anti-virus, anti-malware, intrusion prevention systems, intrusion detection systems, file integrity monitoring, and application control solutions. You can make choices about our collection and use of your Data. For example, you may want to remove your Data on our Platform. When you are asked to provide Data, you may decline. For more information, please see the section below, titled “Your Rights and Choices”.
<br><b>3. HOW WE COLLECT DATA</b><br>
We collect Data in the following ways:
Information You Give Us: We receive and store any information you enter on our Platform or give us in any other way. For instance: when you register with us to avail the products and/or services including Lending Services offered on our Platform; when you conduct/attempt a transaction on our Platform or by using Lending Services; when you share and/or upload information/documents, as and when you avail any Lending Services offered by our Lenders. when you elect to receive any communications (including promotional offers) from us; from the information gathered by your visit to our Platform and/or your participation in any survey, marketing program or promotions sponsored by us; and When you send correspondence to us through email, calls or any other medium.
Automatic Information We Collect: We use “cookies”, pixels and similar technologies to receive and store certain types of information whenever you interact with us. For instance: Our Platform may place and access certain Cookies on your device. We also use pixels and similar technologies to analyse traffic on our Platform to improve user experience. Our web servers or affiliates, or Service Providers who provide analytics and performance enhancement services and with whom we have specific agreements, collect IP addresses, operating system details, browsing details, device details, application details, SMS data and language settings. This information is aggregated to measure the number of visits, average time spent on the Platform, pages viewed and similar information. We use this information to improve content and to prevent fraud, ensure safety and security, as well enhance performance of our Platform.
Information from Other Sources: We may obtain information from other sources. For instance When You agree to appoint Scaleup as your authorized agent/ representative for collecting your credit information from Credit Information Companies. When we receive your data from our Lenders for facilitating your access to key fact statements, loan agreements, loan servicing and other related documents.
<br><b>4. OUR USE OF DATA</b><br>
Data collected by us may be used by us for the following reasons: carry out our obligations arising from any contract entered into between Lending Partners and us; carry out our obligations arising from any contract entered into between you and us; provide products and/or services and communicate with you about products and/or services offered by us and/or our Lending Partners including processing any transactions_screen; enable Lending Partners to offer their products and/or services and communicate with you about such products and/or services; provide you with pre-approved offers (for financial products and/or services), personalized services, recommendations and improve your experience on our Platform, including, where permitted under applicable law, by storing and/or using your information to enable future interactions/transactions_screen on Platform to run more smoothly; checking your eligibility for Lending Services and providing you access to the services being offered by us and/or our Lending Partners. operate, evaluate and improve our business, products/services including Lending Services and Platform; generate aggregated data to prepare insights to enable us to understand customer behaviour, patterns and trends with a view to learning more about your preferences or other characteristics; provide marketing and promotional campaigns to you based on your profile; communicate with you (including to respond to your requests, questions, feedback, claims or disputes) and to customize and improve our services; protect against and prevent fraud, illegal activity, harm, financial loss and other legal or information security risks; and serve other purposes for which we provide specific notice at the time of collection, and as otherwise authorized or required by applicable law.
<br><b>5. MINORS</b><br>
Our Platform does not offer products or services for use by minors.
<br><b>6. SHARING OF DATA</b><br>
We may share your Data in the following ways:
<br><b>Lending Partners:</b> We may make the Lending Services available to you. If you choose to use such Lending Services, Data will be shared with our Lenders. Lenders may use your Data for the purposes of providing their own products or services to you. Their use of your Data is subject to their own privacy policies. For further information on how these Lenders process your Data, please refer to their privacy policies.
<br><b>Service Providers:</b> We may share your Data with Service Providers who may, in the course of providing their respective services, receive and process Data. Examples include storing and analysing Data, protecting and securing our systems, providing customer service, recovery of outstanding dues (acting as recovery agents), credit analysis, processing your Data for profiling, fraud detection, user analysis and transaction processing. These Service Providers will be required to only process Data in accordance with our instructions. The Service Providers will also be required to safeguard the security and confidentiality of the Data they process by implementing appropriate technical and organizational security measures.
<br><b>When Scaleup acts as a Service Provider:</b> We may process and share your Data with Lenders when we act as a service provider to such Lenders. In this case, for the purposes of relevant Data Protection Laws, we act under the instructions of, the relevant Lenders.
<br><b>Protecting Scaleup:</b> We may release Data when we believe that disclosure is reasonably necessary (a) to comply with a law, regulation or compulsory legal request; (b) to protect Scaleup intellectual property rights; (c) to protect Scaleup against harm or financial loss; (d) when we believe disclosure is necessary to protect individuals’ vital interests, or (e) in connection with an investigation of suspected or actual fraudulent or illegal activity. This may include exchanging information with other companies and organizations for fraud protection, risk management and dispute resolution.
<br><b>Business Transfers:</b> As we continue to develop our business, we might sell or buy subsidiaries or business units. Your Data may be transferred as part of such transactions_screen.
<br><b>Third Parties:</b> We may also share your Data with other third parties where: You request or authorize us to do so;
We need to comply with applicable law or respond to valid legal process; or
We need to operate and maintain the security of our Platform, including to prevent or stop an attack on our computer systems or networks.
The sharing of your Data will be in line with the processes set out in this Privacy Notice.
<br><b>7. WHERE WE STORE DATA</b><br>
We store your Data on secure servers located in India.
<br><b>8. KEEPING DATA SECURE</b><br>
We will use technical and organisational measures to safeguard your Data. Technical and organisational measures include measures to deal with any suspected data breach. We take every breach/security incident with utmost seriousness. We maintain security operations which ensure proper monitoring, investigation and reporting of all major as well as minor security incidents. If you suspect any misuse or loss or unauthorised access to your Data, please let us know immediately by contacting us by e-mail. The security of your Platform account depends on you keeping your account password(s), PINs and other access information confidential. If you share your Platform account information with a third party, they will have access to your account and your Data. It is your responsibility to control access to your device and Platform on your device, including keeping your password(s) and/or PIN confidential and not sharing it with anyone. It is also your responsibility to alert us if you believe that the security of your Data in the Platform has been compromised.
<br><b>9. RETENTION OF DATA</b><br>
Scaleup retains Data for as long as necessary for the use of our products and/or services or to provide access to and use of our Platform, or for other essential purposes such as complying with our legal obligations, resolving disputes, enforcing our agreements; and as long as processing and retaining your Data is necessary for our legitimate interests and operations. Because these needs can vary for different data types and purposes, actual retention periods can vary significantly.
We responsibly and securely dispose your Data that is no longer required by us, using formal procedures that are established to protect any confidential Data from leakage. Your Data shall be protected against unauthorized access, misuse, or corruption during transportation. In the case of lost devices, incident management is undertaken as per our protocol for reporting security incidents including steps including but not limited to remote wipe of device, revoking tokens, de-authorising, etc.
Even if we delete your Data, including on account of exercise of your right under Clause 10 below, it may persist on backup or archival media for audit, legal, tax or regulatory purposes.
We reserve the right to retain your Data as necessary, to implement, administer and manage your participation on the Platform and to satisfy our legal, audit, tax or regulatory obligations.
<br><b>10. YOUR RIGHTS AND CHOICES</b> Subject to applicable law, You are be entitled to exercise following rights in relation to your Data stored with us:
<br><b>Right to Restrict our Use of your Data - </b>you have the right to request that we restrict our processing of your Data in certain circumstances, for example if you dispute the accuracy of the Data that we hold about you or you object to our processing (including disclosure to third parties and retention) of your Data.
<br><b>Right to Withdraw Consent –</b> where we have obtained your consent to process your Data for certain activities, you may withdraw this consent at any time, and we will cease to carry out that particular activity that you previously consented to unless we consider that there is an alternative legal basis to justify our continued processing of your Data for this purpose. To get in touch with us about these rights, or for more information about managing your Data and promotional communications, please use the contact details set out in the section below, titled “How to Contact Us”. Please note that we may keep a record of your communications to help us resolve any issues which you raise. Where we are legally permitted to do so, we may refuse your request. It is important that the Data we hold about you is accurate and current. Please keep us informed if your personal information changes during the period for which we hold it.
<br><b>11. SEVERABILITY</b><br>
If any court or competent authority finds that any provision of this Privacy Notice (or part of any provision) is invalid, illegal or unenforceable, that provision or part-provision will, to the extent required, be deemed to be deleted, and the validity and enforceability of the other provisions of this Privacy Notice will not be affected.
<br><b>12. LINKS TO OTHER WEBSITES</b><br>
Our Platform may, from time to time, provide links to websites and applications of third parties and Lending Partners whose privacy practices differ from those of Scaleup. We have no control over such websites and applications and are not responsible for the content of those websites and applications. If you provide Data to any of those websites or applications, then the use your Data is governed by their privacy notices. This Privacy Notice applies to our Platform only.
<br><b>13. CHANGES TO THIS PRIVACY NOTICE</b><br>
Our business changes constantly and our Privacy Notice will also change. We may e-mail periodic reminders of our notices and conditions, unless you have instructed us not to, but you should check our Platform frequently to see recent changes. The updated version will be effective as soon as it is accessible and available on Platform. We encourage you to review this Privacy Notice frequently to be informed of how we are protecting your information.
<br><b>14. HOW TO CONTACT US</b><br>
To request to review, update, or delete your personal information or to otherwise reach us, please submit a request by e-mailing us at customercare@scaleupfin.com. You may contact us for information on Service Providers, Lending Partners and other entities with whom we may share your Data in compliance with this Privacy Notice and applicable law. We will respond to your request within 30 days.
<br><b>15. NODAL GRIEVANCE OFFICER</b><br>
Please see below the details of our nodal grievance officer:
<br><b>Name:</b> Vishal Bhatt – Grievance Officer
<br><b>Email:</b> grievance@scaleupfin.com
<br><b>Address:</b> 1501, 15th Floor, SKYE Corporate Park, Scheme No. 78, Part-II, Sector-B, Vijay Nagar, Indore-452010, M.P. India.
<br><b>ANNEXURE III
<br>Buy Now Pay Later Terms AND CONDITIONS
<br>Terms and Conditions</b>

<br>1. I confirm that I have carefully read and fully understood all the terms and conditions that are listed online at https://Lender.co.in/terms-conditions/ and those applicable to availing financing facility from the Lender As mentioned in schedule I and its co-lender, if any, and privacy requirements that are listed online at & https://Lender.co.in/privacy-policy/. I accept the terms & conditions unconditionally and agree that these terms and conditions may be amended or modified by SCALEUP (Company) at any time and I will be bound by the amended terms & conditions that are in force
<br>2. I confirm that I am a resident of India and at least 18 (Eighteen) years of age.
<br>3. I can read, write and understand English language and is of sound mind. Further to this I have no objections in receiving communications with respect to this facility in English language.
<br>4. I understand that sanction of the facility is at the sole discretion of Lender and it reserves the right to reject my application for the facility without assigning any reasons whatsoever.
<br>5. I understand that the facility sanctioned to me is funded both by Lender and its co-lender, if any, in a specific proportion.
<br>6. I shall indemnify Lender (its agents, employees, officers and directors) against all or any losses suffered by Lender (its agents, employees, officers and directors) on account of breach of undertakings, representations and warranties by me including any legal action / proceedings initiated by me or any third party in connection with this Agreement and unauthorized access to or storage of my information or Personal Data by Lender (its agents, employees, officers and directors) which are solely attributable to any breach, negligence or fraud by me.
<br>7.I declare that all the particulars and information and details given / filled in the application form provided by Lender and its co-lender, if any, and information provided by me to Lender and its co-lender, if any, are true, correct and accurate and I have not withheld / suppressed any material and relevant information from Lender and its co-lender, if any.
<br>8. By accepting these terms and conditions and availing the facility, I understand that my successors, heirs and assigns will also be bound by the terms of this facility.
<br>9. I hereby agree to provide Lender and its co-lender, if any, with all information and documents as may be required by Lender and its co-lender, if any, in order to complete the Know Your Customer (KYC) requirements as required under applicable law. I acknowledge that Lender and its co-lender, if any, may conduct KYC in any manner permitted under applicable law, including without limitation, (i) collection and verification of physical copies of the documents; (ii) eKYC or offline Aadhaar XML KYC or Digilocker Aadhaar XML KYC in accordance with paragraph below; (iii) Obtaining documents through Central KYC repository with my explicit consent or (iv) obtaining KYC information and documents from a third party in accordance with applicable law. Further, Lender and its co-lender, if any, may also avail the services of a third party for the purpose of conducting KYC.
<br>10. I also authorize NSDL e-Governance Infrastructure Limited (NSDL e-Gov) to and in respect of the following activities, on behalf of Lender and its co-lender, if any : i, Use my Aadhaar details for KYC proof, enabling me to eSign the loan agreement and/or eSign the Mandate and authenticate my identity through the Aadhaar Authentication system (Aadhaar based e-KYC services of UIDAI) in accordance with the provisions of the Aadhaar (Targeted Delivery of Financial and other Subsidies, Benefits and Services) Act, 2016 and the allied rules and regulations notified thereunder and for no other purpose; ii. Authenticate my Aadhaar through one-time password ("OTP") or Biometric for authenticating my identity through the Aadhaar Authentication system for obtaining my e-KYC through Aadhaar based e-KYC services of UIDAI and use my Photo and Demographic details (Name, Gender, Date of Birth and Address) for KYC proof, in connection with the loan agreement and the Mandate and for no other use / purpose; iii. I agree that Lender and its co-lender, if any, may avail services from any third party to conduct Aadhaar based KYC authentication i.e. authentication services provided by UIDAI, where my personal identity information /data that is obtained from me and matched with the personal identity information/data that is stored in the UIDAI's central identity data repository in order to provide Aadhaar enabled services to me;
<br>11. I agree that Lender and its co-lender, if any, may receive and update credit reports, basis their respective share in the sanctioned facility, from any/all credit bureaus or any other agency/ regulatory authority as required and as permitted under applicable law
<br>12. Lender makes no representations about:
<br>a. the timeliness, of the services contained on the Lender its website and/or mobile application for any purpose; and
<br>b. the suitability, reliability, availability, of the services contained on the Lender website and/or mobile application for any purpose.
<br>13. Lender shall (and shall procure that its agents, employees, directors and officers shall) comply with all Data Protection Legislations and such compliance shall include, but not be limited to, maintaining a valid and up to date registration or notification (where applicable) under the Data Protection Legislation. For the purpose of this Agreement, "Data Protection Legislation" means the legislation and regulations relating to the protection of Personal Data and processing, storage, usage, collection and/or application of Personal Data or privacy of an individual including (without limitation):
<br>i. the Information Technology Act, 2000 (as amended from time to time), including the Information Technology (Reasonable Security Practices and Procedures and Sensitive Personal Data or Information) Rules, 2011 ("Privacy Rules") and any other applicable rules framed thereunder;
<br>ii. all other applicable banking industry guidelines (whether statutory or non-statutory) or statutorily-backed codes of conduct relating to the protection of Personal Data and processing, storage, usage, collection and/or application of Personal Data or privacy of an individual issued by any regulator and applicable to us to any of the Parties; and
<br>iii. any other Applicable Law solely relating to the protection of Personal Data and processing, storage, usage, collection and/or application of Personal Data or privacy of an individual.
<br>14. By availing the loan from Lender and its co-lender, if any, under these terms and conditions, I acknowledge that Lender and its co-lender, if any, may use my data or information in connection with the loan, including without limitation for the processing of the loan application. In this regard, the customer agrees and consent for Lender and its co-lender, if any, to share the information or data pertaining to the customer with any third party which is involved in the processing of the application, or use of the loan facility etc.
<br>15. I hereby declare that no other account has been opened nor will be opened using the OTP based KYC in non-face-to-face mode.
<br>16. I understand and acknowledge that Lender and its co-lender, if any, reserves the right to modify the sanctioned facility amount as per its internal policy at its discretion without assigning any reasons.
<br>17. Lender reserves the right to cancel / suspend the services of the facility if in Lender's opinion the security of the website and/or mobile application or of the data could be compromised for any specific customer, without assigning any reasons. I further authorize Lender and all its group companies to keep me informed (vide telephone, SMS, mail, e-mail etc.) in relation to the facility and also for any such promotional schemes and/or activities as they may require.

<br><b>PRIVACY POLICY</b><br>
Welcome to Scaleup (the “Application”) owned by Scaleupfincap Private Limited, (“Our”, “Us”, “We”, “Scaleup”, “Application” ). This Privacy Policy (the “Privacy Policy”) along with the Terms of Use provides the terms and conditions governing Your use of this Application. At Scaleup, we value Your trust & respect Your privacy. Unless otherwise defined in this Privacy Policy, terms used in this Privacy Policy have the same meanings as in Our Terms and Conditions at “Scaleup”. This Privacy Policy provides You with details about the manner in which Your data is collected, stored & used by Us. You are advised to read this Privacy Policy carefully. By visiting Our Application You expressly give Us consent to use & disclose Your personal information in accordance with this Privacy Policy. If You do not agree to the terms of the policy, please do not use or access Our Website or application.
The expressions “You”, “Your” or “User”, whenever the context so requires, for the purposes of this Privacy Policy, shall mean any natural or legal person who may create by registration, membership account on this Application or agree to avail Our Services through this Application, or otherwise access Our Application.
This Privacy Policy is published by Us, in compliance of:
<br>1. Section 43A of the Information Technology Act, 2000; and.
<br>2. Regulation 4 of the Information Technology (Reasonable Security Practices and Procedures and Sensitive Personal Information) Rules, 2011 .
Regulation 4 of the Information Technology (Reasonable Security Practices and Procedures and Sensitive Personal Information) Rules, 2011
General
We will not sell, share or rent Your personal information to any third party or use Your email address/mobile number for unsolicited emails and/or SMS. Any emails and/or SMS sent by Us will only be in connection with the provision of agreed Services & products and this Privacy Policy. To carry out general marketing We would be sending out emails to users registered on Our Application (or by any means and in any media, including, but not limited to, on Our Application or through Our merchants or in advertisements / marketing campaigns / any form of audio or visual media or websites). We reserve the right to communicate Your personal information to any third party that makes a legally-compliant request for its disclosure.
<br><b>Collection of Information</b><br>
In order to provide Our Services, we may collect the following types of information:
<br>• User information – When You use the Services, we automatically receive and record information from Your device and, applicable browser. Such information may include Your Contacts, location of Your device, text messages, Your device storage, Your IP address, cookie information, software and hardware attributes and unique device ID. Most of the information We collect during Your use of Our Application, such as Your device and hardware IDs and device type, the content of Your request, and basic usage stats about Your device and general use of Our Services does not by itself identify You to Us, though it may be unique or consist of or contain information that You consider personal. Specifically, we collect, retain and use information collected, retained and shared through Facebook Platform, Twitter, Google and YouTube, according to the applicable terms and conditions of their privacy policies.
<br>• User Id – In order to avail the services, you shall have to sign up on the Application.
<br>• Use history and preferences – We save Your query terms as well as the experience/category selected, these may associate with the unique User ID of Your device. We also save Your preferences as recorded through Your use of the Services and use them for personalization features.
<br>• Cookies – When You use Our Services, we may send one or more cookies. We use cookies to improve the quality of Our Service by storing User preferences and tracking User information. Certain of Our products and services allow You to download and/or personalize the content You receive from Us. For these products and services, we will record information about Your preferences, along with any information You provide yourself. Cookies, small data files stored on the device, help us distinguish you from other users and to remember your preferences. This enhances the experience and allows us to improve services. a. Cookies identify you without accessing personal data like email addresses. Data collected via cookies helps us manage and personalize services, granting access to certain features. b. Third parties may place cookies on specific pages; we don’t control their cookie usage. c. We use cookies to enhance your experience. You can configure the browser to refuse or alert about cookies, but this may affect website functionality. Website and application Disclaimer We use cookies to give you the best possible experience with scaleupfincap.com and Scaleup App. Some are essential for this site to function; others help us understand how you use the site, so we can improve it. We may also use cookies for targeting purposes. Click “Accept all cookies” to proceed as specified or click “Manage my preferences” to choose the types of cookies you will accept.
<br><b>Use of Information</b><br> 

<br>• The Personal Information We collect allows Us to keep You posted on Our latest announcements, upcoming events, including confirmations, security alerts and support and administrative messages. It also helps Us to improve Our Services. If You do not want to be on Our mailing list, you can opt out at any time by updating Your preferences on the Website.
<br>• From time to time, we may use Your Personal Information to send important notices, such as communications and changes to Our terms, conditions and policies. Since, this information is important to Your interaction with Us, you cannot opt out of receiving these communications.
<br>• We may also use Personal Information for internal purposes such as data analysis and research to improve Our Services, products and customer communication.
<br>• We collect Non-Personally Identifiable Information about Our users generally to improve features and functionality of the Application. We may analyse trends through aggregated demographic and psychographic offers to users. We may also share this Non-Personally Identifiable Information with Our partners to allow them to assist Us in delivering tailored advertisements, promotions, deals, discounts, and other offers to You when You use the Services. We collect information from You when You participate in sweepstakes, games or other promotions offered on Our Application.
<br>• We may also collect information about You through other methods, including research surveys or information We obtain from third parties, including verification services, data services, as well as public sources.
Sharing of Personal Information
We only share personal information with other companies or individuals in the following limited circumstances:
<br>• We may share with third parties the location of Your device in order to improve and personalize Your experience of the Services.
<br>• We may share with third party certain pieces of non-personal information, such as the number of Users who used a particular service, users who clicked on a particular advertisement or who skipped a particular advertisement, as well as similar aggregated information. Such information does not identify You individually.
<br>• We may share with third parties’ Unique Device ID. While such information does not by itself identify You to us, it may be unique or consist of or contain information that You consider personal, however such information does not identify You individually.
<br>• We provide such information to trusted businesses or persons for the purpose of processing personal information on Our behalf. We require that these parties agree to process such information based on Our instructions and in compliance with this Privacy Policy and any other appropriate confidentiality and security measures.
<br>• Advertisers: We allow advertisers and/or merchant partners (“Advertisers”) to choose the demographic information of users who will see their advertisements and/or promotional offers and You agree that We may provide any of the information We have collected from You in non-personally identifiable form to an Advertiser, in order for that Advertiser to select the appropriate audience for those advertisements and/or offers.
<br>• If You sign through a third-party social networking site or service, your list of “friends” from that site or service may be automatically imported to the website/Application and or service. Again, we do not control the policies and practices of any other third-party site or service.
<br><b>Security</b><br>
The security of Your personal information is important to Us. We take precautions, including administrative, technical and physical measures, to safeguard Your personal information against loss, theft and misuse, as well as against unauthorized access, disclosure, alteration and destruction. When You enter sensitive information on Our registration, we encrypt that information.
This Application has various electronic, procedural and physical security measures in place to protect the loss, misuse and alteration of information, or any accidental loss, destruction or damage to data. When You submit Your information via the Application, your information is protected through Our security systems.
<br><b>Accessing Third Party Websites</b><br>
Mobile site and mobile application may contain links to other websites. Please note that when you click on one of these links, you are entering another website for which Scaleup has no responsibility. We encourage you to read the privacy statements of all such sites as their policies may be materially different from this Privacy Policy. Of course, you are solely responsible for maintaining the secrecy of your passwords, and your membership account information. Please be very careful, responsible, and alert with this information, especially whenever you're online.
<br><b>Protection of Children</b><br>
If You are a User under the age of 18 (“Child User”), please ensure that You have adequate consent from Your parent or guardian to access Services in accordance with the present Privacy Policy. If You are the parent or guardian of a Child User, please advise Your child of the risks of posting personal information on Our Services or other online services, and that any information posted may be used by third parties without restriction. Notwithstanding anything contained herein, we shall always presume that every User has adequate consent and free-will to access Services and to enter into a legally enforceable contract with Us.
We also reserve the right to remove, at Our sole discretion, any content or material posted by a User which may be of defamatory or sexual nature or offensive to other Users in any manner, and take appropriate legal action against such User in accordance with Our Terms of Use
<br><b>Cookies</b><br>
A cookie is a chunk of data that is sent to the Application from a server and stored on the hard drive of Your mobile (“Cookies”). A session Cookie disappears automatically after You close Your browser. A persistent Cookie remains after You close Your browser and may be used by Your browser on subsequent visits to the Services. We may use Cookies related information to: (a) remember Your data and/or personal information so that You will not have to re-enter it during Your visit or the next time You access the Services; (b) provide customized third-party advertisements, content, and information; (c) monitor the effectiveness of third-party marketing campaigns; (d) monitor aggregate site usage metrics such as total number of visitors and pages viewed; and (e) track Your entries, submissions, and status in any promotions or other activities.
We may allow third-party service providers, like advertisers, to place and read their own Cookies, web beacons, and similar technologies to collect Data and/or Personal Information through Services. This data and/or personal information are collected directly and automatically by these third parties, and We do not participate in these data transmissions and these third-party cookies are not covered under this Privacy Policy.
<br><b>Changes to the Privacy Policy</b><br>
We reserve the right to change the Privacy Policy at Our sole discretion. We will inform Users of any such change by Us posting the updated Privacy Policy on Our Application. We encourage You to review this Privacy Policy regularly for any such changes. Your continued use of the Services will be subject to the then-current Privacy Policy.
<br><b>Compliance with Laws and Law Enforcement</b><br>
We will cooperate with government and law enforcement officials and private parties to enforce and comply with the law. We reserve the right to track IP addresses for the purposes of fraud prevention, and to release IP addresses to legal authorities. We will disclose information about You to government or law enforcement officials or private parties when We believe reasonably necessary to comply with law, to protect the property and rights of Scaleup or a third party, to protect the safety of the public or any person, or to prevent or stop activity We may consider to be, or to pose a risk of being, any illegal, unethical or legally actionable activity.
<br><b>Email Notifications</b><br>
You may be contacted, by email or other means; for example, we may send You promotional offer on behalf of other businesses, or communicate with You about Your use of the service. Also, we may receive a confirmation when You open an email from us. This confirmation helps us improve Our service. If You do not want to receive email or other mail from us, please indicate Your preference by clicking on the “Unsubscribe” link at the bottom of the email or changing Your email settings on Your account settings page. Please note that if You do not want to receive legal notices from us, those legal notices will still govern Your use of the service, and You are responsible for reviewing such legal notices for changes.
<br><b>Contact Information</b><br>
If You have any questions or concerns with respect to this Terms of Use or the Website or any information contained on thereon, you may contact Us by writing to Us at [customercare@scaleupfin.com]. These Terms of Use supersede any previous versions.
<br><b>Grievance Redressal Mechanism</b>
<br><b>Grievance Officer : Vishal Bhatt</b>
<br><b>Email: customercare@scaleupfin.com</b>
<br><b>DECLARATION</b><br>
Customer hereby confirms that:
It is an institution duly authorized and effectively supervised by the prudential supervisory authorities of India; - it is duly authorized and empowered to conduct business in India - it is not shell bank and is established in a jurisdiction which is a member of the Financial Action Task Force (FATF); - it is not established in a jurisdiction which, according to the listings published by the FATF, is a high risk and non-cooperative jurisdiction, i.e. a jurisdiction which has strategic AML/CFT deficiencies and to which counter-measures apply or a jurisdiction with strategic AML/CFT deficiencies that has not made sufficient progress in addressing the deficiencies or have not committed to an action plan developed with the FATF to address the deficiencies; - it is subject to and complies with applicable laws and regulations relating to the combat against money laundering (AML) and terrorism financing (CFT), including customer due diligence obligations and obligations relating to the cooperation with public authorities, and has implemented procedures and internal control mechanisms in order to ensure compliance with such laws and regulations; - it applies monitoring measures and ensures that its customer files are checked regularly; Anti-Money Laundering Declaration July 2015 and it does and will not hold assets on behalf of customers or beneficial owners of customers
<br>(i) domiciled in a jurisdiction which, according to the listings published by the FATF, is a high risk and non-cooperative jurisdiction or
<br>(ii) which are subject to UN sanctions; - it is subject and complies with the provisions of the Prevention Of Money Laundering Act, 2002. - The customer also confirms that he/she will take the full responsibility of any payment made to Scaleup on behalf of his account by any third party and will make good all the losses resulting out of the action or consequences at its part. The customer confirms that it shall be solely responsible for all the costs, expenses and consequences thereof. </p><br><br>'''),
            Text(
              'By continuing. I agree to Scaleup T&Cs and Privacy Policy',
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
            SizedBox(height: 20),
            CommonElevatedButton(
              onPressed: () {
                accecptPermissions = true;
                Navigator.of(context).pop(accecptPermissions);
              },
              text: "Accept and Continue",
              upperCase: true,
            )
          ],
        ),
      ),
    );
  }
}
