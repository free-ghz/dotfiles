#!/usr/bin/env node
/**
 * Extract JS from <script> tags while preserving original line numbers.
 * Lines outside <script> bodies become empty lines.
 *
 * This lets eslint report line numbers that match the HTML file.
 */
import fs from "node:fs";

const file = process.argv[2];
if (!file) {
  console.error("Usage: extract_js_from_html.mjs <file.html>");
  process.exit(2);
}

const src = fs.readFileSync(file, "utf8");
const lines = src.split(/\r?\n/);

let inScript = false;
let ignoreThisScript = false; // script has src=, or non-js type

function isScriptOpen(line) {
  return /<script\b/i.test(line);
}

function isScriptClose(line) {
  return /<\/script\s*>/i.test(line);
}

function hasSrcAttr(line) {
  return /\bsrc\s*=/i.test(line);
}

function isNonJsType(line) {
  // If there's an explicit type and it's not JS-ish, ignore.
  const m = line.match(/\btype\s*=\s*["']([^"']+)["']/i);
  if (!m) return false;
  const t = m[1].toLowerCase();
  if (t.includes("javascript") || t.includes("ecmascript") || t === "module") return false;
  // Common "template" types, json, etc.
  return true;
}

const out = [];
for (let i = 0; i < lines.length; i++) {
  const line = lines[i];

  if (!inScript && isScriptOpen(line)) {
    inScript = true;
    ignoreThisScript = hasSrcAttr(line) || isNonJsType(line);
    // Don't output the <script ...> line as JS.
    out.push("");
    // If <script> and </script> are on the same line, handle inline.
    if (isScriptClose(line)) {
      // Extremely rare; just blank it.
      inScript = false;
      ignoreThisScript = false;
    }
    continue;
  }

  if (inScript && isScriptClose(line)) {
    // Don't output the </script> line as JS.
    out.push("");
    inScript = false;
    ignoreThisScript = false;
    continue;
  }

  if (inScript && !ignoreThisScript) {
    out.push(line);
  } else {
    out.push("");
  }
}

process.stdout.write(out.join("\n"));

