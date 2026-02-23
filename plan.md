# Roguelike v5.1 — Project Plan

## 📚 Documentation Location

All project documentation is now organized in Obsidian vault:
- Path: `Roguelike-v5.1/` folder in your Obsidian vault
- Start with: `INDEX.md` for navigation

## 🎯 Quick Links

### Core Documents
- Constitution: `00_PROJECT_CONSTITUTION.md`
- Folder Structure: `01_FOLDER_STRUCTURE.md`
- EventBus Contract: `02_EVENTBUS_CONTRACT.md`
- RNG Ownership: `03_RNG_OWNERSHIP_SPEC.md`

### Phase Plan
- Main Plan: `08_MAIN_PHASE_PLAN.md`
- Phase 1: `09_PHASE_1.md` (Core Infrastructure)
- Phase 2: `10_PHASE_2.md` (Dice & Modifier System)
- Phase 3: `11_PHASE_3.md` (Stored Dice Economy)
- Phase 4: `12_PHASE_4.md` (Loot Integration)
- Phase 5: `13_PHASE_5.md` (Combat Polish)
- Phase 6: `14_PHASE_6.md` (Stabilization)

### Enforcement System
- AES Overview: `15_ARCHITECTURE_ENFORCEMENT_SYSTEM.md`
- All checks: `16-22_*_CHECK.md`
- Gate Rules: `23_PHASE_GATE_RULES.md`

### Kiro Integration
- Prompt Templates: `Kiro-Prompts/` folder
- Spec System: `Kiro-Integration/KIRO_SPEC_SYSTEM.md`
- Feature Template: `Kiro-Integration/KIRO_SPEC_TEMPLATE_FEATURE.md`
- Bugfix Template: `Kiro-Integration/KIRO_SPEC_TEMPLATE_BUGFIX.md`

## 🚀 Getting Started

1. Open Obsidian vault
2. Navigate to `Roguelike-v5.1/INDEX.md`
3. Read `00_PROJECT_CONSTITUTION.md`
4. Review `08_MAIN_PHASE_PLAN.md`
5. Use `Kiro-Prompts/KIRO_PHASE_1_PROMPTS.md` to start

## 🔄 Workflow

### For New Features
1. Create spec using `KIRO_SPEC_TEMPLATE_FEATURE.md`
2. Link to relevant constitution docs
3. Use Kiro prompts from `Kiro-Prompts/` folder
4. Run AES checks after implementation

### For Bugfixes
1. Create spec using `KIRO_SPEC_TEMPLATE_BUGFIX.md`
2. Document bug condition
3. Use Kiro prompts for implementation
4. Verify preservation properties

## 📊 Current Status

- **Phase**: Not Started
- **Next Action**: Review constitution and start Phase 1
- **AES Violations**: 0

## 🔗 Integration Benefits

✅ All docs linked with WikiLinks
✅ Backlink tracking for dependencies
✅ Visual canvas for architecture
✅ AI context enrichment
✅ Single source of truth
✅ Version control ready

## 📝 Notes

- All Obsidian notes use WikiLink format: `[[Document Name]]`
- Kiro can reference these notes in prompts
- Specs sync between `.kiro/specs/` and Obsidian
- Weekly drift audits recommended
