# ADR-003: Profile and root tabs
Date: 2026-10-31. Accepted by direct user request.

## Problem
The language/appearance popup menus look dated on the physical iPhone and crowd the object app bar. The user requested bottom navigation and a profile containing identity and settings.

## Decision
Use two real root destinations: Properties and Profile. Preserve root state with IndexedStack. Child detail/edit routes cover the root tabs. Move preferences to Profile, open full scrollable selection pages with selected semantics/checkmarks, persist then return. No new placeholder destinations.

The bottom bar uses content-based height so large system text remains visible. Selected icons use filled counterparts; unselected icons are outlined. Profile rows and selection lists use the existing theme, cards and borders in both appearances. All text uses ARB.

Profile display name is local per-account data; guest name is separate. Do not infer a real name from email or developer account data. Existing journal stores and photos remain unchanged. Cloud profile synchronization is not implemented.

## Evidence and limits
48 tests passed, including 3x text on a 320x568 viewport, preferences, account navigation and name isolation. Browser inspection and iOS release compilation passed. Build 18 installed on the owner's iPhone 6s. Hardware feedback for the new profile screens remains pending.
