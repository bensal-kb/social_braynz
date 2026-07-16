# Inventory & Stock Manager

A Flutter app for a small shop owner to track inventory, log sales, and get alerted when stock runs low — built to work fully offline and sync automatically when connectivity returns.

## Setup

1. `flutter pub get`
2. Firebase project `social-braynz` is already wired up (`firebase_options.dart`, `google-services.json`, `GoogleService-Info.plist` are committed). Cloud Firestore itself needs to be enabled once per project — see "Firestore setup" below if you're standing this up fresh.
3. `flutter run`

### Firestore setup (one-time, per Firebase project)

```bash
# 1. Enable the Firestore API (or click the link from the 403 error the first time you run the app)
gcloud services enable firestore.googleapis.com --project=<your-project-id>

# 2. Create the default database
firebase firestore:databases:create "(default)" --location=asia-south1 --project=<your-project-id>

# 3. Deploy open security rules (see "What was left out" — this app has no auth)
firebase deploy --only firestore:rules --project=<your-project-id>
```

## 1. What I built, and what I deliberately left out

**Built:**
- Add / edit / remove products (name, quantity, price, per-product low-stock threshold)
- Log a sale, which deducts stock
- Low-stock alerts: an in-app banner + filtered "Low Stock" view, and a local (on-device) push notification the moment a product crosses its threshold
- Fully offline read/write for all of the above, with automatic sync when connectivity returns
- A products list, product detail (with its last 10 sales), add/edit form, and a log-sale screen — go_router for navigation

**Left out, on purpose:**

- **Authentication.** There's no login, and Firestore security rules are wide open (`allow read, write: if true`). For a real product this is the first thing I'd fix — but building auth well (and rules that reference it) is a multi-hour detour that wasn't going to make the product meaningfully better *for this assessment*, and open rules make the app trivial to demo/test. Flagging this loudly rather than shipping it quietly.
- **A global sales history / report screen.** The brief asks to "log a sale," not to report on all sales across the shop. I show the last 10 sales *per product* on the detail screen (cheap, no extra index ceremony) and left a shop-wide sales report for later.
- **A local database (Drift/sqflite/Isar).** I initially considered a local DB + hand-rolled outbox/sync-queue, but Firestore's own offline persistence (`persistenceEnabled: true`) already *is* a local cache that queues writes and merges them on reconnect — building a second local store on top would have been redundant complexity for what this app needs. See section 2 for the trade-offs that decision comes with.
- **Barcode scanning, product images, multi-user/multi-shop support, CSV export.** None of these were in the brief; happy to scope them in if useful.
- **Stock-out prevention while offline.** Explained in section 2 — this is the most important trade-off in the whole app, worth reading if you read nothing else here.

## 2. How I handled offline support and sync/conflict resolution

The whole data layer is `cloud_firestore` with `persistenceEnabled: true`. Its local cache **is** the offline store: every read/write hits the cache first (instantly, whether or not you have a connection), and the SDK transparently queues pending writes and re-syncs them the moment the device reconnects. I did not build a custom local database or a hand-rolled dirty-flag/outbox table — Firestore already does this, and duplicating it would have meant two sources of truth to keep consistent instead of one.

That default behavior is *mostly* free, but it has two sharp edges that directly affect "log a sale," which needs to atomically decrement stock:

1. **`runTransaction()` requires connectivity.** Transactions read the authoritative server value before writing, so they can't run purely against the local cache. They do *not* fail fast offline, though — the SDK default is a 30-second timeout with 5 retry attempts, and in practice (half-open connections after airplane mode) even the SDK timeout can fail to fire. The online attempt is therefore bounded by a Dart-side `Future.timeout(5s)` that always fires, with an `abandoned` guard inside the transaction handler so a late-completing transaction can't double-log a sale that the offline fallback already recorded.
2. **A write's returned `Future` only resolves on server acknowledgment**, even though the local cache (and any UI listening to it) updates instantly. `await`-ing a plain `.set()`/`.update()` for UI purposes would hang indefinitely while offline.

So `SaleRepoImpl.logSale()` ([lib/data/repo_impl/sale_repo_impl.dart](lib/data/repo_impl/sale_repo_impl.dart)) does both, in order:

- **Online:** tries a Firestore transaction first — reads the live stock, rejects with `InsufficientStockException` if there isn't enough, otherwise atomically decrements stock and records the sale. This is the strict, race-free path.
- **Offline (or any other transaction failure):** falls back to a `WriteBatch` using `FieldValue.increment(-quantitySold)`, which is commutative and queues correctly offline — safe even if two offline sales for the same product later replay against a server value that moved in between. This write is fired but *not* awaited, so `logSale()` always returns promptly and the UI never hangs waiting for a network round trip.

**The trade-off, stated plainly:** the offline fallback does *not* re-check "is there enough stock" — a stale local read can't be trusted if another device (or the same shop's second phone) sold stock while this device was offline. That means **stock can go negative if you oversell while offline**. I chose to let that happen rather than block sale-logging offline entirely, because blocking would violate the core requirement ("must work fully offline"). For a single-shop app this is a reasonable trade-off to accept and document rather than solve — a real fix (server-side reconciliation, e.g. a Cloud Function that clamps at zero and flags the discrepancy) is a "2 more days" item below.

Every other repo write (`addProduct`, `updateProduct`, `deleteProduct`) follows the same "fire, don't await server ack" pattern via a small `fireAndForget()` helper — they resolve as soon as the local cache write is issued.

**Conflict resolution beyond stock deduction** is Firestore's default last-write-wins per field, which is what you get "for free" with `persistenceEnabled`. I didn't build custom field-level merge logic on top — for a shop's product name/price/threshold, last-write-wins is fine, and the sale-logging path above is the one place where naive last-write-wins would actually be wrong (which is why it gets the increment-based treatment instead of a plain overwrite).

One more small, deliberate choice: sale timestamps are set client-side (`DateTime.now()`), not via `FieldValue.serverTimestamp()`. Server timestamps resolve to `null` in the local cache until the write reaches the server, which would break sorting/display for a sale logged while offline. The trade-off is trusting the device clock (small skew risk) — acceptable for a single shop's sales log.

The product list also shows a small "Offline — showing saved data" banner (driven by `snapshot.metadata.isFromCache`) so it's visible when you're looking at cached-but-not-yet-confirmed data.

`isFromCache` reflects Firestore's *own* listener state, not raw device connectivity — it only flips once the SDK's stream actually notices it has failed, which on a real device is prompt (the SDK watches OS network-change callbacks) but on an emulator can lag tens of seconds, since toggling airplane mode there often doesn't fire that callback and the SDK has to wait for an operation to time out instead. `ConnectivityService` (`core/services/connectivity_service.dart`) bridges `connectivity_plus`'s own OS-level signal into `FirebaseFirestore.enableNetwork()`/`disableNetwork()`, forcing that detection to be immediate rather than passive. This is the one place `connectivity_plus` earns its keep in an otherwise Firestore-only sync design — it's not used for gating any business logic, only for nudging the SDK's own state to match reality faster.

## 3. If I had 2 more days

Roughly in priority order:

1. **Real auth + locked-down security rules.** This is the biggest gap and the first thing I'd close.
2. **Server-side stock reconciliation.** A Cloud Function that watches for negative stock (the offline-oversell case above) and either clamps it, flags it for the shop owner, or computes a "backorder" amount — so the trade-off in section 2 stops being purely "documented" and becomes actually handled.
3. **A global sales report/history screen** with date filtering and totals, using a `collectionGroup` or a top-level query across all sales (the schema already supports this — `sales` is a flat collection with a `productId` field, precisely so this doesn't require a schema migration).
4. **Sales-velocity-based low-stock thresholds** (e.g. "reorder when fewer than N days of average sales remain") instead of the static per-product number, which is a reasonable but simplistic default.
5. **Server-authoritative timestamps** for sales (via a Cloud Function backfill) instead of trusting the device clock, once reconnected.
6. **Tap-to-open on the low-stock notification**, deep-linking into the product detail page.
7. More polish on the UI (empty/loading states are functional but plain, no animations) and broader test coverage (cubit tests with `bloc_test`, more repo edge cases).
# social_braynz
