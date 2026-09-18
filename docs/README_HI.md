# Leave Request Management System

[English](../README.md) | [தமிழ்](README_TA.md) | हिन्दी | [简体中文](README_ZH.md) | [Bahasa Indonesia](README_ID.md)

Salesforce पर आधारित **छुट्टी अनुरोध प्रबंधन प्रणाली**, जिसका उपयोग शिक्षकों और छात्रों के छुट्टी अनुरोधों को प्रबंधित करने के लिए किया जाता है।

यह परियोजना Salesforce की घोषणात्मक स्वचालन सुविधाओं, Apex विकास, REST API एकीकरण, रिपोर्ट, डैशबोर्ड और Lightning एप्लिकेशन डिज़ाइन को प्रदर्शित करती है।

## अवलोकन

यह प्रणाली उपयोगकर्ताओं को छुट्टी अनुरोध बनाने और प्रबंधित करने की सुविधा देती है। Salesforce अनुरोध की प्रारंभिक स्थिति को स्वचालित रूप से निर्धारित करता है और छुट्टी की अवधि के आधार पर उसका वर्गीकरण करता है।

![screenshot](../img/image.png)

इस परियोजना को एक व्यावहारिक Salesforce विकास परियोजना के रूप में बनाया गया है, ताकि **कम-कोड Salesforce क्षमताओं** और **Apex के माध्यम से प्रोग्रामिंग आधारित विकास** दोनों को प्रदर्शित किया जा सके।

## विशेषताएँ

* छुट्टी अनुरोध बनाना और प्रबंधित करना
* नए अनुरोधों की स्थिति को स्वचालित रूप से `Pending` करना
* 5 दिनों से अधिक के छुट्टी अनुरोधों को स्वीकृत होने से रोकना
* Apex का उपयोग करके छुट्टी की अवधि का स्वचालित वर्गीकरण
* छुट्टी अनुरोध बनाने के लिए REST API का समर्थन
* Apex इकाई परीक्षण
* छुट्टी अनुरोधों की निगरानी के लिए रिपोर्ट
* छुट्टी अनुरोध संबंधी डेटा को प्रदर्शित करने के लिए डैशबोर्ड
* प्रणाली तक केंद्रीकृत पहुँच के लिए कस्टम Lightning App

## तकनीकी स्टैक

| तकनीक                 | उपयोग                                       |
| --------------------- | ------------------------------------------- |
| Salesforce Platform   | अनुप्रयोग मंच                               |
| Lightning App Builder | अनुप्रयोग और उपयोगकर्ता इंटरफ़ेस का विन्यास |
| Flow Builder          | घोषणात्मक स्वचालन                           |
| Validation Rules      | डेटा सत्यापन                                |
| Apex                  | कस्टम व्यावसायिक तर्क                       |
| Apex Triggers         | घटना-आधारित प्रसंस्करण                      |
| Apex Test Classes     | इकाई परीक्षण                                |
| Salesforce REST API   | बाहरी रूप से रिकॉर्ड बनाना                  |
| Postman               | API परीक्षण                                 |
| Reports & Dashboards  | डेटा विश्लेषण और दृश्य प्रदर्शन             |
| Salesforce CLI        | Metadata प्रबंधन और परिनियोजन               |
| Git & GitHub          | संस्करण नियंत्रण                            |

## प्रणाली की संरचना

```text
                         Salesforce Platform
                                │
               ┌────────────────┼────────────────┐
               │                │                │
               ▼                ▼                ▼
        Lightning App        REST API        Reports &
               │                │             Dashboard
               ▼                ▼
        Leave Request ────────────────────────┐
               │                               │
               ▼                               │
        Record-Triggered Flow                 │
        Status = Pending                      │
               │                               │
               ▼                               │
        Validation Rule                       │
        >5 days cannot be Approved            │
               │                               │
               ▼                               │
        Apex Trigger                          │
               │                               │
               ▼                               │
        LeaveRequestHandler                   │
        Duration Classification               │
               │                               │
               ▼                               │
        Leave Request Record ◄────────────────┘
```

## डेटा मॉडल

यह प्रणाली वर्तमान में एक कस्टम Salesforce ऑब्जेक्ट का उपयोग करती है:

### Leave Request

**ऑब्जेक्ट:** `Leave_Request__c`

| फ़ील्ड            | उपयोग                                 |
| ----------------- | ------------------------------------- |
| Name              | छुट्टी अनुरोध का नाम                  |
| Applicant Name    | छुट्टी का अनुरोध करने वाला व्यक्ति    |
| Leave Type        | छुट्टी का प्रकार                      |
| Number of Days    | अनुरोधित छुट्टी की अवधि               |
| Status            | वर्तमान अनुरोध स्थिति                 |
| Duration Category | Apex द्वारा गणना की गई अवधि की श्रेणी |

## स्वचालन

### Record-Triggered Flow

जब कोई नया Leave Request रिकॉर्ड बनाया जाता है, तो Record-Triggered Flow स्वचालित रूप से:

```text
Status = Pending
```

सेट करता है।

इससे सभी नए अनुरोधों की प्रारंभिक स्थिति एकसमान रहती है और उपयोगकर्ताओं या बाहरी प्रणालियों को स्थिति अलग से प्रदान करने की आवश्यकता नहीं होती।

### Validation Rule

यदि अनुरोधित छुट्टी की अवधि पाँच दिनों से अधिक है, तो प्रणाली उस अनुरोध को स्वीकृत होने से रोकती है।

```text
Number of Days > 5
AND
Status = Approved
```

यह व्यावसायिक नियम लागू रहता है, चाहे परिवर्तन उपयोगकर्ता इंटरफ़ेस से किया गया हो या किसी अन्य समर्थित Salesforce प्रक्रिया से।

## Apex

### LeaveRequestHandler

`LeaveRequestHandler` Apex class में छुट्टी की अवधि के आधार पर अनुरोधों को वर्गीकृत करने का तर्क शामिल है।

### LeaveRequestTrigger

`LeaveRequestTrigger`, Leave Request रिकॉर्ड संसाधित होने पर `LeaveRequestHandler` को चलाता है।

Trigger और Handler को अलग रखा गया है, ताकि व्यावसायिक तर्क सीधे Trigger के अंदर न हो और कोड की संरचना स्पष्ट बनी रहे।

### परीक्षण

`LeaveRequestHandlerTest` में छुट्टी की अवधि के वर्गीकरण से संबंधित Apex इकाई परीक्षण शामिल हैं।

यह परीक्षण अलग-अलग छुट्टी अवधियों के लिए Handler द्वारा अपेक्षित श्रेणी उत्पन्न किए जाने की पुष्टि करता है।

## REST API एकीकरण

Salesforce REST API के माध्यम से Leave Request रिकॉर्ड बनाए जा सकते हैं।

Salesforce में प्रमाणीकरण और API अनुरोधों के परीक्षण के लिए Postman का उपयोग किया गया।

उदाहरण अनुरोध:

```json
{
  "Name": "Sick and hospitalized",
  "Applicant_Name__c": "Test Student",
  "Leave_Type__c": "Medical",
  "Number_of_Days__c": 3
}
```

`Status` और `Duration_Category__c` जैसे फ़ील्ड जानबूझकर अनुरोध में शामिल नहीं किए गए हैं, क्योंकि इन्हें Salesforce के स्वचालन द्वारा भरा जाता है।

सफल अनुरोध के बाद नए Salesforce रिकॉर्ड की ID और सफल निर्माण की पुष्टि करने वाला उत्तर प्राप्त होता है।

## रिपोर्ट और डैशबोर्ड

परियोजना में छुट्टी अनुरोधों की निगरानी और विश्लेषण के लिए कई रिपोर्ट शामिल हैं।

वर्तमान रिपोर्ट:

* Leave Request Overview
* Pending Leave Requests
* Leave Requests by Status
* Leave Requests by Leave Type
* Leave Requests by Duration
* New Leave Requests Report

### Leave Request Dashboard

डैशबोर्ड निम्नलिखित जानकारी को एक ही स्थान पर प्रदर्शित करता है:

* कुल छुट्टी अनुरोध
* स्थिति के अनुसार अनुरोध
* छुट्टी के प्रकार के अनुसार अनुरोध
* अवधि के अनुसार अनुरोध
* लंबित छुट्टी अनुरोध

## Lightning App

परियोजना में एक कस्टम Lightning App शामिल है:

**Leave Request Management**

यह अनुप्रयोग निम्नलिखित अनुभागों तक पहुँच प्रदान करता है:

* Home
* Leave Requests
* Reports
* Dashboards

कस्टम Home पेज में Leave Request Dashboard और Leave Request सूची दृश्य दोनों शामिल हैं, जिससे प्रणाली की निगरानी के लिए एक केंद्रीकृत कार्यक्षेत्र उपलब्ध होता है।

## परियोजना संरचना

```text
force-app/
└── main/
    └── default/
        ├── applications/
        │   └── Leave_Request_Management.app-meta.xml
        │
        ├── classes/
        │   ├── LeaveRequestHandler.cls
        │   ├── LeaveRequestHandler.cls-meta.xml
        │   ├── LeaveRequestHandlerTest.cls
        │   └── LeaveRequestHandlerTest.cls-meta.xml
        │
        ├── dashboards/
        │   └── LeaveRequestDashboards.dashboardFolder-meta.xml
        │
        ├── flexipages/
        │   └── Home.flexipage-meta.xml
        │
        ├── objects/
        │   └── Leave_Request__c/
        │       ├── fields/
        │       ├── listViews/
        │       └── validationRules/
        │
        ├── reports/
        │   ├── LeaveRequestsReport.reportFolder-meta.xml
        │   └── LeaveRequestsReport/
        │
        └── triggers/
            ├── LeaveRequestTrigger.trigger
            └── LeaveRequestTrigger.trigger-meta.xml
```

## परिनियोजन

यह परियोजना Salesforce DX परियोजना संरचना में व्यवस्थित है और Salesforce CLI के माध्यम से प्रबंधित की जा सकती है।

### आवश्यकताएँ

* Salesforce CLI
* उचित विकास पहुँच वाला Salesforce org
* Git

### Repository को क्लोन करना

```bash
git clone https://github.com/vk22006/leave-request-management-system.git
cd leave-request-management-system
```

### Salesforce Org में प्रमाणीकरण

```bash
sf org login web --alias LeaveRequestOrg
```

### Target Org सेट करना

```bash
sf config set target-org=LeaveRequestOrg
```

### Source को Deploy करना

```bash
sf project deploy start --source-dir force-app
```

## परीक्षण

Salesforce CLI का उपयोग करके Target Salesforce Org पर Apex परीक्षण चलाए जा सकते हैं।

उदाहरण:

```bash
sf apex run test --target-org LeaveRequestOrg --test-level RunLocalTests
```

## विकास दृष्टिकोण

परियोजना में जिम्मेदारियों को सरल रूप से अलग रखा गया है:

```text
Declarative Logic
    │
    ├── Flow
    └── Validation Rule

Programmatic Logic
    │
    ├── Apex Trigger
    ├── Apex Handler
    └── Apex Test Class

Integration
    │
    └── REST API + Postman

Presentation
    │
    ├── Lightning App
    ├── Reports
    └── Dashboard
```

कार्यान्वयन में जहाँ Salesforce की घोषणात्मक सुविधाएँ पर्याप्त हैं, वहाँ उन्हीं का उपयोग किया गया है। जहाँ कस्टम प्रसंस्करण आवश्यक है, वहाँ Apex का उपयोग किया गया है।

## भविष्य के सुधार

भविष्य में निम्नलिखित सुविधाएँ जोड़ी जा सकती हैं:

* छुट्टी अनुरोधों के लिए अनुमोदन प्रक्रिया
* ईमेल या अनुप्रयोग के अंदर सूचनाएँ
* भूमिका-आधारित पहुँच नियंत्रण
* अतिरिक्त डेटा विश्लेषण
* बड़ी मात्रा में डेटा के लिए Bulk API प्रसंस्करण
* एकीकरण के लिए बेहतर अपवाद प्रबंधन
* अतिरिक्त स्वचालित परीक्षण कवरेज
