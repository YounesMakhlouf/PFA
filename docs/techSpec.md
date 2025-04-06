**1. Introduction**

This document outlines the technical specifications for a mobile application designed to support children with learning difficulties. The app provides engaging and educational games tailored to their specific needs, focusing on areas like basic concepts, emotion recognition, and logical thinking. A key feature is the ability for parents to monitor progress using the *same account* the child uses. The application will be developed using Flutter for cross-platform mobile deployment (iOS & Android) and will leverage Supabase for backend services.

**2. Goals & Objectives**

- **Primary Goal:** To create a safe, engaging, and effective mobile learning environment for children with learning difficulties, managed by their parents.
- **Key Objectives:**
    - Develop interactive games teaching fundamental concepts (colors, numbers, shapes, animals, fruits, vegetables) using non-stimulant design.
    - Create games specifically focused on recognizing and understanding emotions.
    - Implement activities promoting logical thinking and problem-solving (puzzles, identify the intruder).
    - Ensure a user interface and experience designed according to autism-friendly principles (See Section 7).
    - Provide an integrated dashboard accessible *after login* for parents to track the child's progress within the app.
    - Develop a *separate, web-based interface* for verified Educators/Specialists to submit new game configurations.

**3. Target Audience**

- **Primary Users (Child):** Children with learning difficulties. The design, content, and interaction patterns must be tailored to their specific learning styles and sensory sensitivities.
- **Secondary Users (Parent/Guardian):** Parents or guardians who will set up the account, manage settings, and use the integrated dashboard to monitor the child's progress. *They will log in using the same credentials associated with the child's profile.*
- **Tertiary Users (Educator/Specialist - External):** Verified professionals who will use a *separate, dedicated web-based form/portal* (not the mobile app) to propose and submit new game content/configurations.

**4. System Architecture**

- **Frontend:** Cross-platform Mobile Application developed using **Flutter**.
- **Backend:** **Supabase** (Backend-as-a-Service)
    - **Authentication:** Supabase Auth for managing the single account per child (used by both child for games and parent for management/dashboard).
    - **Database:** Supabase PostgreSQL for storing account data, child profile details, game content, progress metrics, etc.
    - **Storage:** Supabase Storage for hosting game assets (real images, audio files, story content).
    - **Functions (Potential):** Supabase Edge Functions for custom backend logic (e.g., generating AI progress summaries, processing submitted game content from educators).
- **AI/ML:**
    - **On-Device (Optional):** Google ML Kit (via Flutter plugin google_ml_kit) for potential features like expression recognition in specific emotion games. Requires explicit user consent and careful consideration of privacy and performance.
    - **Cloud (Parent Dashboard):** An AI service (e.g., OpenAI API via GPT-4, Google Gemini API - **Decision Needed**) integrated via Supabase Functions for generating summary progress reports displayed on the parent dashboard.
- **Educator Content Submission:** A separate **Web Application/Form** (Technology TBD - could be simple HTML/JS with Supabase backend or a framework like React/Vue) allowing educators to structure and submit game data. This requires its own verification/authentication mechanism for educators, separate from the main app.

**5. Core Features (MoSCoW Prioritization)**

**5.1 Must-Have Features (MVP):**

- **Account Setup & Management:**
    - Ability for a parent to create *one account* per child.
    - Secure login mechanism (email/password or potentially social login via Supabase Auth).
    - Child Profile Creation within the account: Name, Age (or Birthdate), Avatar selection. Option to note specific conditions (e.g., Autism, ADHD - from a predefined list) for potential future adaptation (not for altering core MVP gameplay initially).
- **Autism-Friendly UI/UX:**
    - Strict adherence to all design principles outlined in Section 7.
    - Simple, predictable navigation.
- **Core Educational Games (Initial Set):**
    - **Colors:** Identification ("Touch the Red apple"). Use real images. Start with 3-4 distinct, high-contrast colors.
    - **Numbers:** Simple identification and counting (e.g., "How many cats?").
    - **Animals:** Identification using real images ("Touch the dog").
    - **Shapes:** Identification and simple matching ("Match the circles").
    - **Fruits & Vegetables:** Identification using real images.
- **Logic & Emotion Games (Basic):**
    - **Puzzles:** Simple 4-6 piece jigsaw puzzles using real images.
    - **Identify the Intruder:** Basic logic game ("Which one doesn't belong?" - e.g., 3 fruits, 1 animal).
    - **Emotion Identification:** Matching simple, clear facial expressions (photos or highly realistic drawings) to labels ("Happy", "Sad", "Angry").
    - Memory Games: Simple matching pairs (shapes, animals).
- **Basic Progress Tracking:**
    - Backend storage of game completion status, success/failure per attempt, and time taken per game/level. (Foundation for the dashboard).

**5.2 Should-Have Features:**

- **Parent/Guardian Dashboard:**
    - Accessible section within the app *after login*.
    - Displays child's progress: Games played, time spent, accuracy (% correct attempts), potentially areas needing more practice. Visual charts for trends.
- **Game Assistance:**
    - **Hints:** Optional, subtle visual cues if a child struggles (e.g., briefly wiggle the correct item after a delay). Avoid giving the answer directly. Configurable on/off by parent.
    - **Demos:** Optional short, silent animation showing how to play before a new game type starts.
- **Audio Support:**
    - Clear voice narration for instructions and feedback ("Well done!", "Try again").
    - Optional background music/sounds (must be configurable and default to off or very low).
- **AI-Generated Progress Summaries:**
    - On the dashboard, provide concise text summaries of progress trends and potential focus areas based on tracked data (using the selected Cloud AI service).
- Offline mode capabilities for games.
- **Game Levels:** Introduce increasing difficulty within games (e.g., more puzzle pieces, more choices, more complex patterns).

**5.3 Could-Have Features:**

- **Account/Profile Customization:** Allow parents to adjust settings like hint frequency, sound preferences, select from predefined safe color palettes for backgrounds.
- **Relaxation Activities:** Dedicated section with calming visuals (slow animations, nature scenes), simple guided breathing exercises, or calming sounds.
- **Stories:** Short (2-5 min), simple interactive stories with clear visuals focusing on social situations or routines. Option to repeat.
- **Advanced Emotion Games:** Using ML Kit (with consent) for expression recognition ("Make a happy face").
- **Voice Recognition Input:** Allow verbal responses in certain identification games (requires robust speech-to-text integration).
- **Educator Content Submission Portal (Implementation):** Building the actual web form/portal for educators (defined in Architecture). Requires a verification process for educators.
- Localization to other languages.
- Adding more game categories (e.g., social skills scenarios, fine motor tracing games, daily routines).
- Integration with external calendars or communication tools (with explicit consent).
- Advanced AI: Adaptive difficulty, personalized game recommendations, deeper pattern analysis in reports.

**5.4 Won't-Have Features (At Launch):**

- Multiplayer or social interaction features.
- AI-powered conversational chatbot for the child.
- Direct messaging between parents and educators within the app.
- In-app purchases or advertisements.

**6. Data Management**

- **Database:** Supabase PostgreSQL.
- **Data Storage:** Game assets (images, audio) stored in Supabase Storage, referenced by URL or path in the database.
- **Data Privacy:**
    - Minimize collection of Personally Identifiable Information (PII).
    - Implement robust security measures (encryption at rest and in transit).
    - Obtain clear, informed parental consent during account setup regarding data collection, usage (especially for progress tracking and AI analysis), and any potential ML Kit features.
    - Provide clear privacy policy and data management options for parents.

**7. Design & UX Considerations (Autism Specific)**

- **Colors:** Use muted, calm palettes (soft blues, greens, lilacs, neutrals). Avoid high saturation, especially reds and yellows. Ensure high contrast for text/elements. Refer to established autism-friendly palettes.
- **Layout:** Clear, consistent, predictable structure. Ample white space. Minimal elements per screen. Focus on one task at a time. Avoid visual clutter.
- **Content:** Prioritize real photographs over cartoons where appropriate (especially for identification tasks). Use clear, literal language. Avoid idioms, sarcasm, or metaphors. Support text with clear icons/images.
- **Navigation:** Simple, persistent main navigation (e.g., bottom bar). Large, clear buttons with both icons and text labels. Clear back buttons. Progress indicators for multi-step activities.
- **Interactions:** Avoid sudden noises, flashes, or unexpected animations. No auto-playing videos/sounds on load. Ensure large tap targets. Provide clear feedback for actions (visual and optional audio). Avoid timeouts or time pressure unless part of a specific game mechanic (and make it optional). No horizontal scrolling.
- **Consistency:** Maintain consistent placement of common elements (e.g., 'Next', 'Back', 'Home') across all games and screens.

**8. Technology Stack**

- **Mobile Development:** Flutter SDK (latest stable version)
- **UI Framework:** Flutter Widgets (Material Design adaptation or custom)
- **State Management:** **Riverpod**
- **Game Logic:** Primarily Flutter framework. Consider **Flame Engine** *only* if complex 2D animations, physics, or particle effects are deemed necessary for specific games (adds complexity).
- **Backend:** Supabase (Auth, PostgreSQL, Storage, Edge Functions)
- **AI/ML:**
    - On-Device: google_ml_kit Flutter package (for potential "Could Have" features)
    - Cloud Reports: OpenAI API or Google Gemini API (**Decision Needed** based on cost, features, ease of use) via Supabase Functions.
- **Educator Portal:** TBD (e.g., Static HTML/JS + Supabase, Next.js, etc.) - Separate decision.
- **Version Control:** Git (https://github.com/YounesMakhlouf/PFA)
- **Project Management:** Jira (https://insat-team-um2d7n9w.atlassian.net/jira/software/projects/PFA/boards/2)

**9. API Specifications**

- Primary backend interaction via the official supabase-flutter client library.
- Define clear input/output contracts (request/response schemas) for any custom Supabase Edge Functions created (e.g., generateProgressReport(childId,dateRange), processEducatorSubmission(submissionData))

**10. Non-Functional Requirements**

- **Performance:** Target <200ms UI response time for interactions. Smooth animations (60fps). Fast game load times (<3 seconds). Optimized asset loading.
- **Scalability:** Supabase provides managed scaling. Database queries must be optimized (use indexes, efficient joins). Design for potential growth in users and content.
- **Security:** Secure authentication (password hashing via Supabase Auth). Role-based access control *within the backend functions* if needed (e.g., ensuring only authorized functions can trigger AI analysis). Encrypted data transmission (HTTPS default with Supabase). Regular security audits.
- **Accessibility:** Adhere to WCAG AA guidelines where applicable. Crucially, implement all autism-specific UX considerations (Section 7). Support dynamic font sizes if feasible.
- **Reliability:** High availability (>99.5%). Graceful degradation if network fails (offline caching of basic data).
- **Maintainability:** Clean, well-documented code. Consistent coding style. Use of a clear architectural pattern. Modular design for games.

**11. Deployment & Infrastructure**

- **Frontend:** Standard build/release pipelines for Apple App Store and Google Play Store. Utilize tools like Codemagic or GitHub Actions for CI/CD.
- **Backend:** Managed entirely via Supabase cloud platform. Monitor usage and scaling within the Supabase dashboard.
- **Educator Portal:** Deployed separately (e.g., Vercel, Netlify, Supabase hosting).

**12. Assumptions**

- Parents have sufficient technical literacy to download an app, create an account, and navigate basic interfaces.
- The target devices (smartphones/tablets) have adequate performance for Flutter apps and potential ML Kit usage.
- Real images suitable for game content are available or can be sourced (stock photos, custom photography).
- Parents will provide necessary consent for data collection and processing.

**13. Open Questions / Decisions Needed**

- Final decision on Cloud AI service for reports (OpenAI vs. Google Gemini vs. other). Define evaluation criteria (cost, accuracy, privacy, ease of integration).
- Specific list of initial SpecialCondition tags to include. How will they be used initially, if at all?
- Technology choice and hosting for the separate Educator Content Submission Portal.
- Detailed requirements and verification process for Educators using the submission portal.
- Specific metrics and visualizations for the Parent Dashboard V1.
- Feasibility and exact implementation plan/consent flow for any on-device ML Kit features.