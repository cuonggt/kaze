Rails.application.routes.draw do
  get 'up' => 'rails/health#show', as: :rails_health_check

  root 'welcome#index'

  get 'register', to: 'auth/registered_user#new', as: :register
  post 'register', to: 'auth/registered_user#create'

  get 'login', to: 'auth/authenticated_session#new', as: :login
  post 'login', to: 'auth/authenticated_session#create'

  get 'forgot-password', to: 'auth/password_reset_link#new', as: :password_request
  post 'forgot-password', to: 'auth/password_reset_link#create', as: :password_email

  get 'reset-password/:token', to: 'auth/new_password#new', as: :password_reset
  post 'reset-password', to: 'auth/new_password#create', as: :password_store

  get 'verify-email', to: 'auth/email_verification_notification#new', as: :verification_notice
  post 'verify-email', to: 'auth/email_verification_notification#create', as: :verification_send
  get 'verify-email/:id/:hash', to: 'auth/verified_email#create', as: :verification_verify

  get 'two-factor-challenge', to: 'auth/two_factor_challenge#new', as: :two_factor_challenge
  post 'two-factor-challenge', to: 'auth/two_factor_challenge#create', as: :two_factor_challenge_store

  post 'logout', to: 'auth/authenticated_session#destroy', as: :logout

  get 'dashboard', to: 'dashboard#index', as: :dashboard

  get 'settings', to: redirect('/settings/profile')

  scope 'settings', module: 'settings' do
    get 'profile', to: 'profile#edit', as: :profile_edit
    patch 'profile', to: 'profile#update', as: :profile_update
    delete 'profile', to: 'profile#destroy', as: :profile_destroy

    get 'password', to: 'password#edit', as: :password_edit
    put 'password', to: 'password#update', as: :password_update

    get 'two-factor', to: 'two_factor#edit', as: :two_factor_edit
    post 'two-factor', to: 'two_factor#create', as: :two_factor_store
    patch 'two-factor', to: 'two_factor#update', as: :two_factor_update
    delete 'two-factor', to: 'two_factor#destroy', as: :two_factor_destroy
    post 'two-factor/recovery-codes', to: 'two_factor#recovery_codes', as: :two_factor_recovery_codes

    get 'appearance', to: 'appearance#edit', as: :appearance_edit
  end
end
