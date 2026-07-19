/**
 * translations.js
 * EN ↔ HE language toggle for Bobchestrate Workshop (MkDocs Material site)
 *
 * The toggle button is rendered server-side in overrides/partials/header.html.
 * This script wires up the click handler, translates text nodes, and handles
 * RTL layout + localStorage persistence.
 */

(function () {
  "use strict";

  /* ------------------------------------------------------------------ */
  /*  TRANSLATIONS  (EN → HE)                                            */
  /* ------------------------------------------------------------------ */

  const HE = {
    /* ---- Site / nav ---- */
    "Enable Partner Bobchestrate Workshop": "סדנת Enable Partner Bobchestrate",
    "Hands-on workshop for building AI agents with IBM watsonx Orchestrate":
      "סדנה מעשית לבניית סוכני AI עם IBM watsonx Orchestrate",
    "Home": "בית",
    "Prerequisites": "דרישות מוקדמות",
    "Overview": "סקירה כללית",
    "Exercises": "תרגילים",
    "Bob Prompts": "פרומפטים של Bob",
    "Helpful Prompts": "פרומפטים שימושיים",
    "Model Selection Guide": "מדריך לבחירת מודל",

    /* ---- Index page headings ---- */
    "Enable Partner Bobchestrate Workshop - Building AI Agents with watsonx Orchestrate and IBM Bob":
      "סדנת Enable Partner Bobchestrate - בניית סוכני AI עם watsonx Orchestrate ו-IBM Bob",
    "A Hands-On Workshop for Agentic AI Development":
      "סדנה מעשית לפיתוח AI אגנטי",
    "Workshop Overview": "סקירת הסדנה",
    "Partner Prerequisites": "דרישות מוקדמות לשותפים",
    "Before starting this workshop, make sure you have:":
      "לפני שמתחילים את הסדנה, יש לוודא שברשותך:",
    "A GitHub account": "חשבון GitHub",
    "An IBM partner account": "חשבון שותף IBM",
    "Access to TechZone": "גישה ל-TechZone",
    "Access to ticket creation": "גישה ליצירת כרטיסים",
    "Duration:": "משך הזמן:",
    "270-300 minutes (4.5-5 hours) for complete workshop":
      "270-300 דקות (4.5-5 שעות) לסדנה המלאה",
    "This estimate includes:": "האומדן כולל:",
    "Core instruction time: 220 minutes": "זמן הוראה מרכזי: 220 דקות",
    "Setup and troubleshooting: 20-30 minutes":
      "התקנה ופתרון בעיות: 20-30 דקות",
    "Short breaks: 15-20 minutes": "הפסקות קצרות: 15-20 דקות",
    "Q&A and discussion: 15-30 minutes": "שאלות, תשובות ודיון: 15-30 דקות",
    "Alternative Options:": "אפשרויות חלופיות:",
    "Core Workshop": "סדנה מרכזית",
    "(Parts 1-8): 240-270 minutes (4-4.5 hours)":
      "(חלקים 1-8): 240-270 דקות (4-4.5 שעות)",
    "Advanced Exercise Only": "תרגיל מתקדם בלבד",
    "(Part 1 + Part 9): 60-75 minutes (1-1.25 hours) - setup + multi-agent orchestration as standalone exercise":
      "(חלק 1 + חלק 9): 60-75 דקות (1-1.25 שעות) - התקנה + תזמור רב-סוכני כתרגיל עצמאי",
    "Level:": "רמה:",
    "Beginner to Intermediate (Advanced for Part 9)":
      "מתחיל עד בינוני (מתקדם לחלק 9)",
    "Prerequisites:": "דרישות מוקדמות:",

    /* ---- What you'll build ---- */
    "What You'll Build": "מה תבנה",
    "Hello World Agent (Part 2)": "סוכן Hello World (חלק 2)",
    "Your first simple agent to understand the basics of agent configuration and behavior.":
      "הסוכן הראשון שלך להבנת יסודות הגדרת הסוכן והתנהגותו.",
    "Customer Support System (Parts 3-5)": "מערכת תמיכת לקוחות (חלקים 3-5)",
    "A complete customer support solution featuring:":
      "פתרון תמיכת לקוחות מלא הכולל:",
    "Custom Python tools": "כלים מותאמים אישית ב-Python",
    "for order status checking and refund processing":
      "לבדיקת סטטוס הזמנה ועיבוד החזרים",
    "Knowledge base integration": "שילוב בסיס ידע",
    "for FAQ handling": "לטיפול בשאלות נפוצות",
    "Specialized escalation agent": "סוכן הסלמה מיוחד",
    "for complex issues": "לבעיות מורכבות",
    "Safety guidelines and guardrails": "הנחיות בטיחות ומחסומים",
    "for responsible AI": "ל-AI אחראי",
    "Product Catalog System (Part 6)": "מערכת קטלוג מוצרים (חלק 6)",
    "An MCP server-powered agent that demonstrates backend integration:":
      "סוכן מבוסס שרת MCP המדגים אינטגרציה עם ה-backend:",
    "Product search and details": "חיפוש מוצרים ופרטים",
    "Inventory checking": "בדיקת מלאי",
    "Product recommendations": "המלצות מוצרים",
    "Reusable MCP server architecture": "ארכיטקטורת שרת MCP לשימוש חוזר",
    "Agent Evaluations & Red-Teaming (Part 7)":
      "הערכות סוכן ו-Red-Teaming (חלק 7)",
    "Learn to evaluate and secure your agents:":
      "למד להעריך ולאבטח את הסוכנים שלך:",
    "Creating comprehensive evaluation datasets":
      "יצירת מערכי נתונים להערכה מקיפה",
    "Running automated evaluations": "הרצת הערכות אוטומטיות",
    "Red-teaming techniques for security testing":
      "טכניקות Red-Teaming לבדיקות אבטחה",
    "Identifying and fixing vulnerabilities": "זיהוי ותיקון פגיעויות",
    "Measuring agent performance metrics": "מדידת מדדי ביצועי הסוכן",
    "Testing & Deployment (Part 8)": "בדיקות ופריסה (חלק 8)",
    "Learn to test and deploy your customer support agent:":
      "למד לבדוק ולפרוס את סוכן תמיכת הלקוחות שלך:",
    "Comprehensive testing strategies": "אסטרטגיות בדיקה מקיפות",
    "Unit and integration testing": "בדיקות יחידה ואינטגרציה",
    "Deployment best practices": "שיטות עבודה מומלצות לפריסה",
    "Monitoring and observability": "ניטור ומעקב",
    "Production readiness checklist": "רשימת בדיקה לסביבת ייצור",
    "Each system builds on concepts from previous parts, teaching you to create increasingly sophisticated agentic AI solutions.":
      "כל מערכת בונה על מושגים מחלקים קודמים ומלמדת אותך ליצור פתרונות AI אגנטיים מתוחכמים יותר ויותר.",

    /* ---- Workshop structure ---- */
    "Workshop Structure": "מבנה הסדנה",
    "Part 1: Setup & Environment": "חלק 1: התקנה וסביבת עבודה",
    "Part 2: Building Your First Agent": "חלק 2: בניית הסוכן הראשון שלך",
    "Part 2b: Using Custom Rules with Bob IDE":
      "חלק 2ב: שימוש בחוקים מותאמים עם Bob IDE",
    "Part 3: Adding Custom Tools": "חלק 3: הוספת כלים מותאמים",
    "Part 3b: AI Gateway and Using Different Models":
      "חלק 3ב: AI Gateway ושימוש במודלים שונים",
    "Part 4: Knowledge Bases & Collaborators":
      "חלק 4: בסיסי ידע ושותפי עבודה",
    "Part 5: Agent Guidelines & Guardrails":
      "חלק 5: הנחיות ומחסומים לסוכן",
    "Part 6: MCP Servers - Connecting to Backend Services":
      "חלק 6: שרתי MCP - התחברות לשירותי Backend",
    "Part 6b: Agentic Workflows - Deterministic Tool Orchestration":
      "חלק 6ב: תהליכי עבודה אגנטיים - תזמור כלים דטרמיניסטי",
    "Part 7: Agent Evaluations & Red-Teaming":
      "חלק 7: הערכות סוכן ו-Red-Teaming",
    "Part 8: Testing & Deployment": "חלק 8: בדיקות ופריסה",
    "Part 9: Multi-Agent Orchestration & Workflows":
      "חלק 9: תזמור רב-סוכני ותהליכי עבודה",
    "Part 10: NL2SQL Agent with the Accelerator":
      "חלק 10: סוכן NL2SQL עם המאיץ",

    /* ---- Part nav labels ---- */
    "Part 1 - Setup": "חלק 1 - התקנה",
    "Part 2 - First Agent": "חלק 2 - סוכן ראשון",
    "Part 2b - Bob Custom Rules": "חלק 2ב - חוקים מותאמים ל-Bob",
    "Part 3 - Custom Tools": "חלק 3 - כלים מותאמים",
    "Part 3b - AI Gateway Models": "חלק 3ב - מודלי AI Gateway",
    "Part 4 - Knowledge": "חלק 4 - ידע",
    "Part 5 - Guidelines & Guardrails": "חלק 5 - הנחיות ומחסומים",
    "Part 6 - MCP Servers": "חלק 6 - שרתי MCP",
    "Part 6b - Agentic Workflows": "חלק 6ב - תהליכי עבודה אגנטיים",
    "Part 7 - Agent Evaluations": "חלק 7 - הערכות סוכן",
    "Part 8 - Deployment": "חלק 8 - פריסה",
    "Part 9 - Multi-Agent Orchestration": "חלק 9 - תזמור רב-סוכני",
    "Part 10 - NL2SQL Accelerator": "חלק 10 - מאיץ NL2SQL",

    /* ---- Common Material UI ---- */
    "Search": "חיפוש",
    "Search docs": "חפש בתיעוד",
    "Table of contents": "תוכן עניינים",
    "Edit this page": "ערוך עמוד זה",
    "Previous": "הקודם",
    "Next": "הבא",
    "Back to top": "חזרה לראש הדף",
    "Switch to dark mode": "מעבר למצב כהה",
    "Switch to light mode": "מעבר למצב בהיר",
    "Initializing search": "טוען חיפוש...",

    /* ---- Prerequisites page ---- */
    "Before starting the workshop, make sure you have the following:":
      "לפני תחילת הסדנה, וודא שברשותך הבאים:",
    "Accounts & Access": "חשבונות וגישה",
    "GitHub account": "חשבון GitHub",
    "IBM partner account": "חשבון שותף IBM",
    "1. Create a watsonx Orchestrate Instance on TechZone":
      "1. צור מופע watsonx Orchestrate ב-TechZone",
    "Reserve environment (direct)": "הזמן סביבה (ישיר)",
    "Detailed documentation in the provider file":
      "תיעוד מפורט בקובץ הספק",
    "Create wxo techzone": "צור wxo techzone",
    "2. Request a Bob Enterprise Account": "2. בקש חשבון Bob Enterprise",
    "Submit your request here:": "שלח את בקשתך כאן:",
    "Details on the link.": "פרטים בקישור.",
    "Ready? Head to": "מוכן? עבור אל",
  };

  /* ------------------------------------------------------------------ */
  /*  BUILD REVERSE MAP  (HE → EN)                                       */
  /* ------------------------------------------------------------------ */
  const EN = {};
  for (const [k, v] of Object.entries(HE)) {
    EN[v] = k;
  }

  /* ------------------------------------------------------------------ */
  /*  STATE                                                               */
  /* ------------------------------------------------------------------ */
  const LS_KEY = "bobchestrate_lang";
  let currentLang = localStorage.getItem(LS_KEY) || "en";

  /* ------------------------------------------------------------------ */
  /*  TEXT-NODE WALKER                                                    */
  /* ------------------------------------------------------------------ */
  function translateNode(root, dict) {
    const walker = document.createTreeWalker(
      root,
      NodeFilter.SHOW_TEXT,
      {
        acceptNode(node) {
          const tag = node.parentElement && node.parentElement.tagName;
          // Skip code blocks, scripts, styles, and the button itself
          if (["SCRIPT", "STYLE", "CODE", "PRE", "KBD"].includes(tag))
            return NodeFilter.FILTER_REJECT;
          // Don't translate inside our own button
          if (node.parentElement && node.parentElement.closest("#lang-toggle-btn"))
            return NodeFilter.FILTER_REJECT;
          if (node.textContent.trim() === "") return NodeFilter.FILTER_SKIP;
          return NodeFilter.FILTER_ACCEPT;
        },
      }
    );

    const nodes = [];
    let n;
    while ((n = walker.nextNode())) nodes.push(n);

    // Sort keys longest-first to avoid partial-match conflicts
    const keys = Object.keys(dict).sort((a, b) => b.length - a.length);

    for (const node of nodes) {
      const orig = node.textContent;
      const trimmed = orig.trim();

      // Exact full-node match
      if (dict[trimmed] !== undefined) {
        node.textContent = orig.replace(trimmed, dict[trimmed]);
        continue;
      }

      // Partial replacement
      let replaced = orig;
      for (const phrase of keys) {
        if (replaced.includes(phrase)) {
          replaced = replaced.split(phrase).join(dict[phrase]);
        }
      }
      if (replaced !== orig) {
        node.textContent = replaced;
      }
    }
  }

  /* ------------------------------------------------------------------ */
  /*  ATTRIBUTE TRANSLATION                                               */
  /* ------------------------------------------------------------------ */
  function translateAttrs(dict) {
    document.querySelectorAll("[placeholder],[title],[aria-label]").forEach((el) => {
      // Don't touch our button
      if (el.id === "lang-toggle-btn") return;
      ["placeholder", "title", "aria-label"].forEach((attr) => {
        const val = el.getAttribute(attr);
        if (val && dict[val]) el.setAttribute(attr, dict[val]);
      });
    });
  }

  /* ------------------------------------------------------------------ */
  /*  UPDATE BUTTON LABEL                                                 */
  /* ------------------------------------------------------------------ */
  function updateButton(lang) {
    const btn = document.getElementById("lang-toggle-btn");
    if (!btn) return;
    if (lang === "en") {
      btn.innerHTML =
        '<span class="lt-active">EN</span><span class="lt-sep"> | </span><span>HE</span>';
      btn.title = "Switch to Hebrew (עברית)";
    } else {
      btn.innerHTML =
        '<span>EN</span><span class="lt-sep"> | </span><span class="lt-active">HE</span>';
      btn.title = "Switch to English";
    }
  }

  /* ------------------------------------------------------------------ */
  /*  APPLY LANGUAGE TO PAGE                                             */
  /* ------------------------------------------------------------------ */
  function applyLang(lang) {
    const dict = lang === "he" ? HE : EN;
    const html = document.documentElement;

    html.setAttribute("dir", lang === "he" ? "rtl" : "ltr");
    html.setAttribute("lang", lang === "he" ? "he" : "en");

    translateNode(document.body, dict);
    translateAttrs(dict);
    updateButton(lang);

    localStorage.setItem(LS_KEY, lang);
    currentLang = lang;
  }

  /* ------------------------------------------------------------------ */
  /*  TOGGLE FUNCTION (called by button onclick)                         */
  /* ------------------------------------------------------------------ */
  window.__langToggle = function () {
    applyLang(currentLang === "en" ? "he" : "en");
  };

  /* ------------------------------------------------------------------ */
  /*  INIT — wire up button + restore persisted language                 */
  /* ------------------------------------------------------------------ */
  function init() {
    // Wire up button click (in case onclick attr wasn't picked up)
    const btn = document.getElementById("lang-toggle-btn");
    if (btn) {
      btn.addEventListener("click", window.__langToggle);
    }

    // Restore persisted language
    if (currentLang === "he") {
      applyLang("he");
    } else {
      updateButton("en");
    }

    // Re-apply on MkDocs instant navigation (SPA page changes)
    // Material fires a custom "location.changed" event for instant nav
    document.addEventListener("DOMContentLoaded", function () {
      if (currentLang === "he") applyLang("he");
    });
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", init);
  } else {
    init();
  }
})();
