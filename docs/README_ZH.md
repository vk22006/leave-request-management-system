# Leave Request Management System

[English](../README.md) | [தமிழ்](README_TA.md) | [हिन्दी](README_HI.md) | 简体中文 | [Bahasa Indonesia](README_ID.md)

一个基于 Salesforce 的请假申请管理系统，用于管理教师和学生的请假申请。

本项目展示了 Salesforce 声明式自动化、Apex 开发、REST API 集成、报表、仪表板以及 Lightning 应用程序设计。

## 项目概述

用户可以通过该系统创建和管理请假申请，而 Salesforce 会自动设置申请的初始状态，并根据请假天数对申请进行分类。

![screenshot](../img/image.png)

本项目作为一个实际的 Salesforce 开发项目而构建，用于展示 **低代码 Salesforce 功能** 以及 **使用 Apex 进行程序化开发** 的能力。

## 功能

* 创建和管理请假申请
* 自动将新申请的状态设置为 `Pending`
* 阻止批准超过 5 天的请假申请
* 使用 Apex 自动对请假时长进行分类
* 支持通过 REST API 创建请假申请
* Apex 单元测试
* 用于监控请假申请的报表
* 用于可视化请假数据的仪表板
* 用于集中访问系统的自定义 Lightning 应用程序

## 技术栈

| 技术                    | 用途          |
| --------------------- | ----------- |
| Salesforce Platform   | 应用程序平台      |
| Lightning App Builder | 应用程序和用户界面配置 |
| Flow Builder          | 声明式自动化      |
| Validation Rules      | 数据验证        |
| Apex                  | 自定义业务逻辑     |
| Apex Triggers         | 事件驱动处理      |
| Apex Test Classes     | 单元测试        |
| Salesforce REST API   | 创建外部记录      |
| Postman               | API 测试      |
| Reports & Dashboards  | 数据分析与可视化    |
| Salesforce CLI        | 元数据管理与部署    |
| Git & GitHub          | 版本控制        |

## 系统架构

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

## 数据模型

该系统目前使用一个自定义 Salesforce 对象：

### Leave Request

**对象：** `Leave_Request__c`

| 字段                | 用途               |
| ----------------- | ---------------- |
| Name              | 请假申请名称           |
| Applicant Name    | 申请请假的人员          |
| Leave Type        | 请假类型             |
| Number of Days    | 申请的请假天数          |
| Status            | 当前申请状态           |
| Duration Category | 由 Apex 计算的请假时长分类 |

## 自动化

### Record-Triggered Flow

当创建新的 Leave Request 记录时，Record-Triggered Flow 会自动设置：

```text
Status = Pending
```

这样可以保持所有新申请的初始状态一致，而不需要用户或外部系统手动提供该状态。

### Validation Rule

如果申请的请假时长超过五天，系统将阻止该请假申请被批准。

```text
Number of Days > 5
AND
Status = Approved
```

无论该修改来自用户界面还是其他受支持的 Salesforce 操作，该业务规则都会得到执行。

## Apex

### LeaveRequestHandler

`LeaveRequestHandler` Apex 类包含根据请假时长对请假申请进行分类的业务逻辑。

### LeaveRequestTrigger

`LeaveRequestTrigger` 在处理 Leave Request 记录时调用 `LeaveRequestHandler`。

Trigger 与 Handler 分离，使业务逻辑不会直接写在 Trigger 中，从而保持代码结构清晰。

### 测试

`LeaveRequestHandlerTest` 包含用于测试请假时长分类逻辑的 Apex 单元测试。

测试类会验证 Handler 针对不同请假天数是否能够生成预期的分类结果。

## REST API 集成

可以通过 Salesforce REST API 创建 Leave Request 记录。

项目使用 Postman 对 Salesforce 进行身份验证，并测试 API 请求。

请求示例：

```json
{
  "Name": "Sick and hospitalized",
  "Applicant_Name__c": "Test Student",
  "Leave_Type__c": "Medical",
  "Number_of_Days__c": 3
}
```

`Status` 和 `Duration_Category__c` 等字段被有意省略，因为这些字段会由 Salesforce 自动化流程进行填充。

请求成功后，系统会返回新创建的 Salesforce 记录 ID 以及表示创建成功的响应。

## 报表与仪表板

项目包含多个用于监控和分析请假申请的报表。

当前报表包括：

* Leave Request Overview
* Pending Leave Requests
* Leave Requests by Status
* Leave Requests by Leave Type
* Leave Requests by Duration
* New Leave Requests Report

### Leave Request Dashboard

仪表板集中展示以下信息：

* 请假申请总数
* 按状态分类的申请
* 按请假类型分类的申请
* 按请假时长分类的申请
* 待处理的请假申请

## Lightning 应用程序

项目包含一个自定义 Lightning 应用程序：

**Leave Request Management**

该应用程序提供以下页面的导航：

* Home
* Leave Requests
* Reports
* Dashboards

自定义 Home 页面中嵌入了 Leave Request Dashboard 和 Leave Request 列表视图，为监控整个系统提供一个集中式工作空间。

## 项目结构

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

## 部署

本项目采用 Salesforce DX 项目结构，可以通过 Salesforce CLI 进行管理。

### 前置要求

* Salesforce CLI
* 具有适当开发权限的 Salesforce org
* Git

### 克隆仓库

```bash
git clone https://github.com/vk22006/leave-request-management-system.git
cd leave-request-management-system
```

### 登录 Salesforce Org

```bash
sf org login web --alias LeaveRequestOrg
```

### 设置目标 Org

```bash
sf config set target-org=LeaveRequestOrg
```

### 部署源代码

```bash
sf project deploy start --source-dir force-app
```

## 测试

可以使用 Salesforce CLI 在目标 Salesforce org 中执行 Apex 测试。

示例：

```bash
sf apex run test --target-org LeaveRequestOrg --test-level RunLocalTests
```

## 开发方式

本项目采用简单的职责分离方式：

```text
声明式逻辑
    │
    ├── Flow
    └── Validation Rule

程序化逻辑
    │
    ├── Apex Trigger
    ├── Apex Handler
    └── Apex Test Class

集成
    │
    └── REST API + Postman

展示
    │
    ├── Lightning App
    ├── Reports
    └── Dashboard
```

项目会在 Salesforce 自带的声明式功能足以满足需求时优先使用这些功能，而在需要自定义处理时使用 Apex。

## 未来改进

未来可以增加以下功能：

* 请假申请审批流程
* 电子邮件或应用内通知
* 基于角色的访问控制
* 更多数据分析功能
* 针对大量数据的 Bulk API 处理
* 改进集成过程中的异常处理
* 增加自动化测试覆盖率
