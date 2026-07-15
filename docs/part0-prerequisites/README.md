# Partner Prerequisites

**Duration:** 20–30 minutes  
**Objective:** Ensure you have all the partner accounts and access required to run a customer PoC with IBM watsonx Orchestrate and IBM Bob.

---

## What You Need Before Starting

Before you can run a watsonx Orchestrate PoC for a customer, you need four things in place:

| Requirement | Why you need it |
|---|---|
| **GitHub account** | Clone workshop materials, track exercises |
| **IBM Partner account (PartnerWorld)** | Access IBM partner resources and software |
| **IBM TechZone access** | Provision free watsonx Orchestrate environments for PoCs |
| **IBM Support ticket access** | Request Bob enterprise accounts and bobcoins |

---

## 1. GitHub Account

If you don't already have a GitHub account, create one at [https://github.com/join](https://github.com/join).

You need it to:

- Clone or fork the workshop repository
- Access code examples and reference files
- Submit issues or improvement requests

!!! tip "IBM employees"
    Use your personal GitHub account (not your IBM GitHub Enterprise account) for public workshop materials.

---

## 2. IBM Partner Account (PartnerWorld)

You need an active IBM PartnerWorld account to access partner-exclusive resources including TechZone environments and Bob enterprise licensing.

- Register or log in at [https://www.ibm.com/partnerworld](https://www.ibm.com/partnerworld)
- Your account must be linked to an IBM Business Partner organisation

!!! note
    If your company is not yet an IBM Business Partner, contact your IBM representative to start the enrolment process.

---

## 3. IBM TechZone Access

IBM TechZone lets IBM Business Partners provision fully managed cloud environments — including watsonx Orchestrate instances — at no cost for PoC and demo purposes.

### Verify access

Log in at [https://techzone.ibm.com](https://techzone.ibm.com) with your IBM ID. If you can see the catalogue, you're good.

!!! warning "Access issues?"
    TechZone access is granted automatically to active IBM Business Partners. If you get an "access denied" error, contact your IBM Partner Ecosystem representative.

---

## 4. IBM Support Ticket Access

You need to be able to raise IBM Support tickets to:

- Request a Bob enterprise account
- Request bobcoins for your customer PoC

Confirm you can access [https://www.ibm.com/support](https://www.ibm.com/support) and open cases with your IBM ID.

---

## Now: Set Up Your PoC Environment

Once the four prerequisites above are confirmed, follow these two steps to get your watsonx Orchestrate and IBM Bob instances ready for a customer PoC.

---

## Step 1 — Provision a watsonx Orchestrate Instance on TechZone

TechZone provides a free, fully configured watsonx Orchestrate SaaS environment for PoC use. This is the environment your customer will use during the PoC.

### Reserve your environment

1. Open the collection link:  
   **[https://techzone.ibm.com/collection/6939fccc3fc778c2abfc1e25/environments?platform=69fe3e8a6a38f6a7c980166c](https://techzone.ibm.com/collection/6939fccc3fc778c2abfc1e25/environments?platform=69fe3e8a6a38f6a7c980166c)**

2. Click **Reserve** on the watsonx Orchestrate environment tile.

3. Fill in the reservation form:

    | Field | What to enter |
    |---|---|
    | **Purpose** | Customer PoC |
    | **Opportunity number** | Your IBM opportunity ID (or "N/A" for internal labs) |
    | **Start date** | Your PoC start date |
    | **End date** | Your PoC end date (max 2 weeks, extendable) |
    | **Geography** | Nearest region to your customer |

4. Click **Submit**. You will receive a confirmation email within a few minutes.

5. Once provisioned (usually 10–30 minutes), you will receive another email containing:
    - Your **watsonx Orchestrate instance URL**
    - Your **API key**
    - Instructions to invite your customer users

!!! info "Detailed TechZone documentation"
    For step-by-step screenshots and troubleshooting, refer to the **Create wxo techzone** provider file included in your partner enablement package.

!!! tip "Extending a reservation"
    If you need more time, log into TechZone and extend the reservation before it expires — extensions are usually approved automatically for active PoCs.

### What you get

- A production-grade watsonx Orchestrate SaaS instance
- Pre-configured with all required services (vector store, LLM gateway, agent builder)
- Admin access to invite and manage users
- Dedicated for your PoC — no shared tenant concerns

---

## Step 2 — Request a Bob Enterprise Account

IBM Bob is the AI coding assistant used throughout this workshop. For a customer PoC, you need an **enterprise account** which provides:

- Increased usage limits (bobcoins)
- Access to advanced models
- Ability to share Bob with your customer team

### How to request

1. Open the IBM Support request page:  
   **[https://www.ibm.com/support/pages/node/7159462](https://www.ibm.com/support/pages/node/7159462)**

2. Follow the instructions on that page to submit a request for a **Bob enterprise account**.

3. In your request, include:
    - Your IBM Partner organisation name
    - The customer PoC name and opportunity number
    - Number of users who need access
    - Requested bobcoin allocation (recommended: **500 bobcoins** per user for a 2-week PoC)

4. IBM will process your request and send account credentials by email, typically within **1–2 business days**.

!!! tip "Bobcoins"
    Bobcoins are Bob's usage currency. Each AI interaction consumes a small number of bobcoins. 500 bobcoins is enough for intensive workshop use over 2 weeks. Request more if your PoC is longer.

!!! note "Trial account vs enterprise account"
    The free Bob trial account has limited bobcoins and no enterprise features. Always request an enterprise account before starting a customer-facing PoC.

---

## Prerequisites Checklist

Before moving on to [Part 1: Setup & Environment](../part1-setup/README.md), confirm all of the following:

- [ ] I have a GitHub account and can access [https://github.com](https://github.com)
- [ ] I have an active IBM PartnerWorld account
- [ ] I can log into IBM TechZone at [https://techzone.ibm.com](https://techzone.ibm.com)
- [ ] I can open IBM Support tickets at [https://www.ibm.com/support](https://www.ibm.com/support)
- [ ] I have reserved a watsonx Orchestrate environment on TechZone **(or have credentials from your instructor)**
- [ ] I have requested (or received) a Bob enterprise account with bobcoins

!!! success "All checked?"
    You're ready to go. Head to [Part 1: Setup & Environment](../part1-setup/README.md) →

---

## Troubleshooting

??? question "I can't access TechZone — I get 'access denied'"
    Your IBM ID may not be linked to an active Business Partner account. Contact your IBM Partner Ecosystem representative or check your PartnerWorld account status at [https://www.ibm.com/partnerworld](https://www.ibm.com/partnerworld).

??? question "My TechZone reservation is taking longer than 30 minutes"
    This is rare but can happen during high-demand periods. Check the TechZone status page and reach out in the TechZone Slack community if it exceeds 1 hour.

??? question "I haven't received my Bob enterprise account after 2 business days"
    Follow up by replying to your original support ticket. Include your IBM opportunity number and PoC start date to escalate if needed.

??? question "Can I use a trial Bob account for the workshop?"
    Yes, a trial account is sufficient to follow Parts 1–9 of this workshop. However, for a **customer-facing PoC**, an enterprise account is strongly recommended to avoid running out of bobcoins.
