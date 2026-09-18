# Test plan

## Automated unit tests

`WeightParserTest`
- decimal point
- decimal comma
- common OCR character repair
- missing decimal point recovery
- rejection outside scale range

`StabilityTrackerTest`
- requires configured stable sample count
- rejects a window wider than the allowed tolerance

`MeasurementSessionTest`
- prevents the same package from being counted twice
- requires a stable near-zero reading before accepting the next package
- computes exact decimal sum
- completes after ten measurements and final clear

## Device acceptance test

Before actual use:

1. Place phone on a fixed stand 15–30 cm from the scale.
2. Fill the white guide with only the scale digits.
3. Tap digits once to focus.
4. Put the same test object on the scale 10 times, removing it fully between trials.
5. Verify all ten stored values visually against the scale.
6. Repeat in the actual room lighting.
7. Deliberately move the object while the reading is changing; verify no transient value is stored.
8. Leave the object on the scale after capture; verify it is not counted twice.
9. Remove it; verify the UI switches to “Nächste Packung auflegen” only after near-zero is stable.
10. Compare the app's sum to a manual sum.

If any OCR digit is consistently confused, adjust the ROI and parser for that exact display before relying on automatic logging.
