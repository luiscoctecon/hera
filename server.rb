# Minimal Sinatra server to create Stripe Checkout Sessions
# Run with: STRIPE_SECRET_KEY=sk_test_xxx ruby server.rb

require 'sinatra'
require 'stripe'
require 'json'
require 'logger'

set :bind, '0.0.0.0'
set :port, ENV.fetch('PORT', 4242)

logger = Logger.new($stdout)
if ENV['STRIPE_SECRET_KEY'] && ENV['STRIPE_SECRET_KEY'].strip.length > 0
  Stripe.api_key = ENV['STRIPE_SECRET_KEY']
else
  # don't raise on missing key here; log a helpful message and allow the server to start
  logger.error("STRIPE_SECRET_KEY is not set in the environment. Checkout sessions will fail until it is configured.")
  Stripe.api_key = nil
end

post '/create-checkout-session' do
  content_type :json

  # Accept price_id from body (form-encoded or JSON)
  price_id = params['price_id'] || (begin
    request.body.rewind
    body = request.body.read
    if body && body.length > 0
      JSON.parse(body)['price_id'] rescue nil
    end
  end)

  halt 400, { error: 'Missing price_id' }.to_json unless price_id
  unless Stripe.api_key && Stripe.api_key.to_s.length > 0
    logger.error("Attempt to create Checkout Session but STRIPE_SECRET_KEY is not configured")
    halt 500, { error: 'Server not configured with Stripe secret key' }.to_json
  end

  begin
    session = Stripe::Checkout::Session.create(
      {
        line_items: [
          { price: price_id, quantity: 1 }
        ],
        mode: 'payment',
        success_url: "#{request.base_url}/success.html",
        cancel_url: "#{request.base_url}/cancel.html"
      }
    )

    # Log the session id and URL for debugging (safe: does not include secret key)
    logger.info("Created Checkout Session: id=#{session.id} url=#{session.url}")
    { url: session.url }.to_json
  rescue Stripe::StripeError => e
    logger.error("Stripe error: #{e.class} - #{e.message}")
    halt 502, { error: 'Payment provider error', detail: e.message }.to_json
  rescue => e
    logger.error("Unexpected error creating Checkout Session: #{e.class} - #{e.message}")
    halt 500, { error: 'Server error', detail: e.message }.to_json
  end
end

get '/' do
  '<h2>Sinatra Stripe Server</h2><p>POST /create-checkout-session with price_id to create a session.</p>'
end
