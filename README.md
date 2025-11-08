Stripe Checkout (Sinatra) integration — local run instructions

What this repo change contains

- server.rb - minimal Sinatra server that exposes POST /create-checkout-session and returns a Checkout Session URL (expects environment variable STRIPE_SECRET_KEY).
- success.html / cancel.html - static pages used as Checkout return URLs.
- HeatProtectant.html - product page updated with a "Buy with Card" button that posts a price_id to the server to create a Checkout Session.

Quick start (macOS, zsh)

1) Ensure you have Ruby (rbenv) and gems available. If you previously installed Ruby with rbenv as instructed, activate it in your shell:

   eval "$(rbenv init -)"
   rbenv local 3.2.2   # or the version you installed

2) Install dependencies (Sinatra and Stripe gem) if not already installed:

   gem install sinatra
   gem install stripe

3) Set your Stripe secret key as an environment variable (use test key for development):

   export STRIPE_SECRET_KEY="sk_test_xxx..."

4) Run the server locally from the repository root:

   ruby server.rb

   By default the server listens on port 4567. You should see logs when requests arrive.

5) Update HeatProtectant.html to use a real Price ID from your Stripe Dashboard:

   - Open HeatProtectant.html and find the button with id `stripe-checkout-button`.
   - Replace the `data-price-id` value (currently `price_XXXXXXX`) with your real Price ID (starts with `price_`).

6) Test Checkout flow

   - Open your product page in the browser (served via a local static server or by opening the file in the browser). The page's Checkout button will POST to `http://localhost:4567/create-checkout-session`.
   - If your site is a file:// path, most browsers will still POST to localhost. If you need Stripe to call back webhooks or redirect to your server URLs, use ngrok to expose the local server publicly.

Notes & troubleshooting

- Do NOT commit your Stripe secret key to the repository. Use environment variables.
- If you get CORS or mixed content issues when calling the server from a file:// origin, serve the static pages using a simple static server (for example `python3 -m http.server 8000` in the repo root) and open http://localhost:8000/HeatProtectant.html.
- To test webhooks or have Stripe open the success/cancel pages on public URLs, run:

   ngrok http 4567

  Then set the success/cancel URLs in the server.rb or your Stripe Dashboard to the ngrok URL.

- The server currently expects a form-encoded POST with `price_id`. You can change it to JSON if desired.

If you want, I can:
- Insert the real Price ID into the page for you (if you provide it),
- Start the server here in a terminal and test the create-checkout-session flow (you'll still need to run it locally), or
- Add a small static server script, or a Dockerfile for easier local runs.
