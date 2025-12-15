2025-11-27 — ChatGPT
What I Asked / Generated: Asked ChatGPT to debug why my Flutter login screen was not routing correctly into the main app after authentication. GPT analyzed my navigation flow and identified a missing Navigator.pushReplacement() call along with a misplaced authStateChanges listener that was causing repeated rebuilds.
Reflection: I learned how Flutter’s routing system interacts with authentication streams and how easily infinite route loops can occur when navigation logic is placed inside rebuilding widgets.

2025-11-29 — ChatGPT
What I Asked / Generated: Requested help diagnosing why a Firestore document was not being created during user registration. GPT explained that I was incorrectly using .update() on a document that did not yet exist and recommended switching to .set() with default fields.
Reflection: This helped clarify the functional difference between .set() and .update() in Firestore and reinforced best practices for initializing user data during onboarding.

2025-12-01 — ChatGPT
What I Asked / Generated: Asked why my XP progress bar was not visually updating after experience gains were written to Firestore. GPT pointed out that the widget was not rebuilding because setState() was never called after the async update completed.
Reflection: I gained a stronger understanding of Flutter’s state lifecycle and how asynchronous backend updates require explicit UI refresh triggers.

2025-12-03 — ChatGPT
What I Asked / Generated: Debugged an issue where avatar colors were rendering incorrectly on screen. GPT identified that I was mixing raw integer color values with Color() objects inside a custom painter.
Reflection: This reinforced how Flutter’s color system works internally and why storing normalized indices instead of raw color values leads to cleaner, safer rendering logic.

2025-12-05 — ChatGPT
What I Asked / Generated: Asked for help resolving a crash caused by null hairColorIndex values when loading a new user profile. GPT suggested adding safe defaults inside the PlayerProfile.fromDoc factory constructor.
Reflection: I learned the importance of defensive model construction and null safety when working with partially initialized Firestore documents.

2025-12-07 — ChatGPT
What I Asked / Generated: Debugged a guild creation issue where users were not being redirected to the home screen after creating a guild. GPT helped restructure the navigation so Navigator.pushAndRemoveUntil() executed only after the Firestore write completed.
Reflection: This highlighted the importance of awaiting asynchronous backend operations before triggering navigation to avoid UI–backend desynchronization.

2025-12-10 — ChatGPT
What I Asked / Generated: Reported a bug where pressing the “Encounter!” button did not award XP. GPT discovered that the encounter screen only handled UI rendering and never invoked the backend XP update logic.
Reflection: This reinforced the need to keep UI and game logic decoupled while ensuring they are explicitly connected through callbacks or services.

2025-12-12 — ChatGPT
What I Asked / Generated: Asked how to prevent users from claiming the daily reward multiple times. GPT recommended adding a dailyRewardClaimed boolean field and resetting it through a daily reset service.
Reflection: I learned how to implement time-based gameplay mechanics and the importance of server-side validation for reward systems.

2025-12-14 — ChatGPT
What I Asked / Generated: Requested help designing the leaderboard and debugging incorrect weekly guild step totals. GPT assisted with a Firestore query ordering guilds by weeklySteps and suggested batch updates for weekly resets.
Reflection: This improved my understanding of structuring competitive, multi-user systems in Firestore while avoiding race conditions during scheduled resets.

2025-12-16 — ChatGPT
What I Asked / Generated: Debugged why selected cosmetic rewards were not saving correctly. GPT found that the selected cosmetic was never passed into the saveCosmetics() update payload.
Reflection: I learned how easily state can be lost between UI, service layers, and Firestore if values are not explicitly propagated.

2025-12-18 — ChatGPT
What I Asked / Generated: Asked for final debugging help across character creation, guild selection, and home screens. GPT helped unify field names, prevent null crashes, and clean up overall navigation flow.
Reflection: This emphasized the value of consistent data models, modular services, and clean routing structures in larger Flutter applications.
