# Toggle Builder

**Author:** Marvin  
**Version:** 1.1

## Description

Toggle Builder automatically generates a fully functional 2-state toggle button for GrandMA2 Layout View.

### It creates:
- A sequence with 2 cues (ON / OFF)
- ON cue copies the ON image → STATE image slot
- OFF cue copies the OFF image → STATE image slot
- Assigns the sequence to your chosen Executor
- Creates a macro that runs: `Go Executor <page>.<exec>`
- Assigns the STATE image as the macro icon automatically <- STILL WORK IN PROGRESS

## Validation

The plugin performs the following checks:
- ✓ Checks if images exist
- ✓ Checks if macro slot is free
- ✓ Checks if executor is free
- ✓ Finds a free sequence automatically

## Usage

1. **Import your 3 images into the Image Pool:**
   - ON image (example: pool #1)
   - OFF image (example: pool #2)
   - STATE image (example: pool #3)

2. **Run plugin "Toggle Builder".**

3. **Enter requested values.**

4. **Place macro into Layout View:**
   - Visualization: Simple
   - No need to select image — already assigned! <- IN THE FUTURE.

**DONE** — Your interactive toggle button works instantly.

## License

This plugin is provided as-is for use with GrandMA2.

---

*For issues or feature requests, please contact the author.*
