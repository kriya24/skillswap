# SkillSwap

Trade what you know for what you want to learn. Users list skills they can teach and skills they want to learn, and the site matches them with neighbors who want the opposite.

**Live demo:** _add your link here_
**Screenshot:** _add a screenshot or GIF here_

## Tech stack (all free)
- **Frontend:** HTML, CSS, JavaScript
- **Backend, API and auth:** Supabase (auto-generated API, email login)
- **Database:** PostgreSQL (inside Supabase) with Row Level Security
- **Hosting:** Netlify or GitHub Pages

## Setup (about 30 minutes)
1. **Create a Supabase project** at supabase.com (free plan). Save the database password.
2. **Create the database:** open *SQL Editor*, paste all of `schema.sql`, click *Run*.
3. **For local testing, turn off email confirmation:** *Authentication > Providers > Email > Confirm email = off*.
4. **Get your keys:** *Project Settings > API*. Copy the Project URL and the `anon public` key.
5. **Paste them** at the top of the `<script>` in `index.html` (`SUPABASE_URL`, `SUPABASE_KEY`). The anon key is safe to publish because Row Level Security protects the data.
6. **Run it:** install VS Code, add the *Live Server* extension, right-click `index.html`, choose *Open with Live Server*.
7. **Test with two accounts** (use a private window for the second). Give account A "teach Guitar, learn Spanish" and account B "teach Spanish, learn Guitar". Each should show up in the other's matches.

## Deploy
1. Create a GitHub repo and upload these files (or use GitHub Desktop).
2. On netlify.com choose *Add new site > Import from GitHub*. No build settings are needed.
3. In Supabase, go to *Authentication > URL Configuration* and add your Netlify link as the Site URL.

## How it works
- `schema.sql` creates two tables (`profiles`, `skills`), security rules, and a `find_matches()` database function.
- `index.html` talks to Supabase directly. Signup and login use Supabase Auth, skills are saved with `insert`/`delete`, and matches come from `rpc('find_matches')`.

## Roadmap (each item makes a good commit)
- [ ] Skill categories and a search box
- [ ] Messaging or "Request a swap" button
- [ ] Ratings and reviews after a swap
- [ ] Map or distance filter (Leaflet)
- [ ] Profile photos (Supabase Storage)
- [ ] Split the file into `style.css` and `app.js`, then move to React
