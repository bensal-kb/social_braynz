# Inventory & Stock Manager

A small Flutter app for a shop owner to keep track of what's in stock, log sales as they happen, and get nudged when something's running low. The brief was clear that connectivity can't be trusted, so the whole thing is built to work with no signal at all and catch up automatically once it's back.

## Setup

1. `flutter pub get`
2. The Firebase project (`social-braynz`) is already wired up — `firebase_options.dart`, `google-services.json` and `GoogleService-Info.plist` are all committed, so you shouldn't need to run `flutterfire configure` again. Cloud Firestore itself still has to be turned on once per project though (see below if you're setting this up somewhere fresh).
3. `flutter run`



## 1. What I built, and what I left out

**What's there:**
- Adding, editing and removing products (name, quantity, price, and a per-product low-stock threshold)
- Logging a sale, which deducts from stock
- Low-stock alerts — a banner on the home screen, a filtered "Low Stock" list, and an actual on-device notification the moment something crosses its threshold
- Everything above works with the network off, and syncs on its own once it's back
- Product list, product detail (with the last 10 sales for that item), an add/edit form, and a log-sale screen, all wired together with go_router

**What I skipped, and why:**

- No Authentication and no Firestore rules are wide open (`allow read, write: if true`). 

- I thought about building a local database with my own sync queue (something like Drift or Isar plus a hand-rolled outbox table), but since Firestore's offline persistence actually gives you for free, it does the job already — the local cache queues writes and merges them back in on reconnect without me writing any of that logic myself. Adding a second local store on top would've meant keeping two sources of truth in sync with each other, which felt like solving a problem I didn't have. More on the trade-offs that comes with in the next section.

- Duplicate product

## 2. How offline and sync actually work

Everything runs through `cloud_firestore` with `persistenceEnabled: true`. That local cache *is* the offline store — every read and write hits it first, instantly, whether or not there's a connection, and the SDK handles queuing and re-syncing pending writes on its own. I didn't build a separate database or a dirty-flag table on top of it.

## 3. If I had two more days

Roughly in the order I'd tackle them:

1. Real authentication, and security rules
3. A proper sales report across the whole shop, with date filtering and totals. The schema already supports it.
4. Dynamic Low-stock thresholds based on sales
5. Custom backend or cloud functions
6. Tapping the low-stock notification should take you straight to that product's detail page.
7. General UI polish
8. better dashboard and trends
