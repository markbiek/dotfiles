# Example SNAP Post

This is a reference example showing the expected tone, structure, and formatting. Use this as a guide when generating SNAP post drafts.

---

# Quake snaps: RTR Migration, CIAB & MSD Domain Improvements, Account Creation Experiment

This update covers January 19–30, 2026

## RTR integration in full swing

The KeySystems to Realtime Register (RTR) integration and migration project picked up serious velocity. We implemented the bulk of the RTR_Reseller_API - dozens of methods covering registration, transfer, renewal, cancellation, privacy, locking, auth codes, contacts, nameservers, ownership changes, availability checks, and more. We leveraged Claude code and Cursor to really speed up the integration of the API.

## CIAB & MSD Domain Improvements

Luis and Leonardo shipped multiple improvements to domain flows in both MSD and CIAB.

Luis delivered a series of MSD domain flow improvements: updated the "While you wait" card on the domain connection verification page, added DNS requirement messaging for email forwarding, implemented redirects back to the dashboard after domain operations, routed users to the correct /setup/domain/use-my-domain flow for owned domains, updated /start/domain and /setup/domain-transfer to link back to the dashboard, changed MSD and CIAB domain operation URLs, and added /home/%s redirect after signup checkout.

Leonardo worked on CIAB domain integration: updated the redirectTo URL when buying a domain for a CIAB site, fixed the "Transfer to WordPress.com" link in the MSD dashboard for CIAB, deployed a fix for domain move internal product not consuming domain credit, added a status badge to the "Domain connection setup" button, and triaged issues in the CIAB domains view.

## Placement Plus

We had to do a call with Identity Digital to clarify how to implement the Placement Plus position in our suggestion results - turns out they need to create a new account for us, and are working on fixes some issues on their side. We need to adjust the weights in their dashboard to get better result variability but we've decided to do that after they create our new account and fix the other issue.

## VideoPress

Paulo and Leonardo reviewed VideoPress PRs - upload retry logic, video query fixes, and attachment details. Paulo created follow-up issues found during reviews, including duplicate activation offers.

## Bug fixing, fine tuning and improvements

- Investigated Key-Systems timeouts affecting 1.4% of all requests - they went away after 20 hours
- Fixed domain move internal product consuming domain credit incorrectly
- Disabled Google Domains landing page (302 redirect to /domains/)
- Investigated Jetpack connection issue after migration - removed stale jetpack_connection_protected_owner_error option
- Cleaned up stale CIAB/Garden Linear issues
- Investigated .in availability check issues with KeySystems

+snapsp2 #snaps

---

## Key Style Observations

- Third person, past tense throughout
- Team members referred to by first name
- Conversational but informative tone — not overly formal
- Sections vary in length based on significance of the work
- Catch-all section at the bottom uses simple bullet points
- No links to Slack messages; PRs and Linear issues linked inline when available
