# LazyChain :chains:

**Render every page immediately, even if your code is slow.**

> ⚠️ **Not usable yet.** `0.0.1` reserves the gem name and ships an empty engine — installing it does nothing. The API described below is the direction, not a promise, and it will change before `1.0`. Watch the repo if you want to know when it's real.

## The problem

Every mature Rails app has a page like this:

```erb
<td><%= number_to_currency estimate.pricing.all.total_amount %></td>
<td><%= number_to_currency estimate.pricing.all.margin_amount %></td>
<td><%= number_to_currency estimate.pricing.all.tax_amount %></td>
```

Three innocent-looking method calls. Each one walks a tree of associations, and each one takes 800ms. The page takes nine seconds to paint, and the user stares at a blank screen the whole time — including the header, the navigation, and the twenty other values that were ready instantly.

You know how to fix it. Memoize it, denormalize it, precompute it in a background job, rewrite it as one heroic SQL query. All of that is real work, and all of it is work you were not planning to do this week.

## The idea

The page is not slow. A handful of method calls on the page are slow. LazyChain lets you say which ones, and gets them out of the critical path:

```erb
<td><%= lazy_chain estimate, "pricing.all.total_amount" %></td>
<td><%= lazy_chain estimate, "pricing.all.margin_amount" %></td>
<td><%= lazy_chain estimate, "pricing.all.tax_amount" %></td>
```

The page renders now. Each deferred value arrives on its own, as soon as it's ready, in the spot where it belongs. All you need to do is opt-in to the provided route concern and use the view helper. Everything else is magic :magic_wand:.

```ruby
  resources :estimates, concerns: %i[lazy_chain]
```

That's the whole pitch. No new service objects, no background job infrastructure, no cache to invalidate by hand, no JavaScript to write. You point at the slow call and move on with your day.

## What you get

- **A one-line change at the call site.** Wrap the expensive call. Delete the wrapper later when you get around to making it fast. Nothing else in your app needs to know.
- **Nine seconds becomes nine parallel requests.** The browser fetches deferred values concurrently, so the slowest one sets your page time — not the sum of all of them.
- **Values that show up where they belong.** Each one lands in its own slot in the markup. No spinners bolted onto the layout, no reflow, no partial rewrites.
- **Below-the-fold work that never happens.** Values further down the page aren't computed until the user scrolls to them.
- **Safe by construction.** Method chains are signed automatically, and signatures are validated before execution.
- **Turbo-native and boring.** Standard Turbo Frames, standard Rails caching, standard controllers. Nothing you'd be surprised to find in a `curl`.

## What it isn't

LazyChain is not a performance fix — it's a way to stop paying for one up front. The slow method is still slow, and it will still be slow after you install this. What changes is that your user isn't waiting on it to see the rest of the page.

If a value is slow *and* the user is blocked on reading it, make it fast. If it's slow and merely nice to have on screen eventually — which describes an enormous number of totals, rollups, and derived figures in real applications — defer it.

## Installation

```ruby
gem "lazy_chain"
```

```bash
$ bundle install
```

Requires Rails 8.1+ and Turbo.

## Status & roadmap

LazyChain is being extracted from a production estimating application, where it defers several hundred pricing rollups across the app and has been in daily use by a real sales team.

The extraction is in progress. Coming before the first usable release:

- [ ] The `lazy_chain` view helper and its underlying view object
- [ ] The controller and routing concern that resolve a deferred chain
- [ ] Signed method chains, verified before anything is called
- [ ] A pluggable cache strategy, so a computed value is computed once
- [ ] Pluggable formatting, with sensible defaults
- [ ] Test helpers for making deferred values behave in system specs
- [ ] Documentation worth the name

## Contributing

Not yet — there's nothing to contribute to. Once the extraction lands, issues and pull requests are welcome. Until then, if the pitch above describes a page in your app, open an issue and tell me about it. That's genuinely useful.

## License

Released under the [MIT License](https://opensource.org/licenses/MIT).
