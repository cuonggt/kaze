InertiaRails.configure do |config|
  # Inertia.js v3 reads the initial page from a `<script type="application/json">`
  # element rather than a `data-page` attribute, and expects the head attribute to
  # be `data-inertia`. Both default to the v2 behaviour in inertia_rails, so the
  # client renders nothing without these.
  config.use_script_element_for_initial_page = true
  config.use_data_inertia_head_attribute = true

  # Becomes the default in InertiaRails 4.0.
  config.always_include_errors_hash = true
end
