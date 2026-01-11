# Quality for Biters! — Specification (spec)

This document records the **design intent, specifications, and agreed decisions** of Quality for Biters!.

---

## 0. Purpose and Non-goals

### 0.1 Purpose
- Add “quality” as a growth axis to enemy units
- Gradually increase combat difficulty as evolution progresses
- Add long-term pressure and variety to late-game combat

### 0.2 Non-goals
- It does not aim to significantly increase early-game difficulty
- It does not modify enemy AI behavior
- It does not target a single planet for extreme difficulty spikes

---

## 1. Scope

- Nauvis:
  - All enemy units
  - Biter spawners
  - Spitter spawners
- Gleba:
  - All enemy units
  - Gleba spawners

---

## 2. Quality Determination

- Enemy quality is determined probabilistically based on the current evolution factor
- High-quality enemies are rare in early stages
- The probability increases as evolution progresses

---

## 3. Difficulty Design

- Moderate difficulty increase on normal settings
- Significantly higher defensive pressure on Death World / Marathon
- Designed to apply sustained pressure rather than sudden hard locks

---

## 4. Compatibility

- Depends on Manis_lib
- Requires the Quality mod
- Does not alter global enemy AI or behavior

---

## 5. Determinism / Multiplayer

- Randomness uses deterministic methods
- Multiplayer reproducibility is assumed
- Any deviation is treated as a bug

---

## 6. Status of This Specification

- This document takes precedence over README and Mod Portal descriptions
- If discrepancies arise, either the implementation or this specification must be explicitly chosen as authoritative