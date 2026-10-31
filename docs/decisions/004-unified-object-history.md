# ADR-004: One renovation object and its history
Accepted: direct user correction after testing build 18.

## Problem
The prototype exposed objects as issue journals and rooms as another screen. This obscured the intended renovation journey and disconnected the user's initial photo from measurements and later outcomes.

## Decision
An object is the renovation project (a bathroom, kitchen, bedroom or larger space). Creating it collects a name, initial photo and wishes together. Object and first history entry are written atomically. Its primary screen combines measurements, chronological records and proposal availability. Add dated updates for initial state, progress or result. Measurements expand on the same screen; the old separate rooms-list shortcut is removed from the primary route.

## Existing data
Keep existing objects, issues, photos and named room measurements. Display legacy issues alongside the history by their original objectId and timestamp. Preserve status editing in the secondary issue-management view. Measurement records remain in their existing store and appear inline. No destructive migration, relabelling old photos as initial state or fabricated timestamps.

A new per-account history store has the same cascade-deletion rules as issues/measurements. Each entry stores objectId, phase, user origin, description, optional photo and UTC timestamp. Before entries require a photo. Unknown phases and user-supplied proposal events are rejected. Account deletion clears its history; guest and other accounts remain separate.

## Proposals and remaining work
Photo analysis and proposal generation are still unavailable. Show this explicitly rather than inserting fake suggestions. When connected, generated proposals must retain provenance, generation status, input references and versioned results. The same object history is the target for generated visuals and specifications, not another unrelated product screen.

## Verification
Tests cover atomic initial capture, persistence, stage ordering, account isolation, deletion and preservation of a legacy photo. Widget tests exercise photo-based creation and the history at 3x text in both themes. A separate normal-size regression checks root tab height stays between 48 and 56 logical pixels without a device safe-area inset. Native hardware confirmation is separate from these checks.
