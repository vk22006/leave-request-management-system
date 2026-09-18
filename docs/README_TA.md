# Leave Request Management System

[English](../README.md) | தமிழ் | [हिन्दी](README_HI.md) | [简体中文](README_ZH.md) | [Bahasa Indonesia](README_ID.md)

ஆசிரியர்கள் மற்றும் மாணவர்களின் விடுப்பு கோரிக்கைகளை நிர்வகிப்பதற்கான Salesforce அடிப்படையிலான அமைப்பு.

இந்தத் திட்டம் Salesforce-இன் அறிவிப்பு அடிப்படையிலான தானியக்க செயல்முறைகள், Apex நிரலாக்கம், REST API ஒருங்கிணைப்பு, அறிக்கைகள், தரவுப் பலகைகள் மற்றும் Lightning பயன்பாட்டு வடிவமைப்பு ஆகியவற்றை நடைமுறையில் எடுத்துக்காட்டுகிறது.

## மேலோட்டம்

இந்த அமைப்பின் மூலம் பயனர்கள் விடுப்பு கோரிக்கைகளை உருவாக்கி நிர்வகிக்க முடியும். Salesforce தானாகவே கோரிக்கையின் தொடக்க நிலையை அமைத்து, விடுப்பின் கால அளவை வகைப்படுத்துகிறது.

![screenshot](../img/image.png)

இந்தத் திட்டம் **குறைந்த நிரலாக்கத் தேவையுடைய Salesforce அம்சங்கள்** மற்றும் **Apex மூலம் மேற்கொள்ளப்படும் நிரலாக்க அடிப்படையிலான செயலாக்கம்** ஆகிய இரண்டையும் நடைமுறையில் எடுத்துக்காட்டும் வகையில் உருவாக்கப்பட்டது.

## அம்சங்கள்

* விடுப்பு கோரிக்கைகளை உருவாக்கி நிர்வகித்தல்
* புதிய கோரிக்கைகளுக்கு தானாக `Pending` நிலையை அமைத்தல்
* 5 நாட்களுக்கு மேற்பட்ட விடுப்பு கோரிக்கைகளை அனுமதிப்பதைத் தடுத்தல்
* Apex மூலம் விடுப்பு கால அளவை தானாக வகைப்படுத்துதல்
* REST API மூலம் விடுப்பு கோரிக்கைகளை உருவாக்குதல்
* Apex அலகுச் சோதனைகள்
* விடுப்பு கோரிக்கைகளைக் கண்காணிப்பதற்கான அறிக்கைகள்
* விடுப்பு தொடர்பான தரவுகளைப் பார்வையிடுவதற்கான தரவுப் பலகை
* அமைப்பை ஒரே இடத்தில் அணுகுவதற்கான தனிப்பயன் Lightning பயன்பாடு

## தொழில்நுட்பக் கருவிகள்

| தொழில்நுட்பம்         | பயன்பாடு                                  |
| --------------------- | ----------------------------------------- |
| Salesforce Platform   | பயன்பாட்டு தளம்                           |
| Lightning App Builder | பயன்பாடு மற்றும் பயனர் இடைமுக அமைப்பு     |
| Flow Builder          | தானியக்க செயல்முறைகள்                     |
| Validation Rules      | தரவு சரிபார்ப்பு                          |
| Apex                  | தனிப்பயன் செயலாக்க விதிகள்                |
| Apex Triggers         | நிகழ்வு அடிப்படையிலான செயலாக்கம்          |
| Apex Test Classes     | அலகுச் சோதனை                              |
| Salesforce REST API   | வெளிப்புறமாக பதிவுகளை உருவாக்குதல்        |
| Postman               | API சோதனை                                 |
| Reports & Dashboards  | தரவு பகுப்பாய்வு மற்றும் காட்சிப்படுத்தல் |
| Salesforce CLI        | Metadata நிர்வாகம் மற்றும் வெளியீடு       |
| Git & GitHub          | பதிப்பு கட்டுப்பாடு                       |

## அமைப்பு வடிவமைப்பு

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

## தரவு அமைப்பு

இந்த அமைப்பு தற்போது ஒரு தனிப்பயன் Salesforce பொருளைப் பயன்படுத்துகிறது:

### Leave Request

**பொருள்:** `Leave_Request__c`

| புலம்             | பயன்பாடு                               |
| ----------------- | -------------------------------------- |
| Name              | விடுப்பு கோரிக்கையின் பெயர்            |
| Applicant Name    | விடுப்பு கோரும் நபர்                   |
| Leave Type        | விடுப்பின் வகை                         |
| Number of Days    | கோரப்பட்ட விடுப்பு நாட்களின் எண்ணிக்கை |
| Status            | தற்போதைய கோரிக்கை நிலை                 |
| Duration Category | Apex மூலம் கணக்கிடப்படும் கால அளவு வகை |

## தானியக்க செயல்முறைகள்

### Record-Triggered Flow

புதிய Leave Request பதிவு உருவாக்கப்படும் போது, Record-Triggered Flow தானாக:

```text
Status = Pending
```

என்று அமைக்கிறது.

இதன் மூலம் பயனர்கள் அல்லது வெளிப்புற இணைப்புகள் தொடக்க நிலையைத் தனியாக வழங்க வேண்டிய அவசியமின்றி, அனைத்து புதிய கோரிக்கைகளுக்கும் ஒரே தொடக்க நிலை உறுதி செய்யப்படுகிறது.

### Validation Rule

கோரப்பட்ட விடுப்பு கால அளவு ஐந்து நாட்களுக்கு மேல் இருந்தால், அந்த விடுப்பு கோரிக்கையை அனுமதிப்பதை அமைப்பு தடுக்கிறது.

```text
Number of Days > 5
AND
Status = Approved
```

இந்த விதி பயனர் இடைமுகம் அல்லது ஆதரிக்கப்படும் பிற Salesforce செயல்பாடுகள் மூலம் மாற்றம் செய்யப்பட்டாலும் செயல்படுத்தப்படும்.

## Apex

### LeaveRequestHandler

`LeaveRequestHandler` Apex class, விடுப்பு கோரிக்கைகளின் கால அளவை அடிப்படையாகக் கொண்டு அவற்றை வகைப்படுத்துவதற்கான செயலாக்க விதிகளைக் கொண்டுள்ளது.

### LeaveRequestTrigger

`LeaveRequestTrigger`, Leave Request பதிவுகள் செயலாக்கப்படும்போது `LeaveRequestHandler`-ஐ இயக்குகிறது.

செயலாக்க விதிகள் Trigger-க்குள் நேரடியாக எழுதப்படாமல் தனி Handler-ல் வைக்கப்பட்டுள்ளதால், Trigger மற்றும் செயலாக்க விதிகளுக்கு இடையே பொறுப்புகள் பிரிக்கப்பட்டுள்ளன.

### சோதனை

`LeaveRequestHandlerTest` Apex class, கால அளவு வகைப்படுத்தும் செயலாக்கத்திற்கான அலகுச் சோதனைகளைக் கொண்டுள்ளது.

வெவ்வேறு விடுப்பு கால அளவுகளுக்கு Handler எதிர்பார்க்கப்படும் வகையை வழங்குகிறதா என்பதை இந்தச் சோதனை உறுதிப்படுத்துகிறது.

## REST API ஒருங்கிணைப்பு

Salesforce REST API மூலம் Leave Request பதிவுகளை உருவாக்க முடியும்.

Salesforce-ல் உள்நுழைந்து API கோரிக்கைகளைச் சோதிக்க Postman பயன்படுத்தப்பட்டது.

எடுத்துக்காட்டு கோரிக்கை:

```json
{
  "Name": "Sick and hospitalized",
  "Applicant_Name__c": "Test Student",
  "Leave_Type__c": "Medical",
  "Number_of_Days__c": 3
}
```

`Status` மற்றும் `Duration_Category__c` போன்ற புலங்கள் வேண்டுமென்றே கோரிக்கையில் சேர்க்கப்படவில்லை. அவை Salesforce தானியக்க செயல்முறைகள் மூலம் நிரப்பப்படுகின்றன.

வெற்றிகரமான கோரிக்கைக்குப் பிறகு, புதிதாக உருவாக்கப்பட்ட Salesforce பதிவின் அடையாள எண்ணும் வெற்றிகரமான உருவாக்கத்தைக் குறிக்கும் பதிலும் கிடைக்கும்.

## அறிக்கைகள் மற்றும் தரவுப் பலகை

விடுப்பு கோரிக்கைகளைக் கண்காணித்து பகுப்பாய்வு செய்வதற்காகத் திட்டத்தில் பல அறிக்கைகள் உள்ளன.

தற்போதைய அறிக்கைகள்:

* Leave Request Overview
* Pending Leave Requests
* Leave Requests by Status
* Leave Requests by Leave Type
* Leave Requests by Duration
* New Leave Requests Report

### Leave Request Dashboard

தரவுப் பலகை பின்வரும் தகவல்களை ஒரே இடத்தில் வழங்குகிறது:

* மொத்த விடுப்பு கோரிக்கைகள்
* நிலை அடிப்படையிலான கோரிக்கைகள்
* விடுப்பு வகை அடிப்படையிலான கோரிக்கைகள்
* கால அளவு அடிப்படையிலான கோரிக்கைகள்
* நிலுவையில் உள்ள விடுப்பு கோரிக்கைகள்

## Lightning பயன்பாடு

இந்தத் திட்டத்தில் ஒரு தனிப்பயன் Lightning பயன்பாடு உள்ளது:

**Leave Request Management**

இந்தப் பயன்பாடு பின்வரும் பகுதிகளுக்கான வழிசெலுத்தலை வழங்குகிறது:

* Home
* Leave Requests
* Reports
* Dashboards

தனிப்பயன் Home பக்கத்தில் Leave Request Dashboard மற்றும் Leave Request பட்டியல் இரண்டும் இணைக்கப்பட்டுள்ளன. இதன் மூலம் அமைப்பைக் கண்காணிக்க ஒரே பணியிடத்தைப் பயன்படுத்த முடியும்.

## திட்ட அமைப்பு

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

## வெளியீடு

இந்தத் திட்டம் Salesforce DX திட்ட அமைப்பில் உருவாக்கப்பட்டுள்ளது. Salesforce CLI மூலம் இதை நிர்வகிக்க முடியும்.

### தேவையானவை

* Salesforce CLI
* உரிய மேம்பாட்டு அணுகல் கொண்ட Salesforce org
* Git

### Repository-ஐ நகலெடுத்தல்

```bash
git clone https://github.com/vk22006/leave-request-management-system.git
cd leave-request-management-system
```

### Salesforce Org-ல் உள்நுழைதல்

```bash
sf org login web --alias LeaveRequestOrg
```

### இலக்கு Org-ஐ அமைத்தல்

```bash
sf config set target-org=LeaveRequestOrg
```

### Source-ஐ வெளியிடுதல்

```bash
sf project deploy start --source-dir force-app
```

## சோதனை

Salesforce CLI மூலம் இலக்கு Salesforce org-ல் Apex சோதனைகளை இயக்கலாம்.

எடுத்துக்காட்டு:

```bash
sf apex run test --target-org LeaveRequestOrg --test-level RunLocalTests
```

## மேம்பாட்டு அணுகுமுறை

இந்தத் திட்டம் பொறுப்புகளை எளிமையாகப் பிரிக்கும் அணுகுமுறையைப் பின்பற்றுகிறது:

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

தேவையான இடங்களில் Salesforce-இன் அறிவிப்பு அடிப்படையிலான அம்சங்கள் பயன்படுத்தப்படுகின்றன. தனிப்பயன் செயலாக்கம் தேவைப்படும் இடங்களில் Apex பயன்படுத்தப்படுகிறது.

## எதிர்கால மேம்பாடுகள்

எதிர்காலத்தில் பின்வரும் அம்சங்களைச் சேர்க்கலாம்:

* விடுப்பு கோரிக்கைகளுக்கான ஒப்புதல் செயல்முறை
* மின்னஞ்சல் அல்லது பயன்பாட்டிற்குள் அறிவிப்புகள்
* பங்கு அடிப்படையிலான அணுகல் கட்டுப்பாடு
* கூடுதல் தரவுப் பகுப்பாய்வு
* அதிக எண்ணிக்கையிலான பதிவுகளுக்கான Bulk API செயலாக்கம்
* வெளிப்புற ஒருங்கிணைப்புகளுக்கான மேம்படுத்தப்பட்ட பிழை கையாளுதல்
* கூடுதல் தானியக்கச் சோதனைகள்
