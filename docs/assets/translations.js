/**
 * translations.js
 * EN ↔ HE language toggle for Bobchestrate Workshop (MkDocs Material site)
 *
 * Strategy:
 *  - Stores all Hebrew translations keyed by canonical English text.
 *  - On toggle, walks every visible text node and swaps EN ↔ HE.
 *  - Also swaps specific attribute text (placeholder, title, aria-label).
 *  - Sets <html dir="rtl"> / dir="ltr" for proper layout.
 *  - Persists choice in localStorage.
 *  - Injects the toggle button into the Material header nav row.
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
    "Full details in the": "פרטים מלאים ב-",
    "Prerequisites": "דרישות מוקדמות",
    "section.": "סעיף.",
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

    /* ---- How Bob helps ---- */
    "How Bob Helps You": "כיצד Bob עוזר לך",
    "Throughout this workshop, you'll use Bob to:":
      "לאורך הסדנה תשתמש ב-Bob ל:",
    "Generate code": "יצירת קוד",
    "Debug issues": "איתור באגים",
    "Explain concepts": "הסבר מושגים",
    "Refactor code": "שיפוץ קוד",
    "Create tests": "יצירת בדיקות",

    /* ---- Learning objectives ---- */
    "Learning Objectives": "מטרות הלמידה",
    "By the end of this workshop, you will:":
      "בסיום הסדנה תוכל:",

    /* ---- Tips ---- */
    "Tips for Success": "טיפים להצלחה",
    "Ask Bob for help": "בקש עזרה מ-Bob",
    "Experiment": "נסה בעצמך",
    "Read error messages": "קרא הודעות שגיאה",
    "Test incrementally": "בדוק בהדרגה",
    "Use the documentation": "השתמש בתיעוד",

    /* ---- Additional resources ---- */
    "Additional Resources": "משאבים נוספים",
    "Need Help?": "זקוק לעזרה?",
    "Reporting issues and asking for enhancements":
      "דיווח על בעיות ובקשת שיפורים",
    "Getting Started": "תחילת עבודה",
    "Let's get started! 🚀": "בואו נתחיל! 🚀",

    /* ---- Part titles (nav) ---- */
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

    /* ---- Common UI ---- */
    "Search": "חיפוש",
    "Search docs": "חפש בתיעוד",
    "Table of contents": "תוכן עניינים",
    "Edit this page": "ערוך עמוד זה",
    "Previous": "הקודם",
    "Next": "הבא",
    "Back to top": "חזרה לראש הדף",
    "Switch to dark mode": "מעבר למצב כהה",
    "Switch to light mode": "מעבר למצב בהיר",

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
    "Part 1: Setup & Environment": "חלק 1: התקנה וסביבה",
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
  /**
   * Walk all text nodes under `root`, replace known phrases.
   * We work on full trimmed node values (exact match first) then
   * partial replacement for nodes that contain a known phrase.
   */
  function translateNode(root, dict) {
    const walker = document.createTreeWalker(
      root,
      NodeFilter.SHOW_TEXT,
      {
        acceptNode(node) {
          // Skip script/style/code content
          const tag = node.parentElement && node.parentElement.tagName;
          if (["SCRIPT", "STYLE", "CODE", "PRE", "KBD"].includes(tag))
            return NodeFilter.FILTER_REJECT;
          if (node.textContent.trim() === "") return NodeFilter.FILTER_SKIP;
          return NodeFilter.FILTER_ACCEPT;
        },
      }
    );

    const nodes = [];
    let n;
    while ((n = walker.nextNode())) nodes.push(n);

    for (const node of nodes) {
      const orig = node.textContent;
      const trimmed = orig.trim();

      // Exact full-node match (most nav / heading items)
      if (dict[trimmed] !== undefined) {
        node.textContent = orig.replace(trimmed, dict[trimmed]);
        continue;
      }

      // Partial replacement — replace each known phrase inside the text
      let replaced = orig;
      // Sort keys longest-first to avoid partial overlaps
      const keys = Object.keys(dict).sort((a, b) => b.length - a.length);
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
    // placeholder, title, aria-label on common elements
    const selectors = ["[placeholder]", "[title]", "[aria-label]"];
    for (const sel of selectors) {
      document.querySelectorAll(sel).forEach((el) => {
        ["placeholder", "title", "aria-label"].forEach((attr) => {
          const val = el.getAttribute(attr);
          if (val && dict[val]) {
            el.setAttribute(attr, dict[val]);
          }
        });
      });
    }
  }

  /* ------------------------------------------------------------------ */
  /*  APPLY LANGUAGE                                                      */
  /* ------------------------------------------------------------------ */
  function applyLang(lang) {
    const dict = lang === "he" ? HE : EN;
    const html = document.documentElement;

    // Direction + lang attribute
    html.setAttribute("dir", lang === "he" ? "rtl" : "ltr");
    html.setAttribute("lang", lang === "he" ? "he" : "en");

    // Translate all visible text
    translateNode(document.body, dict);
    translateAttrs(dict);

    // Update button labels
    updateButton(lang);

    // Persist
    localStorage.setItem(LS_KEY, lang);
    currentLang = lang;
  }

  /* ------------------------------------------------------------------ */
  /*  BUTTON                                                              */
  /* ------------------------------------------------------------------ */
  function createButton() {
    const btn = document.createElement("button");
    btn.id = "lang-toggle-btn";
    btn.setAttribute("aria-label", "Switch language EN / HE");
    updateButton(currentLang, btn);

    btn.addEventListener("click", () => {
      const next = currentLang === "en" ? "he" : "en";
      applyLang(next);
    });

    return btn;
  }

  function updateButton(lang, btn) {
    const el = btn || document.getElementById("lang-toggle-btn");
    if (!el) return;
    if (lang === "en") {
      el.innerHTML =
        '<span class="lt-active">EN</span>' +
        '<span class="lt-sep"> | </span>' +
        '<span>HE</span>';
      el.title = "Switch to Hebrew (עברית)";
    } else {
      el.innerHTML =
        '<span>EN</span>' +
        '<span class="lt-sep"> | </span>' +
        '<span class="lt-active">HE</span>';
      el.title = "Switch to English";
    }
  }

  /* ------------------------------------------------------------------ */
  /*  INJECT BUTTON INTO MATERIAL HEADER                                 */
  /* ------------------------------------------------------------------ */
  function injectButton() {
    // Material v9 header inner row selectors (try several)
    const targets = [
      ".md-header__inner .md-header__options",  // v9.x
      ".md-header__inner",                       // fallback – append to inner
    ];

    let container = null;
    for (const sel of targets) {
      container = document.querySelector(sel);
      if (container) break;
    }

    if (!container) {
      // Last resort: append to header
      container = document.querySelector(".md-header");
    }
    if (!container) return;

    // Don't inject twice (e.g. on SPA navigations)
    if (document.getElementById("lang-toggle-btn")) return;

    const btn = createButton();
    container.appendChild(btn);
  }

  /* ------------------------------------------------------------------ */
  /*  INIT                                                                */
  /* ------------------------------------------------------------------ */
  function init() {
    injectButton();

    // Restore persisted language
    if (currentLang === "he") {
      applyLang("he");
    }

    // Re-inject button after MkDocs SPA navigations
    // (Material uses pushState; header stays but inner content refreshes)
    document.addEventListener("click", function (e) {
      // If a nav link was clicked, re-inject button after page paints
      if (e.target.closest("a[href]")) {
        requestAnimationFrame(() => {
          injectButton();
          if (currentLang === "he") {
            // Small delay to let MkDocs Material finish rendering
            setTimeout(() => applyLang("he"), 80);
          }
        });
      }
    });
  }

  /* Run after DOM ready */
  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", init);
  } else {
    init();
  }
})();
