# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_postrails_session',
  :secret      => '5e3b7730fd2603af3de7a12b8d666845ced2907d50b6ce94746c21908f42cbbc413b3fabcf2e44b34bf1dd95b90d4ae247e55e63452b0cb8a8e63471fbc27786'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
