# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key    => '_expense_session',
  :secret => '914cc04be466b4ca94762096e3691ea150183795772e79be2c94296e732ea94e895b1ebef3de6e14ca14a136b81ee86b81184efbea1a6c9131da0c443b99cbe1'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store